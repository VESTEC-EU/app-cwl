#!/bin/bash
#SBATCH --job-name=extract
#SBATCH --time=0:05:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --ntasks=1
#SBATCH --account=dc118

cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

# NCL is weirdly linked and needs the module loaded now as well as by CWL
module load ncl

tmp_init $PWD/tmp

cwltool --preserve-environment LD_LIBRARY_PATH --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/wildfire/extract.cwl extract.yml

tmp_finalise
