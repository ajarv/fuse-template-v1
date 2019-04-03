#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  ${DIR}/set-debug-env.sh

BASE_DIR="$( cd  ${DIR}/../../.. >/dev/null 2>&1 && pwd )"

#Create build config for debug image
cd ${BASE_DIR}

oc process --filename=openshift/templates/build.yml  --param-file=openshift/params/build-dev | oc delete -f-
oc process --filename=openshift/templates/build.yml  --param-file=openshift/params/build-dev | oc create -f-

oc process --filename=openshift/templates/deployment.yml  --param-file=openshift/params/deployment-dev | oc delete -f-
oc process --filename=openshift/templates/deployment.yml  --param-file=openshift/params/deployment-dev | oc create -f-

