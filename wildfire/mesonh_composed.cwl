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
  MultipleInputFeatureRequirement: {}

inputs:
  sim_processes:
    type: int

  pgd:
    type: File
    secondaryFiles: ^.des
  gfs_gribs:
    type: File[]
  ini_nameroots:
    type: string[]
  experiment_name:
    type: string
  segment_name:
    type: string
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
  output_name:
    type: string
  ncl_root:
    type: Directory
  ncl_resfile:
    type: File

steps:
  prep_gfs:
    run: prep_gfs_one.cwl
    scatter: [gfs_grib, ini_nameroot]
    scatterMethod: dotproduct
    in:
      gfs_grib: gfs_gribs
      ini_nameroot: ini_nameroots
      pgd: pgd

    out: [ini]
  meso:
    run: mesonh.cwl
    in:
      processes: sim_processes
      pgd: pgd
      inis: prep_gfs/ini
      experiment_name: experiment_name
      segment_name: segment_name
      segment_length: segment_length
      output_period: output_period
      turbdim: turbdim
      turblen: turblen
    out: [synchronous_backups]

  post:
    run: extract.cwl
    in:
      diachronic_backups: meso/synchronous_backups
      output_name: output_name
      ncl_root: ncl_root
      ncl_resfile: ncl_resfile
    out: [extract]

outputs:
  fireinput:
    type: File
    outputSource: post/extract
