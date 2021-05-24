thisdir=$(dirname $BASH_SOURCE)
# CWL stuff
module load nodejs cwl/3.1.20210521105815 

# Repository root
export VESTEC_CWL_ROOT=$(git rev-parse --show-toplevel)
export VESTEC_CWL_MPI_CONF=$(readlink -f $thisdir/mpi-conf.yml)
# Because of special per-node temporary RAM disk FS set up by
# system...  We need to ensure there is a tmpdir that can be used from
# login, MOM, and compute nodes, so it has to be on the work FS
#
# This will create one if it doesn't exist already
function tmp_init {
    _old_tmpdir=$TMPDIR
    export TMPDIR=$1
    if [ -d $TMPDIR ]; then
	_delete_tmp=false
    else
	_delete_tmp=true
	mkdir $TMPDIR
    fi
}
# This cleans up if the dir didn't exist when initialised.
function tmp_finalise {
    if $_delete_tmp; then
	rm -rf $TMPDIR
    fi
    export TMPDIR=_old_tmpdir
}

function cwldebug {
    python -m pdb `which cwltool` --debug $*
}
