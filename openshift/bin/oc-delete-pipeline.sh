#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
.  ${DIR}/set-project-env.sh

oc delete project ${project_name}-build
oc delete project ${project_name}-dev
oc delete project ${project_name}-int
oc delete project ${project_name}-qa
