#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquitopost:
        version: ["0.4.0"]

inputs:
  C_OUT:
    type: File
    inputBinding:
      prefix: --c-output
  IDS:
    type: File
    inputBinding:
      prefix: --ids-pkl
  MASCHERA:
    type: File
    inputBinding:
      prefix: --maschera-pkl
  outbase:
    type: string
    inputBinding:
      prefix: --output-basepath

baseCommand: tif_generator

outputs:
  tif:
    type: File
    outputBinding:
      glob: $(inputs.outbase).tif
  png:
    type: File
    outputBinding:
      glob: $(inputs.outbase).png
