#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: Workflow

requirements:
  SchemaDefRequirement:
    types:
      - $import: wfapost.yml

inputs:
  sim_duration:
    type: float
    label: Simulation duration in hours
  step:
    type: float
    label: timestep for output in hours
    default: 1.0
  normal_gtif:
    type: File
    label: A normal fire simulation (GeoTiff)
  fireshed_gtif:
    type: File
    label: A fireshed simulation (GeoTiff)
  variance:
    type: File
    label: Variance of simulations (GeoTiff)
  mean:
    type: File
    label: Mean of simulations (GeoTiff)

steps:
  normal:
    run: wfapost-normal.cwl
    in:
      gtif: normal_gtif
      typeflag:
        default: "normal"
    out:
      - png

  fireshed:
    run: wfapost-normal.cwl
    in:
      gtif: fireshed_gtif
      typeflag:
        default: "fireshed"
    out:
      - png

  prob:
    run: wfapost-prob.cwl
    in:
      sim_duration: sim_duration
      step: step
      variance: variance
      mean: mean
    out:
      - fire_prob
      - fire_prob_kmz
      - fire_front_prob
      - fire_front_prob_kmz

outputs:
  normal_png:
    type: File
    outputSource: normal/png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
      - ^.kmz
  fireshed_png:
    type: File
    outputSource: fireshed/png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
      - ^.kmz
  fire_prob:
    type: File[]
    outputSource: prob/fire_prob
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_prob_kmz:
    type: File
    outputSource: prob/fire_prob_kmz
  fire_front_prob:
    type: File[]
    outputSource: prob/fire_front_prob
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_front_prob_kmz:
    type: File
    outputSource: prob/fire_front_prob_kmz
