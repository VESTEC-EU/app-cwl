begin
  mnhfiles = systemfunc("ls *.nc")
  mnh = addfiles(mnhfiles, "r")
  nfiles = dimsizes(mnhfiles)
  print("nfiles="+nfiles)
  ListSetType (mnh, "join")
;=================================================;
; Get informations on variable sizes
;=================================================;
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
  varname = (/"Temp","Rehu","WindSpe","WindDir"/)
  varstdn = (/"Temperature at 20 ft (6 m)","Relative Humidity at 20 ft (6 m)",\
              "Wind speed at 20 ft (6 m)","Wind direction at 20 ft (6 m)"/)
  varunit = (/"K","%","km h-1","degree from north"/)
  nvar=dimsizes(varname)
  sername=new((/nvar,nfiles,JMAX,IMAX/),"double")
;-----------------------------;
;Potential Temperature
  tht = mnh[:]->THT(:,0,1,1:JMAX,1:IMAX)
;Pressure
  pre = mnh[:]->PABST(:,0,1,1:JMAX,1:IMAX)
;Water vapor mixing ratio
  rv = mnh[:]->RVT(:,0,1,1:JMAX,1:IMAX)
;Temperature
  p0 = 100000.
  Temp = tht*(pre/p0)^0.286
  sername(0,:,:,:) = Temp
;Relative humidity
  sername(1,:,:,:) = relhum_water(Temp, rv, pre) ; input in K, kg/kg, Pa
  ut = mnh[:]->UT(:,0,:,1:JMAX,1:IMAX+1)
  ua = wrf_user_unstagger(ut,"X")
  u = ua(:,1,:,:)
  vt = mnh[:]->VT(:,0,:,1:JMAX+1,1:IMAX)
  va = wrf_user_unstagger(vt,"Y")
  v = va(:,1,:,:)
;Weath_w 20ft km/h
  sername(2,:,:,:) = wind_speed(u,v)*3.6
  sername(3,:,:,:) = wind_direction(u,v,0)
;=================================================;
; write results in netcdf file
;================================================;
  fout = addfile(fout_name, "c")
;-----------------------------;
  setfileoption(fout,"DefineMode",True)
  fAtt               = True            ; assign file attributes
  fAtt@title         = "Meso-NH for WildFire use-case"
  fAtt@source_file   = "Meso-NH CFIRE "
  fAtt@Conventions   = "None"
  fAtt@creation_date = systemfunc ("date")
  fileattdef( fout, fAtt )
  dimNames = (/"time", "nj", "ni"/)
  dimSizes = (/ -1   ,  JMAX,  IMAX /)
  dimUnlim = (/ True , False, False/)
  filedimdef(fout,dimNames,dimSizes,dimUnlim)
;-----------------------------;
  do jv=0,nvar-1
    tmp = sername(jv,:,:,:)
    tmp!0 = "time"
    tmp!1 = "nj"
    tmp!2 = "ni"
    tmp@coordinates = "latitude longitude"
    vartmp=varname(jv)
    filevardef(fout, vartmp          ,typeof(tmp)  ,getvardims(tmp))
    delete(tmp)
  end do
  filevardef(fout, "time" ,typeof(time),getvardims(time))
  filevardef(fout, "latitude"  ,typeof(latitude),getvardims(latitude))
  filevardef(fout, "longitude"  ,typeof(longitude),getvardims(longitude))
;-----------------------------;
  do jv=0,nvar-1
    tmp = sername(jv,:,:,:)
    tmp!0 = "time"
    tmp!1 = "level"
    tmp!2 = "location"
    tmp@standard_name = varstdn(jv)
    tmp@long_name     = varstdn(jv)
    tmp@units = varunit(jv)
    vartmp=varname(jv)
    filevarattdef(fout,vartmp,tmp)                           ; copy T attributes
    delete(tmp)
  end do
  filevarattdef(fout,"time" ,time)
  filevarattdef(fout,"latitude"  ,latitude)
  filevarattdef(fout,"longitude"  ,longitude)
;-----------------------------;
  fout->time = time
  fout->latitude = latitude
  fout->longitude = longitude
  do jv=0,nvar-1
    tmp = sername(jv,:,:,:)
    fout->$varname(jv)$      = (/ tmp /)
    delete(tmp)
  end do
end
