#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  cwltool: http://commonwl.org/cwltool#

hints:
  SoftwareRequirement:
    packages:
      Meso-NH:
        version: ["5.4.2"]

requirements:
  cwltool:MPIRequirement:
    processes: 1
  InlineJavascriptRequirement:
    expressionLib:
      - $include: mesonh.js        
  SchemaDefRequirement:
    types:
      - $import: mesonh.yml
  InitialWorkDirRequirement:
    listing:
      - $(inputs.clay)
      - $(inputs.sand)
      - $(inputs.cover)
      - $(inputs.zs)
      - entryname: PRE_PGD1.nam
        entry: |
          &NAM_CONFIO LCDF4=T LLFIOUT=F LLFIREAD=F /
          &NAM_PGDFILE CPGDFILE="$(inputs.output_basename)", NHALO=$(inputs.nhalo) /
          &NAM_PGD_SCHEMES CNATURE='ISBA', CSEA='SEAFLX', CTOWN='TEB', CWATER='WATFLX' /
          &NAM_CONF_PROJ XLAT0=$(latcen()), XLON0=$(loncen()), XRPK=$(inputs.rpk), XBETA=$(inputs.beta) /
          &NAM_CONF_PROJ_GRID XLATCEN=$(latcen()), XLONCEN=$(loncen()), NIMAX=$(NI()), NJMAX=$(NJ()),
                    XDX=$(inputs.dx), XDY=$(inputs.dx) /
          &NAM_WRITE_COVER_TEX /
          &NAM_ZS YZS='$(inputs.zs.nameroot)', YZSFILETYPE='DIRECT' /
          &NAM_COVER YCOVER='$(inputs.cover.nameroot)', YCOVERFILETYPE='DIRECT' /
          &NAM_ISBA YCLAY='$(inputs.clay.nameroot)', YCLAYFILETYPE='DIRECT' ,
                    YSAND='$(inputs.sand.nameroot)', YSANDFILETYPE='DIRECT' /

inputs:
  nhalo:
    type: int
    default: 0
  rpk:
    type: float
    default: 0.0
    label: cone factor for the projection -1 <= rpk <= 1
  beta:
    type: float
    default: 0.0
    label: rotation angle of the simulation domain around the reference longitude
  upperleft:
    type: mesonh.yml#geo_point
  lowerright:
    type: mesonh.yml#geo_point
  dx:
    type: float
    default: 2000.0
    label: horizontal resolution in metres
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
  output_basename:
    type: string

baseCommand: PREP_PGD

outputs:
  log:
    type: File
    outputBinding:
      glob: OUTPUT_LISTING0
  pgd:
    type: File
    outputBinding:
      glob: $(inputs.output_basename).nc
    secondaryFiles: ^.des
