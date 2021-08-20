#!/bin/bash
#SBATCH --job-name=wfa-post-fireshed
#SBATCH --time=0:20:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --account=dc118

cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh
(
    envsubst < wfa-all-template.yml > wfa-all.yml
)

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF --enable-ext --mpi-config-file $VESTEC_CWL_MPI_CONF $VESTEC_CWL_ROOT/wildfire/wfa-all.cwl wfa-all.yml

tmp_finalise
