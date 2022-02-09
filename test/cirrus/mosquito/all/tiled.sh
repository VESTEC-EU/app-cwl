cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

(
    export disease=chik
    export species=albopictus
    module load mosquitodata/0.1.0
    module load mosquito/0.2.0
    envsubst < tiled-template.yml > tiled.yml
)

tmp_init $PWD/tmp

cwltool \
    --parallel \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/mosquito/tiled.cwl \
    tiled.yml

tmp_finalise
