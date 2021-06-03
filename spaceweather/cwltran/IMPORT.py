from contextlib import contextmanager
from pathlib import Path

from . import YT, Yaml, YamlDict, yaml

class IMPORT(YT):
    """Replace objects like

        {"$IMPORT": "relpath/to/yaml"}

    with the contents of the referred to YAML.
    """
    def __init__(self, import_path: Path) -> None:
        self.import_path = import_path

    @contextmanager
    def extra_path(self, pth):
        old = self.import_path
        self.import_path = pth
        yield
        self.import_path = old

    def transform_dict(self, d: YamlDict) -> Yaml:
        if "$IMPORT" in d:
            assert len(d) == 1
            v = d["$IMPORT"]
            assert isinstance(v, str)
            p = self.import_path / Path(v)
            with open(p) as f:
                child_d = yaml.load(f)
                with self.extra_path(p.parent):
                    return self.transform(child_d)
        else:
            return super().transform_dict(d)
