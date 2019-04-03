# !/bin/bash

# Use this script to provision sidecars 

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
.  ${DIR}/set-project-env.sh


# DEV
. ${DIR}/../params/deployment-dev
echo  Executing command
oc tag sdgeshare/${SIDE_CAR_IMAGE}  ${NAMESPACE}/${SIDE_CAR_IMAGE}
oc get is --namespace ${NAMESPACE}
echo  Done


# INT
. ${DIR}/../params/deployment-int
echo  Executing command
echo  .
oc tag sdgeshare/${SIDE_CAR_IMAGE}  ${NAMESPACE}/${SIDE_CAR_IMAGE}
oc get is --namespace ${NAMESPACE}
echo  Done

# QA
. ${DIR}/../params/deployment-qa
echo  Executing command
echo  .
oc tag sdgeshare/${SIDE_CAR_IMAGE}  ${NAMESPACE}/${SIDE_CAR_IMAGE}
oc get is --namespace ${NAMESPACE}
echo  Done
