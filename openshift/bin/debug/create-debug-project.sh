#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  ${DIR}/set-debug-env.sh

BASE_DIR="$( cd  ${DIR}/../../.. >/dev/null 2>&1 && pwd )"

#Create build config for debug image
cd ${BASE_DIR}
# oc new-app -n ${build_project} --name ${debug_app_name} redhat-openjdk18-openshift:1.1~.
oc new-build -n ${build_project} --name ${debug_app_name} redhat-openjdk18-openshift:1.1~.


# oc delete dc/${debug_app_name} 
# oc delete svc/${debug_app_name} 

oc get bc -n ${build_project}
