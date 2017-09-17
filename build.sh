#!/bin/bash

# grab global variables
source vars

DOCKER=$(which docker)

# build image
$DOCKER build --pull --tag ${IMAGE_NAME} .
