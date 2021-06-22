#!/bin/bash
#SBATCH --export=none
#SBATCH --job-name=mesonh
#SBATCH --time=0:05:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --reservation=shortqos
#SBATCH --account=d170
#SBATCH --nodes=1

cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

(
    module load ipic3d
    envsubst < ensemble-template.yml > ensemble.yml
)

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF --enable-ext --mpi-config-file $VESTEC_CWL_MPI_CONF $VESTEC_CWL_ROOT/spaceweather/ipic-b0-ensemble.cwl ensemble.yml

tmp_finalise
