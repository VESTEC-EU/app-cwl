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

  upperleft:
    type: geo.yml#point
  lowerright:
    type: geo.yml#point
  dx:
    type: float
    default: 2000.0
    label: horizontal resolution in metres
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
      turbdim: turbdim
      turblen: turblen
    out: [later_diachronic_backups]

  post:
    run: extract.cwl
    in:
      diachronic_backups: meso/later_diachronic_backups
      output_name: output_name
      ncl_root: ncl_root
      ncl_resfile: ncl_resfile
    out: [extract]

outputs:
  fireinput:
    type: File
    outputSource: post/extract
