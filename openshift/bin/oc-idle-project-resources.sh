#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
.  ${DIR}/set-project-env.sh

oc idle -n ${project_name}-build ${project_name}  jenkins jenkins-jnlp
oc idle -n ${project_name}-dev ${project_name}  fuse70-console-service
oc idle -n ${project_name}-int ${project_name}  fuse70-console-service
oc idle -n ${project_name}-qa ${project_name}  fuse70-console-service

