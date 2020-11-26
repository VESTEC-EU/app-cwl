#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow

requirements:
  SchemaDefRequirement:
    types:
      - $import: mesonh.yml
      - $import: geo.yml
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  
inputs:
  sim_processes:
    type: int

  pgd:
    type: File
    secondaryFiles: ^.des
  gfs_gribs:
    type: File[]
  segment_length:
    label: Simulation segment length in seconds
    type: float
  output_period:
    label: Time in undocumented units between output of backups
    type: float
    default: 300
  turblen:
    type: mesonh.yml#turblen
  turbdim:
    type: mesonh.yml#turbdim

steps:
  prep_gfs:
    run: prep_gfs_one.cwl
    scatter: gfs_grib
    in:
      gfs_grib: gfs_gribs
      ini_nameroot:
        source: gfs_gribs
        valueFrom: $("outer" + self.findIndex(function(fileObj) { return fileObj.basename == inputs.gfs_grib.basename; }))
      pgd: pgd

    out: [ini]
  meso:
    run: mesonh.cwl
    in:
      processes: sim_processes
      pgd: pgd
      inis: prep_gfs/ini
      experiment_name:
        valueFrom: VESTC
      segment_name:
        valueFrom: WRKFL
      segment_length: segment_length
      output_period: output_period
      turbdim: turbdim
      turblen: turblen
    out: [synchronous_backups]

  post:
    run: extract.cwl
    in:
      diachronic_backups: meso/synchronous_backups
      output_name:
        valueFrom: weather_output.nc
    out: [extract]

outputs:
  fireinput:
    type: File
    outputSource: post/extract
