#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.0
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
  InitialWorkDirRequirement:
    listing:
      - $(inputs.clay)
      - $(inputs.sand)
      - $(inputs.cover)
      - $(inputs.zs)
      - entryname: PRE_PGD1.nam
        entry: |
          &NAM_CONFIO LCDF4=T LLFIOUT=F LLFIREAD=F /
          &NAM_PGDFILE CPGDFILE="$(inputs.output_basename)", NHALO=0 /
          &NAM_PGD_SCHEMES CNATURE='ISBA', CSEA='SEAFLX', CTOWN='TEB', CWATER='WATFLX' /
          &NAM_CONF_PROJ XLAT0=34.0, XLON0=-118.0, XRPK=0., XBETA=0. /
          &NAM_CONF_PROJ_GRID XLATCEN=34.0, XLONCEN=-118.0, NIMAX=8, NJMAX=8,
                    XDX=2000., XDY=2000 /
          &NAM_WRITE_COVER_TEX /
          &NAM_ZS YZS='$(inputs.zs.nameroot)', YZSFILETYPE='DIRECT' /
          &NAM_COVER YCOVER='$(inputs.cover.nameroot)', YCOVERFILETYPE='DIRECT' /
          &NAM_ISBA YCLAY='$(inputs.clay.nameroot)', YCLAYFILETYPE='DIRECT' ,
                    YSAND='$(inputs.sand.nameroot)', YSANDFILETYPE='DIRECT' /

inputs:
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
