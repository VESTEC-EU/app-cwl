#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: ExpressionTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  InlineJavascriptRequirement: {}
  SchemaDefRequirement:
    types:
      - $import: ipic-types.yml

inputs:
  $IMPORT: all-inputs.yml

expression: |
  ${
    var ans = "";
    for (var prop in inputs) {
      var val = inputs[prop];
      // Skip omitted optionals
      if (val !== null) {
        if (Array.isArray(val)) {
          // arrays get joined by spaces
          val = val.join(" ");
        }
        ans += prop.concat(" = ", val, "\n");
      }
    }
    return {
      nproc: inputs.XLEN * inputs.YLEN * inputs.ZLEN,
      inp_data: ans
    };
  }

outputs:
  nproc:
    type: int
  inp_data:
    type: string
