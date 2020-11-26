#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      ncl:
        version: ["6"]

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.diachronic_backups)
      - entryname: selec4fire.ncl
        entry:
          $include: selec4fire.ncl
inputs:
  diachronic_backups:
    type: File[]
  output_name:
    type: string

outputs:
  extract:
    type: File
    outputBinding:
      glob: $(inputs.output_name)


baseCommand:
  - ncl
arguments:
  - 'fout_name="$(inputs.output_name)"'
  - selec4fire.ncl
