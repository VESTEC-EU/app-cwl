#!/bin/bash --login
# 
# NOTE! This one doesn't have to run on compute nodes
#
#PBS -N extract
#PBS -l select=1
#PBS -l walltime=0:05:00
#PBS -q short
#PBS -A z19-cse

cd ${PBS_O_WORKDIR-$PWD}

. ../env.sh

tmp_init $PWD/tmp

cwltool --relax-path-checks --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/wildfire/extract.cwl extract.yml

tmp_finalise
