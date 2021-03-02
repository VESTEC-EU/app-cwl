#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      wfapost:
        version: ["1"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: input/probabilistic/$(inputs.variance.basename)
        entry: $(inputs.variance)
      - entryname: input/probabilistic/$(inputs.mean.basename)
        entry: $(inputs.mean)              
      - class: Directory
        basename: output
        listing:
          - class: Directory
            basename: png
            listing:
              - class: Directory
                basename: fire_prob
                listing: []
              - class: Directory
                basename: fire_front_prob
                listing: []
          - class: Directory
            basename: tif
            listing:
              - class: Directory
                basename: fire_prob
                listing: []
              - class: Directory
                basename: fire_front_prob
                listing: []
          - class: Directory
            basename: kmz
            listing:
              - class: Directory
                basename: fire_prob
                listing: []
              - class: Directory
                basename: fire_front_prob
                listing: []

inputs:
  sim_duration:
    type: float
    label: Simulation duration in hours
    inputBinding:
      position: 1
      prefix: --duration
  step:
    type: float
    label: timestep for output in hours
    default: 1.0
    inputBinding:
      position: 2
      prefix: --step
  variance:
    type: File
    label: Variance of simulations (GeoTiff)
    inputBinding:
      position: 3
      valueFrom: $(inputs.variance.basename)
  mean:
    type: File
    label: Mean of simulations (GeoTiff)
    inputBinding:
      position: 4
      valueFrom: $(inputs.mean.basename)
  
baseCommand: wfapost-prob

outputs:
  fire_prob:
    type: File[]
    outputBinding:
      glob: output/png/fire_prob/fire_prob_*.png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_prob_kmz:
    type: File
    outputBinding:
      glob: output/kmz/fire_prob/fire_prob.kmz
  fire_front_prob:
    type: File[]
    outputBinding:
      glob: output/png/fire_front_prob/fire_front_prob_*.png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_front_prob_kmz:
    type: File
    outputBinding:
      glob: output/kmz/fire_front_prob/fire_front_prob.kmz
