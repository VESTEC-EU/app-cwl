#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow

requirements:
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs:
  pgd:
    type: File
    secondaryFiles: ^.des
  gfs_gribs:
    type: File[]
  ini_nameroots:
    type: string[]

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

outputs:
  inis:
    type: File[]
    outputSource: prep_gfs/ini
