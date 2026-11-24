import shutil
import argparse
import subprocess
import sys
from pathlib import Path

PROJECT_DIR = Path(__file__).resolve().parents[2]
SOURCE_DIR = PROJECT_DIR / "src" / "infra"

DEST_DIR = PROJECT_DIR / "dist" / "infra"
DEST_FILE = str(f'{DEST_DIR}/main.json')

def run_cmd(cmd: list[str], ):
    result = subprocess.run(cmd)
    if result.returncode != 0:
        return ['failed', result.stderr]
    return ['success', result.stdout]



def build_infra():
    cmds = ['az', 'bicep', 'build', '--file',  str(f'{SOURCE_DIR}/main.bicep'), '--outfile', str(DEST_FILE)]
    if DEST_DIR.exists():
        shutil.rmtree(Path(DEST_DIR))
    DEST_DIR.mkdir(exist_ok=True, parents=True)
    try:
        bicep_build = run_cmd(cmds)
        if bicep_build[0] == 'failed':
            print(f"build failed: {bicep_build[1]}")
            sys.exit(1)
        if Path(DEST_FILE).exists():
            print("Bicep Compiled to ARM successfully")
    except Exception:
        raise Exception("Issue completing build")
    
build_infra()
    