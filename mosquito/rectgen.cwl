#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquitopost:
        version: ["0.4.0"]

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - $include: mkdirs.js
  InitialWorkDirRequirement:
    listing:
      - ${return mkdirs(["output"])}

inputs:
  lat_first_point:
    type: float
    inputBinding:
      prefix: --lat-first-point

  lon_first_point:
    type: float
    inputBinding:
      prefix: --lon-first-point

  lat_second_point:
    type: float
    inputBinding:
      prefix: --lat-second-point

  lon_second_point:
    type: float
    inputBinding:
      prefix: --lon-second-point

  n_max_tiles:
    type: int
    inputBinding:
      prefix: --number-rectangles

baseCommand: rectangle_generator

arguments: [--output-folder, output]

outputs:
  rect_list:
    type: File
    outputBinding:
      glob: output/list_rect.txt

  rectangles:
    type: File[]
    outputBinding:
      glob: "output/coord_rect_*_*.txt"
