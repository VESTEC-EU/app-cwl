# Source this to make things work on ARCHER2
thisdir=$(dirname $BASH_SOURCE)

module -s load epcc-job-env
module use /work/d170/shared/modules
module use /work/d170/d170/shared/modules

# CWL stuff
module load nodejs cwl

# Repository root
export VESTEC_CWL_ROOT=$(git rev-parse --show-toplevel)
# Software requirements for platform
export VESTEC_CWL_PLATFORM_CONF=$(readlink -f $thisdir/modules-conf.yml)
export VESTEC_CWL_MPI_CONF=$(readlink -f $thisdir/mpi-conf.yml)


# On Archer 2, /tmp is a per-node in memory FS.
#
# To debug temporaries, if running multinode, or if running
# interactively via salloc you will want to use these functions.

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
