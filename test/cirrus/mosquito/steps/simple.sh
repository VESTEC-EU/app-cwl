cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

(
    export disease=chik
    export species=aegypti
    export region=rome
    module load mosquito/main
    envsubst < simple-template.yml > simple.yml
)

tmp_init $PWD/tmp

cwltool --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF $VESTEC_CWL_ROOT/mosquito/mos.cwl simple.yml

tmp_finalise
