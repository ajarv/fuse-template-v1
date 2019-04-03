#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  ${DIR}/set-debug-env.sh

BASE_DIR="$( cd  ${DIR}/../../.. >/dev/null 2>&1 && pwd )"

#Create build config for debug image
cd ${BASE_DIR}

echo "Building new image from local sources by running command"
echo ">oc start-build ${debug_app_name} -n ${build_project} --from-dir=."

oc start-build ${debug_app_name} -n ${build_project} --from-dir=.

echo "."
echo "If this is first time you are building debug project it may take a minute or two for build to complete"
echo "."
echo "To Check if your build finished run  "
echo "> oc get build -n ${build_project} "
echo "A build finishes with either a Complete or a Failed Status"
echo "."
echo "To check recently built image streams run"
echo "> oc get is -n ${build_project} "
echo "."

oc get build -n ${build_project}

echo "."
echo "To promote an image stream to dev project run"
echo "> oc tag ${build_project}/${debug_app_name}:latest ${dev_project}/${project_name}:latest"
echo "This should automatically restart your dev applcation"
echo "."


