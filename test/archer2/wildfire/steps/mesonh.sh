#!/bin/bash
#SBATCH --export=none
#SBATCH --job-name=mesonh
#SBATCH --time=0:05:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --reservation=shortqos
#SBATCH --account=d170
#SBATCH --nodes=1

. ../env.sh

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    --enable-ext \
    --preserve-environment LD_LIBRARY_PATH \
    --mpi-config-file $VESTEC_CWL_MPI_CONF \
    $VESTEC_CWL_ROOT/wildfire/mesonh.cwl \
    mesonh.yml
