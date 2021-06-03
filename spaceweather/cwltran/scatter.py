from typing import Mapping, Sequence

from . import YT, Yaml, YamlDict

class Scatter(YT):
    """Replace objects like:

    $SCATTER:
        over: [input_name0, input_name1]
        fields: Mapping[str, input]

    With the contents of "fields", but the input from "over" (which must
    exist) promoted to a list-of-whatever.
    """

    def do_over(self, inp, outp):
        # Get the type of the field
        scalar_t = inp["type"]
        # get non-optional scalar type
        is_optional = False
        if isinstance(scalar_t, str):
            if scalar_t.endswith("?"):
                scalar_t = scalar_t[:-1]
                is_optional = True
        elif isinstance(scalar_t, Sequence):
            scalar_t = scalar_t.copy()
            while "null" in scalar_t:
                scalar_t.remove("null")
                is_optional = True
            if len(scalar_t) == 1:
                scalar_t = scalar_t[0]
        else:
            raise NotImplemented("Handling more complex types")

        vector_t = {
            "type": "array",
            "items": scalar_t,
        }

        outp["type"] = vector_t

        if "default" in inp:
            outp["default"] = [inp["default"]]

    def transform_dict(self, d: YamlDict) -> Yaml:
        if "$SCATTER" in d:
            assert len(d) == 1
            v = d["$SCATTER"]
            assert isinstance(v, Mapping)
            fields = v["fields"]
            assert isinstance(fields, Mapping)

            overs = v["over"]
            if isinstance(overs, str):
                raise TypeError("'over' must be list not string")

            # Effectively a deep copy
            ans = super().transform_dict(fields)
            for over in overs:
                assert isinstance(over, str)
                assert over in fields
                self.do_over(fields[over], ans[over])

            return ans
        else:
            return super().transform_dict(d)
