#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#

hints:
  SoftwareRequirement:
    packages:
      mosquito:
        version: ["0.2.0"]

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - $include: mkdirs.js
  InitialWorkDirRequirement:
    listing:
      - ${return mkdirs(["exp", inputs.species, "density_R0_" + inputs.region])}
      - entry: $(inputs.species_user_parameters)
        entryname: input_files/$(inputs.species)_parameter.txt
      - entry: $(inputs.species_fixed_parameters)
        entryname: input_files/$(inputs.species)_parameter_fixed.txt
      - entry: $(inputs.species_alpha_distribution)
        entryname: input_files/$(inputs.species)_alpha_w_k_m_wc_lm_within_fit_cumulato_best_dic.txt
      - entry: $(inputs.species_covariate_distribution) 
        entryname: input_files/$(inputs.species)_coeff_covariate_wc_lm_within_fit_cumulato_best_dic.txt
      - entry: $(inputs.disease_species_user_parameters) 
        entryname: input_files/$(inputs.disease)_$(inputs.species)_parameter_user.txt
      - entry: $(inputs.region_covariates)
        entryname: input_files/$(inputs.region)/lm_covariates_$(inputs.region)_not_filtered.csv
      - entry: $(inputs.temperature_data)
        entryname: input_files/$(inputs.region)/wc_temp_$(inputs.region).csv

inputs:
  region:
    type: string
    inputBinding:
      prefix: -a
  region_covariates:
    type: File
  temperature_data:
    type: File
  species:
    type: string
    inputBinding:
      prefix: -s
  species_user_parameters:
    type: File
  species_fixed_parameters:
    type: File
  species_alpha_distribution:
    type: File
  species_covariate_distribution:
    type: File
  disease:
    type: string
    inputBinding:
      prefix: -d
  disease_species_user_parameters:
    type: File
  count:
    type: int
    inputBinding:
      prefix: -ns

baseCommand: R0

arguments: [-bd, ., -rt, n]

outputs:
  reproduction_number:
    type: File
    outputBinding:
      glob: "exp/$(inputs.species)/density_R0_$(inputs.region)/R0_$(inputs.disease).txt"
  mean_abundance:
    type: File
    outputBinding:
      glob: "exp/$(inputs.species)/density_R0_$(inputs.region)/density.txt"
