#!/bin/bash --login
#PBS -N WFA-post
#PBS -l select=1
#PBS -l walltime=0:20:00
#PBS -q short
#PBS -A d170
# NOTE! This one doesn't have to run on compute nodes

if [ -z ${PBS_O_WORKDIR+x} ]; then
    # nothing
    echo "nothing" > /dev/null
else
    cd $PBS_O_WORKDIR
fi

. ../env.sh

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/wildfire/wfapost.cwl wfapost.yml

tmp_finalise
