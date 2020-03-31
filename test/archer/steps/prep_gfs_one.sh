#!/bin/bash --login
#PBS -N prep-gfs
#PBS -l select=1
#PBS -l walltime=0:05:00
#PBS -q short
#PBS -A z19-cse

cd $PBS_O_WORKDIR

. ../env.sh

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/wildfire/prep_gfs_one.cwl prep_gfs_one.yml

tmp_finalise
