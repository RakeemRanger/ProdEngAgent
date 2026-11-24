"""
NodeBrite Agentic Software: Build Pipeline
"""
import argparse
import os
import shutil
import sys
import subprocess


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("--name", '-n', help="name")
    args = parser.parse_args()
    if args.name:
        print(f"Hello {args.name}")

if __name__ == "__main__":
    main()