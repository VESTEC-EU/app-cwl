#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow

requirements:
  SchemaDefRequirement:
    types:
      - $import: geo.yml
      - $import: wfa_out.yml

  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  
inputs:
  mpi_processes:
    type: int
  omp_threads:
    type: int

  sim_name:
    type: string
    default: Vestec
  sim_duration:
    type: float
    label: Simulation duration in hours
  start_time:
    type: float
    label: start time from beginning of the weather data (hours)

  sims_per_rank:
    type: int
    label: the number of simulations per MPI rank

  upperleft:
    type: geo.yml#point
  lowerright:
    type: geo.yml#point

  fuel_geotiff:
    type: File
    label: Input fuel geotiff
  mdt_geotiff:
    type: File
    label: Input MDT geotiff

  weather_data:
    type: File
    label: Weather NetCDF file

  dynamic_config:
    type: File
    label: WFA dynamic configuration

steps:
  firesim:
    run: wfa.cwl
    in: 
      mpi_processes: mpi_processes
      omp_threads: omp_threads
      sim_duration: sim_duration
      start_time: start_time
      sims_per_rank: sims_per_rank
      upperleft: upperleft
      lowerright: lowerright
      fuel_geotiff: fuel_geotiff
      mdt_geotiff: mdt_geotiff
      weather_data: weather_data
      dynamic_config: dynamic_config
    out:
      - data
      - best_conditions

  post:
    run: wfapost.cwl
    in:
      sim_duration:
        source: sim_duration
        valueFrom: $(Math.floor(self))
      normal_gtif:
        source: firesim/data
        valueFrom: $(self.Fire.Best)
      fireshed_gtif: 
        source: firesim/data
        valueFrom: $(self.FireShed.Best)
      variance: 
        source: firesim/data
        valueFrom: $(self.Fire.Variance)
      mean: 
        source: firesim/data
        valueFrom: $(self.Fire.Mean)
    out:
      - normal_png
      - fireshed_png
      - fire_prob
      - fire_front_prob

outputs:
  best_conditions:
    type: File
    outputSource: firesim/best_conditions
  normal_png:
    outputSource: post/normal_png
    type: File
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fireshed_png:
    outputSource: post/fireshed_png
    type: File
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_prob_png:
    outputSource: post/fire_prob
    type: File[]
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_front_prob_png:
    outputSource: post/fire_front_prob
    type: File[]
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
