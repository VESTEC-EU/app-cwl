#!/bin/bash
#SBATCH --job-name=wfa-post-prob
#SBATCH --time=0:05:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --ntasks=1
#SBATCH --account=dc118

cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/wildfire/wfapost-prob.cwl wfapost-prob.yml

tmp_finalise
