cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

tmp_init $PWD/tmp

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/mosquito/rectgen.cwl \
    rectgen.yml

tmp_finalise
