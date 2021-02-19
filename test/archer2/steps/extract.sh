#!/bin/bash
#
# NOTE! This one doesn't have to run on compute nodes
#
#SBATCH --export=none
#SBATCH --job-name=prep_pgd
#SBATCH --time=0:05:00
#SBATCH --partition=standard
#SBATCH --qos=short
#SBATCH --reservation=shortqos
#SBATCH --account=d170
#SBATCH --nodes=1

. ../env.sh

cwltool \
    --relax-path-checks \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/wildfire/extract.cwl \
    extract.yml

