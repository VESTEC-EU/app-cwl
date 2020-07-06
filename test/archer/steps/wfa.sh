#!/bin/bash --login
#PBS -N WFA
#PBS -l select=1
#PBS -l walltime=0:20:00
#PBS -q short
#PBS -A d170

cd $PBS_O_WORKDIR

. ../env.sh

tmp_init $PWD/tmp

cwltool  --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF --enable-ext --mpi-config-file $VESTEC_CWL_MPI_CONF $VESTEC_CWL_ROOT/wildfire/wfa.cwl wfa.yml

tmp_finalise
