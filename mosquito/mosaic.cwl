#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquitopost:
        version: ["add-preprocessing-and-nc-output"]

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

outputs:
  mosaic:
    type: File[]
    outputBinding:
      glob: "$(inputs.output_basepath)*.tif"
