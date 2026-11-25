#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 || ( $# -eq 3 && $3 != '--dry-run' ) ]]; then
  printf 'Usage: bash %s <organization-url> <project> [--dry-run]\n' "$0" >&2
  exit 2
fi

organization=$1
project=$2
dry_run=${3:-}
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
pipeline_dir=$(cd "$script_dir/../.pipelines" && pwd)
repo_name=$(basename "$(dirname "$pipeline_dir")")

if ! command -v az >/dev/null 2>&1; then
  printf 'Azure CLI is required. Install it and the azure-devops extension first.\n' >&2
  exit 1
fi

if ! az extension show --name azure-devops --output none 2>/dev/null; then
  printf 'The azure-devops CLI extension is required: az extension add --name azure-devops\n' >&2
  exit 1
fi

existing_folders=$(az pipelines folder list \
  --organization "$organization" --project "$project" \
  --query '[].path' --output tsv)

while IFS= read -r directory; do
  if [[ $directory == "$pipeline_dir" ]]; then
    folder_path="\\$repo_name"
  else
    relative_path=${directory#"$pipeline_dir"/}
    folder_path="\\$repo_name\\${relative_path//\//\\}"
  fi

  if printf '%s\n' "$existing_folders" | grep -Fxiq -- "$folder_path"; then
    printf 'Exists: %s\n' "$folder_path"
  elif [[ $dry_run == '--dry-run' ]]; then
    printf 'Would create: %s\n' "$folder_path"
  else
    az pipelines folder create --organization "$organization" --project "$project" \
      --path "$folder_path" --output none
    printf 'Created: %s\n' "$folder_path"
  fi
done < <(find "$pipeline_dir" -type d | LC_ALL=C sort)