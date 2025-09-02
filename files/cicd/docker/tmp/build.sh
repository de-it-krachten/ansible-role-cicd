#!/bin/bash -e

# Get the name of the calling script
FILENAME=$(readlink -f $0)
BASENAME="${FILENAME##*/}"
BASENAME_ROOT=${BASENAME%%.*}
DIRNAME="${FILENAME%/*}"
TMPDIR=$(mktemp -d)
TMPFILE=${TMPDIR}/.tmp.${RANDOM}.${RANDOM}


function Cleanup
{

  rm -fr ${TMPDIR}
  rm -f ${HOME}/.docker/config.json

}

Build=true
Push=false

# parse command line into arguments and check results of parsing
while getopts :bBd:pP OPT
do
   case $OPT in
     b) Build=true
        ;;
     B) Build=false
        ;;
     d) set -vx
        ;;
     p) Push=true
        ;;
     P) Push=false
        ;;
     *) echo "Unknown flag -$OPT given!" >&2
        exit 1
        ;;
   esac

   # Set flag to be use by Test_flag
   eval ${OPT}flag=1

done
shift $(($OPTIND -1))


# Make sure we cleanup our crap at exit
trap 'cd / ; Cleanup' EXIT


#----------------------------------------------------------
# Load variables from file
#----------------------------------------------------------

# Read all required variables and/or contruct them
set -a
source docker.properties
HTTPS_PROXY=${HTTPS_PROXY:-''}
HTTP_PROXY=${HTTP_PROXY:-''}
NO_PROXY=${NO_PROXY:-''}
ANSIBLE_FORCE_COLOR=1
CONTAINER_NAME=`echo $IMAGE | sed "s/.*\///"`
CONTAINER_IMAGE=${REGISTRY1}/${IMAGE}:${TAG}
BUILD_PATH=${TMPDIR}
set +a


# Show important variables
cat <<EOF
CONTAINER_IMAGE=$CONTAINER_IMAGE
CONTAINER_PRIVILEGED=$CONTAINER_PRIVILEGED
BUILD_PATH=$BUILD_PATH
EOF


#----------------------------------------------------------
# build image
#----------------------------------------------------------

cp Dockerfile.j2 ${TMPDIR}
[[ -d certificates ]] && cp -pr certificates ${TMPDIR}
e2j2 -f ${TMPDIR}/Dockerfile.j2

if [[ $ANSIBLE == true ]]
then
  rsync -av ${DIRNAME}/ansible ${TMPDIR}
  [[ -f requirements.yml ]] && cp requirements.yml ${TMPDIR}/ansible/roles
  [[ -f build-custom.yml ]] && cp build-custom.yml ${TMPDIR}/ansible

  cd ${TMPDIR}/ansible
  # Ansible_args="-i localhost, -c local -e ansible_python_interpreter=/usr/libexec/platform-python"
  Ansible_args="-i localhost, -c local"
  ansible-galaxy install -r roles/requirements.yml -p roles/ --ignore-errors
  ansible-playbook build.yml $Ansible_args
  cd - >/dev/null
else
  cd ${TMPDIR}
  docker build -t ${CONTAINER_IMAGE} .
  cd - >/dev/null
fi


#----------------------------------------------------------
# Configure docker client w/ nexus access
#----------------------------------------------------------

if [[ $Push == true ]]
then

  echo "Login to Nexus docker repo"
  [[ ! -d ${HOME}/.docker ]] && mkdir -p "${HOME}/.docker"
  echo "${DOCKER_AUTH_CONFIG}" | jq . > ${HOME}/.docker/config.json

fi

#----------------------------------------------------------
# Push image to local registry
#----------------------------------------------------------

if [[ $Push == true ]]
then

  echo "Pushing image to '${REGISTRY1}/${IMAGE}:${TAG}'"
  docker image push ${REGISTRY1}/${IMAGE}:${TAG}

fi
