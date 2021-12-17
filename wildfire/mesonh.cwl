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
        version: ["5.4.4"]

requirements:
  SchemaDefRequirement:
    types:
      - $import: mesonh.yml
  cwltool:MPIRequirement:
    processes: $(inputs.processes)
  InlineJavascriptRequirement:
    expressionLib:
      - $include: mesonh.js
  InitialWorkDirRequirement:
    listing:
      - $(inputs.pgd)
      - $(inputs.inis)
      - entryname: EXSEG1.nam
        entry: |
          &NAM_PARAM_ICE LRED=T /
          &NAM_CONFIO  LCDF4=T, LLFIOUT=F, LLFIREAD=F /
          &NAM_CONFZ MPI_BUFFER_SIZE=300, LMNH_MPI_BSEND= F /
          &NAM_LUNITn CINIFILE = "$(inputs.inis[0].nameroot)", CINIFILEPGD = "$(inputs.pgd.nameroot)",
                      CCPLFILE(1) = "$(inputs.inis[1].nameroot)"/
          &NAM_CONFn LUSERV = T, LUSERC = F, LUSERR = F, LUSERI = F,
                     LUSERS = F, LUSERG = F, LUSERH = F, LUSECI = F /
          &NAM_DYNn  XTSTEP = 10., NITR = 11, LITRADJ= T, CPRESOPT='ZRESI',
                     LHORELAX_UVWTH = F, LHORELAX_RV = F, LVE_RELAX = T,
                     NRIMX =  5, NRIMY = 5, XRIMKMAX = 0.0083, XT4DIFU = 5000. /
          &NAM_ADVn CUVW_ADV_SCHEME = "CEN4TH", CMET_ADV_SCHEME = "PPM_01", CSV_ADV_SCHEME = "PPM_01",
                    CTEMP_SCHEME='RKC4' /
          &NAM_PARAMn  CTURB = "TKEL", CRAD = "NONE", CCLOUD = "NONE", 
                       CDCONV = "NONE", CSCONV = "NONE" /
          &NAM_PARAM_RADn  XDTRAD = 900., XDTRAD_CLONLY = 900., LCLEAR_SKY = F,
                             NRAD_COLNBR = 400, CAOP = "EXPL" /
          &NAM_PARAM_MFSHALLn XIMPL_MF = 1, CMF_UPDRAFT = "EDKF", CMF_CLOUD = "STAT",
                              LMIXUV = T, LMF_FLX = F /
          &NAM_TURBn  XIMPL = 1., CTURBLEN = "$(inputs.turblen)", CTURBDIM = "$(inputs.turbdim)",
                      LTURB_FLX = F, LTURB_DIAG = F, CSUBG_AUCV = "NONE",
                      LSIGMAS = F, LSIG_CONV = F, LSUBG_COND = F /
          &NAM_LBCn  CLBCX = 2*"OPEN", CLBCY = 2*"OPEN", XCPHASE = 5. /
          &NAM_CONF  CCONF = "START", NVERB=1, NMODEL = 1, LLG = F,
                     CEXP = "$(inputs.experiment_name)", CSEG = "$(inputs.segment_name)" ,
                     NHALO=1, CSPLIT='BSPLITTING' /
          &NAM_DYN XSEGLEN=$(inputs.segment_length), LCORIO = T, LNUMDIFU = F,
                   XALKTOP = 0.001, XALZBOT = 4000.  /
          &NAM_BACKUP XBAK_TIME_FREQ_FIRST=0, XBAK_TIME_FREQ=$(inputs.output_period) /

inputs:
  processes:
    type: int
  pgd:
    label: Physiographic data, preprocessed by PREP_PGD, in NetCDF.
    type: File
    secondaryFiles: ^.des
  inis:
    label: Initial/coupling conditions, from GFS global simulations, via PREP_REAL_CASE.
    type: File[]
    secondaryFiles: ^.des
  experiment_name:
    label: Name of set of runs - MUST be 5 characters
    type: string
  segment_name:
    label: Name of segment within experiment - MUST be 5 characters
    type: string
  segment_length:
    label: Simulation segment length in seconds
    type: float
  output_period:
    label: Time in undocumented units between output of backups
    type: float
    default: 300
  turblen:
    type: mesonh.yml#turblen
  turbdim:
    type: mesonh.yml#turbdim
  
baseCommand: MESONH

outputs:
  log:
    type: File[]
    outputBinding:
      glob: OUTPUT_LISTING?
  diachronic:
    type: File
    outputBinding:
      glob: $(inputs.experiment_name).1.$(inputs.segment_name).000.nc
    secondaryFiles: ^.des
  synchronous_backups:
    type: File[]
    outputBinding:
      glob: $(inputs.experiment_name).1.$(inputs.segment_name).???.nc
      outputEval: $(self.filter(function(back_file) {return !back_file.basename.endsWith("000.nc")} ))
    secondaryFiles: ^.des
