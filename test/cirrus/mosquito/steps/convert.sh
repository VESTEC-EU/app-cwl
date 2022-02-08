cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

(
    export disease=chik
    export species=albopictus
    export region=rect_0_0
    module load mosquitodata/0.1.0
    envsubst < convert-R0-template.yml > convert-R0.yml
    envsubst < convert-density-template.yml > convert-density.yml
)

tmp_init $PWD/tmp

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/mosquito/convert.cwl \
    convert-density.yml

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/mosquito/convert.cwl \
    convert-R0.yml

tmp_finalise
