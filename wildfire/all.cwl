#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.0
class: Workflow

requirements:
  SchemaDefRequirement:
    types:
      - $import: mesonh.yml
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs:
  sim_processes:
    type: int
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
  prep_pgd:
    run: prep_pgd.cwl
    in:
      clay: clay
      sand: sand
      cover: cover
      zs: zs
      output_basename: {default: tmp_pgd}
    out: [pgd]

  prep_gfs:
    run: prep_gfs_one.cwl
    scatter: [gfs_grib, ini_nameroot]
    scatterMethod: dotproduct
    in:
      gfs_grib: gfs_gribs
      ini_nameroot: ini_nameroots
      pgd: prep_pgd/pgd

    out: [ini]
  meso:
    run: mesonh.cwl
    in:
      processes: sim_processes
      pgd: prep_pgd/pgd
      inis: prep_gfs/ini
      experiment_name: experiment_name
      segment_name: segment_name
      turbdim: turbdim
      turblen: turblen
    out: [diachronic_backups]

  post:
    run: extract.cwl
    in:
      diachronic_backups: meso/diachronic_backups
      output_name: output_name
      ncl_root: ncl_root
      ncl_resfile: ncl_resfile
    out: [extract]

outputs:
  fireinput:
    type: File
    outputSource: post/extract
