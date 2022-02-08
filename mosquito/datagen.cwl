#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquitopost:
        version: ["add-preprocessing-and-nc-output"]

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - $include: mkdirs.js
  InitialWorkDirRequirement:
    listing:
      - ${return mkdirs(["output"])}

inputs:
  global_tif_folder:
    type: Directory
    inputBinding:
      prefix: --input-tif-folder

  coord_rect_file:
    type: File
    inputBinding:
      prefix: --coord-rect-file

baseCommand: data_generator

arguments:
  - "--ids-pkl-folder"
  - output
  - "--maschera-pkl-folder"
  - output
  - "--output-folder"
  - output

outputs:
  IDS:
    type: File
    outputBinding:
      glob: "output/IDS_rect_*_*.pkl"

  MASCHERA:
    type: File
    outputBinding:
      glob: "output/MASCHERA_rect_*_*.pkl"

  lm_covariates:
    type: File
    outputBinding:
      glob: "output/lm_covariates_rect_*_*_not_filtered.csv"

  wc_temp:
    type: File
    outputBinding:
      glob: "output/wc_temp_rect_*_*.csv"

  temp_mean_tif:
    type: File
    outputBinding:
      glob: "output/temp_mean_*.tif"

  temp_maximum_tif:
    type: File
    outputBinding:
      glob: "output/temp_maximum_*.tif"

  rain_mean_tif:
    type: File
    outputBinding:
      glob: "output/rain_mean_*.tif"

  popul_tif:
    type: File
    outputBinding:
      glob: "output/population_*.tif"

  gdp_tif:
    type: File
    outputBinding:
      glob: "output/gdp_not_filtered_*.tif"

  monthly_temp_tif:
    type: File
    outputBinding:
      glob: "output/wc_temp_*.tif"
