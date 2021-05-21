#!/bin/bash
#SBATCH --job-name=prep-gfs-one
#SBATCH --time=0:05:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --ntasks=1
#SBATCH --account=dc118

cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF --enable-ext --mpi-config-file $VESTEC_CWL_MPI_CONF $VESTEC_CWL_ROOT/wildfire/prep_gfs_one.cwl prep_gfs_one.yml

tmp_finalise
