#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow
requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  global_tif_folder:
    type: Directory
  coord_rect_file:
    type: File
  region:
    type: string

  species:
    type: string
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
  disease_species_user_parameters:
    type: File
  count:
    type: int

steps:
  data_gen:
    run: datagen.cwl
    in:
      global_tif_folder: global_tif_folder
      coord_rect_file: coord_rect_file
    out:
      - IDS
      - MASCHERA
      - lm_covariates
      - wc_temp
      - temp_mean_tif
      - temp_maximum_tif
      - rain_mean_tif
      - popul_tif
      - gdp_tif
      - monthly_temp_tif

  main_sim:
    run: mos.cwl
    in:
      region: region
      region_covariates: data_gen/lm_covariates
      temperature_data:  data_gen/wc_temp
      species: species
      species_user_parameters: species_user_parameters
      species_fixed_parameters: species_fixed_parameters
      species_alpha_distribution: species_alpha_distribution
      species_covariate_distribution: species_covariate_distribution
      disease: disease
      disease_species_user_parameters: disease_species_user_parameters
      count: count
    out:
      - reproduction_number
      - mean_abundance

  conv_r0:
    run: convert.cwl
    in:
      C_OUT: main_sim/reproduction_number
      IDS: data_gen/IDS
      MASCHERA: data_gen/MASCHERA
      outbase:
        valueFrom: r0
    out:
      - tif

  conv_density:
    run: convert.cwl
    in:
      C_OUT: main_sim/mean_abundance
      IDS: data_gen/IDS
      MASCHERA: data_gen/MASCHERA
      outbase:
        valueFrom: density
    out:
      - tif

outputs:
  temp_mean_tif:
    type: File
    outputSource: data_gen/temp_mean_tif

  temp_maximum_tif:
    type: File
    outputSource: data_gen/temp_maximum_tif

  rain_mean_tif:
    type: File
    outputSource: data_gen/rain_mean_tif

  popul_tif:
    type: File
    outputSource: data_gen/popul_tif

  gdp_tif:
    type: File
    outputSource: data_gen/gdp_tif

  monthly_temp_tif:
    type: File
    outputSource: data_gen/monthly_temp_tif

  r0_tif:
    type: File
    outputSource: conv_r0/tif

  density_tif:
    type: File
    outputSource: conv_density/tif
