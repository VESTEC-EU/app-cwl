#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow
requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  lat_first_point:
    type: float

  lon_first_point:
    type: float

  lat_second_point:
    type: float

  lon_second_point:
    type: float

  n_max_tiles:
    type: int

  global_tif_folder:
    type: Directory

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
  rects:
    run: rectgen.cwl
    in:
      lat_first_point: lat_first_point
      lon_first_point: lon_first_point
      lat_second_point: lat_second_point
      lon_second_point: lon_second_point
      n_max_tiles: n_max_tiles
    out:
      - rectangles

  tile:
    run: process-tile.cwl
    scatter: coord_rect_file
    in:
      global_tif_folder: global_tif_folder
      coord_rect_file: rects/rectangles
      region:
        valueFrom: $(inputs.coord_rect_file.nameroot)
      species: species
      species_user_parameters: species_user_parameters
      species_fixed_parameters: species_fixed_parameters
      species_alpha_distribution: species_alpha_distribution
      species_covariate_distribution: species_covariate_distribution
      disease: disease
      disease_species_user_parameters: disease_species_user_parameters
      count: count
    out:
      - temp_mean_tif
      - temp_maximum_tif
      - rain_mean_tif
      - popul_tif
      - gdp_tif
      - monthly_temp_tif
      - r0_tif
      - density_tif

  mosaic_temp_mean:
    run: mosaic.cwl
    in:
      tiffs: tile/temp_mean_tif
    out:
      - mosaic

  mosaic_temp_maximum:
    run: mosaic.cwl
    in:
      tiffs: tile/temp_maximum_tif
    out:
      - mosaic

  mosaic_rain_mean:
    run: mosaic.cwl
    in:
      tiffs: tile/rain_mean_tif
    out:
      - mosaic

  mosaic_popul:
    run: mosaic.cwl
    in:
      tiffs: tile/popul_tif
    out:
      - mosaic

  mosaic_gdp:
    run: mosaic.cwl
    in:
      tiffs: tile/gdp_tif
    out:
      - mosaic

  mosaic_monthly_temp:
    run: mosaic.cwl
    in:
      tiffs: tile/monthly_temp_tif
    out:
      - mosaic

  mosaic_r0:
    run: mosaic.cwl
    in:
      tiffs: tile/r0_tif
    out:
      - mosaic

  mosaic_density:
    run: mosaic.cwl
    in:
      tiffs: tile/density_tif
    out:
      - mosaic

outputs:
  temp_mean:
    type: File[]
    outputSource: mosaic_temp_mean/mosaic

  temp_maximum:
    type: File[]
    outputSource: mosaic_temp_maximum/mosaic

  rain_mean:
    type: File[]
    outputSource: mosaic_rain_mean/mosaic

  popul:
    type: File[]
    outputSource: mosaic_popul/mosaic

  gdp:
    type: File[]
    outputSource: mosaic_gdp/mosaic

  monthly_temp:
    type: File[]
    outputSource: mosaic_monthly_temp/mosaic

  r0:
    type: File[]
    outputSource: mosaic_r0/mosaic

  density:
    type: File[]
    outputSource: mosaic_density/mosaic
