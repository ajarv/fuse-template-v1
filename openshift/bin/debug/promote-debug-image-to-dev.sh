#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  ${DIR}/set-debug-env.sh


#Promote debug image to dev
echo .
echo "Tagging debug image as dev image ..."
echo "> oc tag ${build_project}/${debug_app_name}:latest ${dev_project}/${project_name}:latest"
echo .

oc tag ${build_project}/${debug_app_name}:latest ${dev_project}/${project_name}:latest


echo .
echo "To check pod status run"
echo "> oc get pods -n  ${dev_project}"
echo .
