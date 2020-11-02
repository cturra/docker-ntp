#!/bin/bash

# grab global variables
source vars

DOCKER=$(which docker)
BUILD_INST=${CONTAINER_NAME}"-builder"

## requirements:
# - docker buildx plugin (https://docs.docker.com/buildx/working-with-buildx/)
if [[ ! -f ~/.docker/cli-plugins/buildx ]]; then
  echo "[ERROR] docker buildx plugin not found!"
  echo "        => https://github.com/docker/buildx/"
  exit 1

else
  # check if build instance (BUILD_INST) is present
  $DOCKER buildx ls | grep ${BUILD_INST} 2>&1 /dev/null
  if [ $? -eq 1 ]; then
    # not found. let's create it
    $DOCKER run --rm --privileged multiarch/qemu-user-static --reset -p yes
    $DOCKER buildx create --name ${BUILD_INST} --driver docker-container --use
  fi

  # finally, let's build the ntp container
  $DOCKER buildx use ${BUILD_INST}
  $DOCKER buildx build --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 \
                       --tag ${IMAGE_NAME} \
                       --push .
fi
