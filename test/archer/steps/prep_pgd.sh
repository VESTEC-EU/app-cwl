#!/bin/bash --login
#PBS -N prep-pgd
#PBS -l select=1
#PBS -l walltime=0:05:00
#PBS -q short
#PBS -A z19-cse

cd $PBS_O_WORKDIR

. ../env.sh

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF --enable-ext --mpi-config-file $VESTEC_CWL_MPI_CONF $VESTEC_CWL_ROOT/wildfire/prep_pgd.cwl prep_pgd.yml

tmp_finalise
