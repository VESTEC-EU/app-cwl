#!/bin/bash
#
# NOTE! This one doesn't have to run on compute nodes
#
#SBATCH --export=none
#SBATCH --job-name=wfapost
#SBATCH --time=0:20:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --reservation=shortqos
#SBATCH --account=d170
#SBATCH --nodes=1

. ../env.sh

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/wildfire/wfapost.cwl \
    wfapost.yml

