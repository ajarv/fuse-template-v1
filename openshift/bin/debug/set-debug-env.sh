#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source  ${DIR}/../set-project-env.sh

export debug_app_name=${project_name}-debug
export build_project=${project_name}-build
export dev_project=${project_name}-dev

