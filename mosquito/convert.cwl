#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      mosquitopost:
        version: ["py"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.reproduction_number)
        entryname: "exp/$(inputs.species)/density_R0_$(inputs.region)/R0_$(inputs.disease).txt"
      - entry: $(inputs.mean_abundance)
        entryname: "exp/$(inputs.species)/density_R0_$(inputs.region)/density.txt"
      - entry: $(inputs.IDS)
        entryname: input_files/$(inputs.region)/IDS_$(inputs.region).pkl
      - entry: $(inputs.MASCHERA)
        entryname: input_files/$(inputs.region)/MASCHERA_$(inputs.region).pkl

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
  reproduction_number:
    type: File
  mean_abundance:
    type: File
  IDS:
    type: File
  MASCHERA:
    type: File

baseCommand: tif_generator

arguments: [--input-data-folder, ., --exp-folder, .]

outputs:
  tif:
    type: File
    outputBinding:
      glob: "exp/$(inputs.species)/density_R0_$(inputs.region)/$(inputs.region)_R0_$(inputs.disease).tif"
  png:
    type: File
    outputBinding:
      glob: "exp/$(inputs.species)/density_R0_$(inputs.region)/$(inputs.region)_R0_$(inputs.disease).png"
