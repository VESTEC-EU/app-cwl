#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow

requirements:
  SchemaDefRequirement:
    types:
      - $import: mesonh.yml
      - $import: geo.yml
      - $import: wfa_out.yml
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  sim_processes:
    type: int

  upperleft:
    type: geo.yml#point
  lowerright:
    type: geo.yml#point
  dx:
    type: float
    default: 2000.0
    label: horizontal resolution in metres

  clay:
    type: File
    secondaryFiles: ^.hdr
  sand:
    type: File
    secondaryFiles: ^.hdr
  cover:
    type: File
    secondaryFiles: ^.hdr
  zs:
    type: File
    secondaryFiles: ^.hdr

  gfs_gribs:
    type: File[]
    label: global forecast data to use

  sim_length_seconds:
    label: Simulation length in seconds
    type: float

  weather_output_period_seconds:
    label: Time in seconds between output of MesoNH backups
    type: float
    default: 3600

  turblen:
    type: mesonh.yml#turblen
  turbdim:
    type: mesonh.yml#turbdim

  start_time:
    type: float
    label: start time of WFA sim from beginning of the weather data (hours) - currently must be zero
    default: 0.0

  sims_per_rank:
    type: int
    label: the number of simulations per MPI rank for WFA

  fuel_geotiff:
    type: File
    label: Input fuel geotiff
  mdt_geotiff:
    type: File
    label: Input MDT geotiff

  dynamic_config:
    type: File
    label: WFA dynamic configuration

steps:
  prep_pgd:
    run: prep_pgd.cwl
    in:
      upperleft: upperleft
      lowerright: lowerright
      dx: dx
      clay: clay
      sand: sand
      cover: cover
      zs: zs
      output_basename: {valueFrom: tmp_pgd}
    out: [pgd]

  mnh2nc:
    run: mesonh_composed.cwl
    in:
        sim_processes: sim_processes
        pgd: prep_pgd/pgd
        gfs_gribs: gfs_gribs
        segment_length: sim_length_seconds
        output_period: weather_output_period_seconds
        turblen: turblen
        turbdim: turbdim
    out: [fireinput]

  wfa:
    run: wfa-all.cwl
    in:
      mpi_processes: sim_processes
      omp_threads:
        valueFrom: $(1)
      sim_duration:
        source: sim_length_seconds
        valueFrom: $(self / 3600.0)
      start_time: start_time
      sims_per_rank: sims_per_rank
      fuel_geotiff: fuel_geotiff
      mdt_geotiff: mdt_geotiff
      upperleft: upperleft
      lowerright: lowerright
      weather_data: mnh2nc/fireinput
      dynamic_config: dynamic_config

    out:
      - best_conditions
      - normal_png
      - fireshed_png
      - fire_prob_png
      - fire_front_prob_png

outputs:
  best_conditions:
    type: File
    outputSource: wfa/best_conditions

  normal_png:
    outputSource: wfa/normal_png
    type: File
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml

  fireshed_png:
    outputSource: wfa/fireshed_png
    type: File
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml

  fire_prob_png:
    outputSource: wfa/fire_prob_png
    type: File[]
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml

  fire_front_prob_png:
    outputSource: wfa/fire_front_prob_png
    type: File[]
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
