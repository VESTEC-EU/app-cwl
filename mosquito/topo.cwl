#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquito-topo:
        version: ["0.2.0"]

inputs:
  region:
    type: string
    inputBinding:
      prefix: -a
  species:
    type: string
    inputBinding:
      prefix: -s
  disease:
    type: string
    inputBinding:
      prefix: -d
  inputs:
    type: File[]
    inputBinding: {}

baseCommand: mos-topo

outputs:
  cdb_zip:
    type: File
    outputBinding:
      glob: "pdiags_$(inputs.region)_$(inputs.disease).cdb.zip"
