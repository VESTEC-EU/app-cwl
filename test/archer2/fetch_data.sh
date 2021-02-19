# Meso-NH data
pushd /work/d170/shared/data/mesonh/PREP_PGD_FILES_WWW
base_url=http://mesonh.aero.obs-mip.fr/mesonh/dir_open/dir_PGDFILES
for name in gtopo30 ECOCLIMAP_v2.0 SAND_HWSD_MOY CLAY_HWSD_MOY; do
    for ext in hdr dir; do
	if [ ! -f $name.$ext ]; then
	    if [ ! -f $name.$ext.gz ]; then
		wget $base_url/$name.$ext.gz
	    fi
	    gunzip $name.$ext.gz
	fi
    done
done
popd

# GFS data
pushd /work/d170/shared/data/mesonh/GFS

base_url=https://www.ncei.noaa.gov/data/global-forecast-system/access/historical/analysis

year=2019
month=07
day=11

day_url=$base_url/${year}${month}/${year}${month}${day}
rm -f dowloads.txt
for hour in 0000 0600; do
    forecast_hr=000
    for ext in inv grb2; do
	fn=gfsanl_3_${year}${month}${day}_${hour}_${forecast_hr}.$ext
	if [ ! -f $fn ]; then
	    echo $day_url/$fn >> downloads.txt
	fi
    done
done

if [ -f downloads.txt ]; then
    wget -i downloads.txt
    rm downloads.txt
fi

popd
