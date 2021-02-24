#!/bin/bash
#SBATCH --export=none
#SBATCH --job-name=prep_pgd
#SBATCH --time=0:20:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --reservation=shortqos
#SBATCH --account=d170
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --tasks-per-node=32
#SBATCH --cpus-per-task=4

export OMP_NUM_THREADS=4
export OMP_PLACES=cores

. ../env.sh

cwltool  \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    --enable-ext \
    --preserve-environment LD_LIBRARY_PATH \
    --preserve-environment OMP_NUM_THREADS \
    --preserve-environment OMP_PLACES \
    --mpi-config-file $VESTEC_CWL_MPI_CONF \
    $VESTEC_CWL_ROOT/wildfire/wfa.cwl \
    wfa.yml

