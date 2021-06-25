#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquitopost:
        version: ["0.2.1"]

inputs:
  tiffs:
    type: File[]
    inputBinding: {}

  output_pattern:
    type: string
    default: 

baseCommand: mosaic_tiff_generator

arguments: [--output, "output_band_%02d.tif"]

outputs:
  mosaic:
    type: File[]
    outputBinding:
      glob: "output_band_*.tif"
