thisdir=$(dirname $BASH_SOURCE)

# Software requirements for platform
export VESTEC_CWL_PLATFORM_CONF=$(readlink -f $thisdir/modules-conf.yml)

. $thisdir/../env.sh
