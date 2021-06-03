#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow
requirements:
  SchemaDefRequirement:
    types:
    - $import: ipic-types.yml

inputs:
  $IMPORT: all-inputs.yml

steps:
  pre:
    run: ipic-input-gen.cwl
    in:
      $IMPORT: input-map.yml
    out: [nproc, inp_data]

  main:
    run: ipic-solo.cwl
    in:
      nproc: pre/nproc
      inp_data: pre/inp_data
    out:
      - data

outputs:
  data:
    type: File[]
    outputSource: main/data
