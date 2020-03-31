#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.0
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      Meso-NH:
        version: ["5.4.2"]

requirements:
  InlineJavascriptRequirement:
    expressionLib:
      - $include: mesonh.js
      - $include: ../lib/mpi.js
  SchemaDefRequirement:
    types:
      - $import: ../lib/mpi.yml

  InitialWorkDirRequirement:
    listing:
      - $(inputs.pgd)
      - entryname: $(ensure28(inputs.gfs_grib.basename))
        entry: $(inputs.gfs_grib)
      - entryname: PRE_REAL1.nam
        entry: |
          &NAM_CONFIO  LCDF4=T, LLFIOUT=F, LLFIREAD=F /
          &NAM_CONFZ MPI_BUFFER_SIZE=400, LMNH_MPI_BSEND= F /
          &NAM_REAL_CONF NVERB=5, CPRESOPT='ZRESI' /
          &NAM_FILE_NAMES HATMFILE ='$(ensure28(inputs.gfs_grib.basename))',
                          HATMFILETYPE='GRIBEX',
                          HPGDFILE ='$(inputs.pgd.nameroot)',
                          CINIFILE='$(inputs.ini_nameroot)' /
          &NAM_VER_GRID NKMAX=50, YZGRID_TYPE='FUNCTN',
                        ZDZGRD=12., ZDZTOP=2000., ZZMAX_STRGRD=60.,
                        ZSTRGRD=7., ZSTRTOP=8. /

inputs:
  mpi:
    type: ../lib/mpi.yml#mpi
    default: {}
  pgd:
    type: File
    secondaryFiles: ^.des
  gfs_grib:
    type: File
  ini_nameroot:
    type: string

arguments:
  - position: 0
    valueFrom: $(mpi.run("PREP_REAL_CASE"))

outputs:
  log:
    type: File
    outputBinding:
      glob: OUTPUT_LISTING0
  ini:
    type: File
    outputBinding:
      glob: $(inputs.ini_nameroot).nc
    secondaryFiles: ^.des


