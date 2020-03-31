#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.0
class: Workflow

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - $include: ../lib/mpi.js
  SchemaDefRequirement:
    types:
      - $import: ../lib/mpi.yml
  ScatterFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}

inputs:
  mpi:
    type: ../lib/mpi.yml#mpi
    default: {}
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
      mpi: mpi
      gfs_grib: gfs_gribs
      ini_nameroot: ini_nameroots
      pgd: pgd

    out: [ini]

outputs:
  inis:
    type: File[]
    outputSource: prep_gfs/ini
