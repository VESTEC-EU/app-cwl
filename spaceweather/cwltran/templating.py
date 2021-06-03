from typing import Sequence

from . import YT, Yaml, YamlList, yaml

class Template(YT):
    def __init__(self, name, params, body):
        self.name = name
        self.params = set()
        for p in params:
            assert isinstance(p, str)
            assert p not in self.params
            self.params.add(p)
        self.body = body

    def transform_str(self, s):
        if s.startswith("$"):
            if s.startswith("$$"):
                # It's a format string
                return s[2:].format(**self._subs)
            key = s[1:]
            if key in self._subs:
                return self._subs[key]
        return s

    def __call__(self, substitutions):
        self._subs = substitutions
        return self.transform(self.body)

    
class TemplateReader(YT):
    def __init__(self):
        self.decls = []

    def declare(self, decl):
        name = decl["name"]
        assert isinstance(name, str)
        plist = decl["params"]
        assert isinstance(plist, Sequence) and not isinstance(plist, str)
        assert len(plist) > 0
        assert "body" in decl
        self.decls.append(Template(name, plist, decl["body"]))
        
    def transform_dict(self, d):
        ans = {}
        for k, v in d.items():
            if k == "$TEMPLATE":
                assert len(d) == 1
                self.declare(v)
            else:
                ans[k] = self.transform(v)
        return ans

def read_template(tpath):
    with open(tpath) as f:
        tdata = yaml.load(f)
    reader = TemplateReader()
    reader.transform(tdata)
    return reader.decls


class Templater(YT):
    def __init__(self, decls):
        self.templates = {d.name: d for d in decls}

    def transform_dict(self, d):
        ans = {}
        for k, v in d.items():
            if k == "$TEMPLATE":
                assert len(d) == 1
                self.declare(v)
            elif k.startswith("$$"):
                assert len(d) == 1
                return self.substitute(k[2:], v)
            else:
                ans[k] = self.transform(v)
        return ans

    def substitute(self, tname, params):
        t = self.templates[tname]
        tmp = params.copy()
        for p in t.params:
            tmp.pop(p)
        assert len(tmp) == 0
        
        return t(params)
