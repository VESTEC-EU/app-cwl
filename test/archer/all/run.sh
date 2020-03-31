#!/bin/bash --login
#PBS -N prepall
#PBS -l select=1
#PBS -l walltime=0:05:00
#PBS -q short
#PBS -A z19-cse

cd $PBS_O_WORKDIR

. ../env.sh

tmp_init $PWD/tmp


cwltool --relax-path-checks --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/wildfire/all.cwl params.yml

tmp_finalise
