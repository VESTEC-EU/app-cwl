cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

(
    export disease=chik
    export species=aegypti
    export region=rome
    module load mosquitodata/0.1.0
    module load mosquito/0.2.0
    envsubst < all-template.yml > all.yml
)

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/mosquito/all.cwl all.yml

tmp_finalise
