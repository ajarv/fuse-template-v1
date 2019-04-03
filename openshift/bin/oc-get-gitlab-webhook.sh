#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
.  ${DIR}/set-project-env.sh

oc project ${project_name}-build

webhook_secret=$(oc get bc ${project_name}-pipeline -o=go-template='{{  range $k, $value := .spec.triggers  }}{{ if $value.gitlab }}{{ $value.gitlab.secret }}{{end}}{{end}}')
webhook_url=$(oc describe bc ${project_name}-pipeline | grep webhooks | awk '{print $2}')
gitlab_webhook_url="${webhook_url/<secret>/$webhook_secret}"

echo .
echo "Use the below webhook url to automate build triggers from GitLab"
echo ${gitlab_webhook_url}
echo .
