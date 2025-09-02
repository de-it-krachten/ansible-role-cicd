#!/bin/bash -e

# Get the name of the calling script
FILENAME=$(readlink -f $0)
BASENAME="${FILENAME##*/}"
BASENAME_ROOT=${BASENAME%%.*}
DIRNAME="${FILENAME%/*}"
TMPDIR=$(mktemp -d)


function Cleanup
{

  Artifact=$(echo ${IMAGE}.${TAG}.tgz | sed "s/\//./g")
  rm -f ${DIRNAME}/images/${Artifact}

}


#----------------------------------------------------------
# Load variables from file
#----------------------------------------------------------

set -a
source ${DIRNAME}/docker.properties
HTTPS_PROXY=${HTTPS_PROXY:-''}
HTTP_PROXY=${HTTP_PROXY:-''}
NO_PROXY=${NO_PROXY:-''}
ANSIBLE_FORCE_COLOR=1
CONTAINER_NAME=`echo $IMAGE | sed "s/.*\///"`
CONTAINER_IMAGE=${REGISTRY1}/${IMAGE}:${TAG}
BUILD_PATH=${TMPDIR}
set +a


#----------------------------------------------------------
# cleanup
#----------------------------------------------------------

Cleanup
exit 0
