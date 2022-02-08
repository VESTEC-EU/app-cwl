cd ${SLURM_SUBMIT_DIR:-$PWD}

. ../env.sh

(
    export disease=chik
    export species=albopictus
    export region=rect_0_0
    module load mosquitodata/0.1.0
    module load mosquito/0.2.0
    envsubst < mos_sim_template.yml > mos_sim_0_0.yml
)

tmp_init $PWD/tmp

cwltool \
    --beta-dependency-resolvers-configuration $VESTEC_CWL_PLATFORM_CONF \
    $VESTEC_CWL_ROOT/mosquito/mos.cwl \
    mos_sim_0_0.yml

tmp_finalise
