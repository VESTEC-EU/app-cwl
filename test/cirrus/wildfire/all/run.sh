#!/bin/bash
#SBATCH --job-name=all
#SBATCH --time=0:20:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --account=dc118

. ../env.sh

(
    envsubst < params-template.yml > params.yml
)

tmp_init $PWD/tmp

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    --enable-ext \
    --mpi-config-file $VESTEC_CWL_MPI_CONF \
    $VESTEC_CWL_ROOT/wildfire/all.cwl \
    params.yml

tmp_finalise
