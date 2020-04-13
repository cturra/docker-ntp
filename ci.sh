#!/bin/bash
# Taken from https://gist.github.com/qdm12/e97f2a7cfd266024571ac2d1ce0c8580

echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin &> /dev/null

if [ "$TRAVIS_PULL_REQUEST" = "true" ] || [ "$TRAVIS_BRANCH" != "master" ]; then
  docker buildx build \
    --progress plain \
    --platform=linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x \
    -t $DOCKER_REPO:$TRAVIS_BRANCH \
    --push \
    .
  exit $?
fi

TAG="${TRAVIS_TAG:-latest}"
echo "TAG: $TAG"
docker buildx build \
     --progress plain \
    --platform=linux/amd64,linux/386,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x \
    -t $DOCKER_REPO:$TAG \
    --push \
    .

