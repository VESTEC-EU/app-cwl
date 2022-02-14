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
  tiffs:
    type: File[]
    inputBinding:
      prefix: --input-tiffs

  output_basepath:
    type: string
    default: output
    inputBinding:
      prefix: --output-basepath

baseCommand: mosaic_tiff_generator
arguments: ["--nc-output-file", "True", "--tif-output-file", "False", "--one-file-per-band", "True"]

outputs:
  mosaic_nc:
    type: File[]
    outputBinding:
      glob: "$(inputs.output_basepath)*.nc"
