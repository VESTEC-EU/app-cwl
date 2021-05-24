#!/usr/bin/env python3
import os.path
import sys
from ruamel.yaml import YAML
yaml = YAML()

if __name__ == "__main__":
    base, _ = os.path.splitext(__file__)
    types_path = sys.argv[1]
    with open(types_path) as f:
        types = yaml.load(f)
    with open(base+".yml", "w") as f:
        yaml.dump({k: k for k in types}, f)
