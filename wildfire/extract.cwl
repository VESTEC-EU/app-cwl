#!/usr/bin/env cwl-runner
# -*- mode: yaml; -*-

cwlVersion: v1.0
class: CommandLineTool

hints:
  SoftwareRequirement:
    packages:
      ncl:
        version: ["6.4.0"]

requirements:
  InlineJavascriptRequirement: {}
  EnvVarRequirement:
    envDef:
      NCARG_USRRESFILE: $(inputs.ncl_resfile.path)
      NCARG_ROOT: $(inputs.ncl_root.path)
  InitialWorkDirRequirement:
    listing:
      - $(inputs.diachronic_backups)
      - entryname: select.ncl
        entry: |
          begin
            mnhfiles=str_split("$(inputs.diachronic_backups.slice(1).map(function(x){return x.basename;}).join(","))", ",")
            mnh = addfiles(mnhfiles, "r")
            nfiles = dimsizes(mnhfiles)
            print("nfiles="+nfiles)
            ListSetType (mnh, "join")
            ; Get information on variable sizes
            mdims = getfilevardimsizes(mnh[0],"UT")
            nd = dimsizes(mdims)
            IMAX=mdims(nd-1)-2
            JMAX=mdims(nd-2)-2
            KMAX=mdims(nd-3)-2
            print("KMAX="+KMAX+" JMAX="+JMAX+" IMAX="+IMAX)
            delete(mdims)
            ;-----------------------------;
            latitude = mnh[0]->latitude(0,1:JMAX,1:IMAX)
            longitude = mnh[0]->longitude(0,1:JMAX,1:IMAX)
            time = mnh[:]->time
            time!0 = "time"
            ;-----------------------------;
            WindSpe = new((/nfiles,JMAX,IMAX/),double)
            WindDir = new((/nfiles,JMAX,IMAX/),double)
            ut = mnh[:]->UT(:,0,:,1:JMAX,1:IMAX+1)
            ua = wrf_user_unstagger(ut,"X")
            u = ua(:,1,:,:)
            vt = mnh[:]->VT(:,0,:,1:JMAX+1,1:IMAX)
            va = wrf_user_unstagger(vt,"Y")
            v = va(:,1,:,:)
            ; Weath_w 20ft km/h
            WindSpe = wind_speed(u,v)
            WindSpe = WindSpe*3.6
            WindSpe@units = "km/h"
            WindDir = wind_direction(u,v,0)
            ; WindDir@units = "degree from north"
            WindSpe!0 = "time"
            WindSpe!1 = "nj"
            WindSpe!2 = "ni"
            WindSpe@coordinates = "latitude longitude"
            WindDir!0 = "time"
            WindDir!1 = "nj"
            WindDir!2 = "ni"
            WindDir@coordinates = "latitude longitude"
            ; Potential Temperature
            tht = mnh[:]->THT(:,0,1,1:JMAX,1:IMAX)
            ; Pressure
            pre = mnh[:]->PABST(:,0,1,1:JMAX,1:IMAX)
            ; Water vapor mixing ratio
            rv = mnh[:]->RVT(:,0,1,1:JMAX,1:IMAX)
            ; Temperature
            p0 = 100000.
            Temp = tht*(pre/p0)^0.286
            Temp!0 = "time"
            Temp!1 = "nj"
            Temp!2 = "ni"
            Temp@coordinates = "latitude longitude"
            ; Relative humidity
            Rehu = relhum_water(Temp, rv, pre) ; input in K, kg/kg, Pa
            Rehu!0 = "time"
            Rehu!1 = "nj"
            Rehu!2 = "ni"
            Rehu@coordinates = "latitude longitude"
            ; write results in netcdf file
            output = addfile("$(inputs.output_name)", "c")
            output->Temp = Temp
            output->Rehu = Rehu
            output->WindSpe = WindSpe
            output->WindDir = WindDir
            output->latitude = latitude
            output->longitude = longitude
            output->time = (/ time /)
          end

inputs:
  diachronic_backups:
    type: File[]
  output_name:
    type: string
  ncl_root:
    type: Directory
  ncl_resfile:
    type: File

outputs:
  ncl:
    type: File
    outputBinding:
      glob: select.ncl
  extract:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

baseCommand: [ncl, select.ncl]
