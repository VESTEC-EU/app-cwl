#!/bin/bash
#SBATCH --job-name=ipic3d
#SBATCH --time=0:20:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --ntasks=1
#SBATCH --account=dc118

cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

tmp_init $PWD/tmp

cwltool $VESTEC_CWL_ROOT/spaceweather/ipic-input-gen.cwl simple.yml

tmp_finalise
