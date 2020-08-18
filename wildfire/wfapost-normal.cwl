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
  SchemaDefRequirement:
    types:
      - $import: wfapost.yml
  InitialWorkDirRequirement:
    listing:
      - entryname: input/$(inputs.typeflag)/$(inputs.gtif.basename)
        entry: $(inputs.gtif)
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

inputs:
  typeflag:
    type: wfapost.yml#typeflag
    inputBinding:
      position: 1
      prefix: --type
  gtif:
    type: File
    label: A normal or fireshed fire simulation (GeoTiff)
    inputBinding:
      position: 2
      valueFrom: $(inputs.gtif.basename)
  
baseCommand: wfapost-normal-fireshed

outputs:
  png:
    type: File
    outputBinding:
      glob: output/png/$(inputs.typeflag)/$(inputs.typeflag).png
    secondaryFiles:
      - ^.wld
      - ^.png.aux.xml
