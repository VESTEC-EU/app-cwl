#!/usr/bin/env python3
from ruamel.yaml import YAML
yaml = YAML()

def dumb_include(d):
    if isinstance(d, list):
        return [dumb_include(x) for x in d]
    if isinstance(d, dict):
        ans = {}
        for k, v in d.items():
            if k == "$IMPORT":
                assert len(d) == 1
                with open(v) as f:
                    return yaml.load(f)
            else:
                ans[k] = dumb_include(v)

        return ans
    return d

def process(source, dest):
    with open(source) as f:
        data = yaml.load(f)
    updated = dumb_include(data)
    with open(dest, "w") as f:
        yaml.dump(updated, f)

if __name__ == "__main__":
    import sys
    process(sys.argv[1], sys.argv[2])

    
