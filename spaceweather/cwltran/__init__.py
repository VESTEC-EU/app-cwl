#!/usr/bin/env python3
from pathlib import Path
from typing import List, Mapping, Sequence, Union

from ruamel.yaml import YAML
yaml = YAML()

YamlList = Sequence["Yaml"]
YamlDict = Mapping[str, "Yaml"]
Yaml = Union[None, str, int, float, bool, YamlList, YamlDict]

class YT:
    """Base class to walk and transform yamlish data."""

    def transform_str(self, s: str) -> Yaml:
        return s
    def transform_int(self, x: int) -> Yaml:
        return x
    def transform_float(self, f: float) -> Yaml:
        return f
    def transform_bool(self, b: bool) -> Yaml:
        return b
    def transform_none(self, n: None) -> Yaml:
        return n

    def transform_list(self, l: YamlList) -> Yaml:
        return [self.transform(x) for x in l]

    def transform_dict(self, d: YamlDict) -> Yaml:
        return {k: self.transform(v) for k, v in d.items()}

    def transform(self, d: Yaml):
        if d is None:
            return self.transform_none(d)
        if isinstance(d, str):
            return self.transform_str(d)
        if isinstance(d, int):
            return self.transform_int(d)
        if isinstance(d, float):
            return self.transform_float(d)
        if isinstance(d, bool):
            return self.transform_bool(d)
        if isinstance(d, Sequence):
            return self.transform_list(d)
        if isinstance(d, Mapping):
            return self.transform_dict(d)
        raise TypeError("Non-yaml type {}".format(type(d)))


def strip_leading_comments(stream) -> List[str]:
    """Get any lines starting with a YAML comment."""
    pos = stream.tell()
    lines = []
    while True:
        line = stream.readline()
        if line.startswith("#"):
            lines.append(line)
            pos = stream.tell()
        else:
            break
    stream.seek(pos)
    return lines

class Processor:
    def __init__(self, passes: Sequence[YT]):
        self.passes = passes
    def __call__(self, source: Path, dest: Path) -> None:
        with open(source) as f:
            leader = strip_leading_comments(f)
            data = yaml.load(f)

        for p in self.passes:
            data = p.transform(data)

        with open(dest, "w") as f:
            f.writelines(leader)
            yaml.dump(data, f)
