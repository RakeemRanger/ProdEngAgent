# Ranger AI Agent Infrastructure

This repository is the infrastructure starter for Ranger AI's agentic Foundry environment. The initial work puts Azure governance and deployment controls in place before expanding into the agent application.

## Current Scope

The Bicep templates currently:

- Create the configured resource group and a user-assigned managed identity.
- Define and assign a subscription-level Azure Policy that denies Cognitive Services accounts unless local authentication is disabled (`disableLocalAuth: true`).
- Compile the subscription deployment to an ARM JSON template for release.

The repository currently contains infrastructure templates and pipeline automation; the agent runtime is not part of this starter yet.

## Repository Layout

```text
.pipelines/
  build/
    build.py
    Rai.UnOfficial.Build.yml
  release/
    Rai.UnOfficial.Release.yml
src/
  infra/
    main.bicep
    managedIdentiy/msi.bicep
    policy/foundryDisableLocalAuth.bicep
```

## Build Locally

Prerequisites: Python 3 and Azure CLI with the Bicep CLI available (`az bicep install`). From the repository root:

```bash
az bicep install
python3 .pipelines/build/build.py
```

The compiled template is written to `dist/infra/main.json`.

Preview a subscription deployment before applying it:

```bash
az deployment sub what-if \
  --location eastus \
  --template-file dist/infra/main.json
```

To deploy, replace `what-if` with `create`. Review the changes carefully before applying them; the policy assignment affects Cognitive Services accounts across the subscription.

## Azure DevOps Pipelines

The YAML pipelines are under `.pipelines/` and are configured for manual runs (`trigger: none`, `pr: none`). Register each YAML file as an Azure DevOps pipeline in the `RAI` project.

The build pipeline compiles Bicep, generates an SPDX SBOM, and publishes the `infrastructure` artifact. The release pipeline downloads that artifact, runs `az deployment sub what-if`, then deploys `main.json` using the `rai-ccf-arm-dev` Azure service connection. Its pipeline resource `source` must match the registered build pipeline name in Azure DevOps. The release uses the `development` environment, which must exist and be authorized for the pipeline.

The deployment service principal needs `Contributor` for the subscription deployment and resource creation, plus `Resource Policy Contributor` at subscription scope to write policy definitions and assignments. A subscription owner or user access administrator must grant these roles.

## Configuration

Default deployment values are declared in `src/infra/main.bicep`:

- Region: `eastus`
- Resource group: `rai.dev.rg`
- Managed identity: `rai-dev-msi`

Update these defaults or add Bicep parameters when targeting another environment. Keep the release pipeline's `--location` aligned with the intended deployment location.