#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      wfapost:
        version: ["main"]

requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: input/normal/$(inputs.normal_gtif.basename)
        entry: $(inputs.normal_gtif)
      - entryname: input/fireshed/$(inputs.fireshed_gtif.basename)
        entry: $(inputs.fireshed_gtif)
      - entryname: input/probabilistic/$(inputs.variance.basename)
        entry: $(inputs.variance)
      - entryname: input/probabilistic/$(inputs.mean.basename)
        entry: $(inputs.mean)              
      - entryname: config.json
        entry: |
          {
            "simDuration": $(inputs.sim_duration)
          }
      - class: Directory
        basename: output
        listing:
          - class: Directory
            basename: png
            listing:
              - class: Directory
                basename: normal
                listing: []
              - class: Directory
                basename: fireshed
                listing: []
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
                basename: fire_front_prob
                listing: []
              - class: Directory
                basename: fire_prob
                listing: []

inputs:
  sim_duration:
    type: int
    label: Simulation duration in hours
  normal_gtif:
    type: File
    label: A normal fire simulation (GeoTiff)
    inputBinding:
      position: 1
      valueFrom: $(inputs.normal_gtif.basename)
  fireshed_gtif:
    type: File
    label: A fireshed simulation (GeoTiff)
    inputBinding:
      position: 2
      valueFrom: $(inputs.fireshed_gtif.basename)
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
  
baseCommand: wfapost

outputs:
  normal_png:
    type: File
    outputBinding:
      glob: output/png/normal/normal.png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fireshed_png:
    type: File
    outputBinding:
      glob: output/png/fireshed/fireshed.png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_prob:
    type: File[]
    outputBinding:
      glob: output/png/fire_prob/fire_prob_*.png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
  fire_front_prob:
    type: File[]
    outputBinding:
      glob: output/png/fire_front_prob/fire_front_prob_*.png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
