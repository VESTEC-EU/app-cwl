#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      ncl:
        version: ["6.4.0"]

requirements:
  InlineJavascriptRequirement: {}
  EnvVarRequirement:
    envDef:
      NCARG_USRRESFILE: $(inputs.ncl_resfile.path)
      NCARG_ROOT: $(inputs.ncl_root.path)
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
  ncl_root:
    type: Directory
  ncl_resfile:
    type: File

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
