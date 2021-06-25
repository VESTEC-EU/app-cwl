#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow
requirements:
  MultipleInputFeatureRequirement: {}

inputs:
  region:
    type: string
  region_covariates:
    type: File
  temperature_data:
    type: File
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
  IDS:
    type: File
  MASCHERA:
    type: File
  intermediate_name:
    type: string
    default: intermediate

steps:
  main_sim:
    run: mos.cwl
    in:
      region: region
      region_covariates: region_covariates
      temperature_data:  temperature_data
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

  conv:
    run: convert.cwl
    in:
      C_OUT: main_sim/reproduction_number
      IDS: IDS
      MASCHERA: MASCHERA
      outbase: intermediate_name
    out:
      - tif
  mosaic:
    run: mosaic.cwl
    in:
      tiffs:
        source: [conv/tif]
        linkMerge: merge_nested

    out:
      - mosaic

  topo:
    run: topo.cwl
    in:
      region: region
      species: species
      disease: disease
      tiffs: mosaic/mosaic
    out:
      - cdb_zip

outputs:
  cinema_db:
    type: File
    outputSource: topo/cdb_zip
