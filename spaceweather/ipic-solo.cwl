#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#

hints:
  SoftwareRequirement:
    packages:
      ipic3d: {}

requirements:
  InlineJavascriptRequirement: {}

  cwltool:MPIRequirement:
    processes: $(inputs.nproc)

  InitialWorkDirRequirement:
    listing:
      - class: Directory
        basename: data
        listing: []
      - entryname: input.inp
        entry: $(inputs.inp_data)

baseCommand: iPIC3D
arguments: [input.inp]

inputs:
  nproc:
    type: int
    default: 1

  inp_data:
    type: string

outputs:
  data:
    type: File[]
    outputBinding:
      glob: data/*
