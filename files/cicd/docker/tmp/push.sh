#!/bin/bash -e

# Get the name of the calling script
FILENAME=$(readlink -f $0)
BASENAME="${FILENAME##*/}"
BASENAME_ROOT=${BASENAME%%.*}
DIRNAME="${FILENAME%/*}"
TMPDIR=$(mktemp -d)


# Make sure we cleanup our crap at exit
trap 'cd / ; rm -fr ${TMPDIR} ${HOME}/.docker/config.json' EXIT


#----------------------------------------------------------
# Load variables from file
#----------------------------------------------------------

set -a
source ${DIRNAME}/docker.properties
HTTPS_PROXY=${HTTPS_PROXY:-''}
HTTP_PROXY=${HTTP_PROXY:-''}
NO_PROXY=${NO_PROXY:-''}
ANSIBLE_FORCE_COLOR=1
set +a


#----------------------------------------------------------
# save image
#----------------------------------------------------------

echo "Load docker image from file"
Artifact=$(echo $IMAGE.$TAG.tgz | sed "s/\//./g")
[[ ! -d ${DIRNAME}/images ]] && mkdir ${DIRNAME}/images
docker load < ${DIRNAME}/images/${Artifact}


#----------------------------------------------------------
# Configure docker client w/ nexus access
#----------------------------------------------------------

echo "Login to Nexus docker repo"
[[ ! -d ${HOME}/.docker ]] && mkdir -p "${HOME}/.docker"
echo "${DOCKER_AUTH_CONFIG}" | jq . > ${HOME}/.docker/config.json


#----------------------------------------------------------
# Push image to local registry
#----------------------------------------------------------

echo "Pushing image to '${REGISTRY1}/${IMAGE}:${TAG}'"
docker image push ${REGISTRY1}/${IMAGE}:${TAG}
