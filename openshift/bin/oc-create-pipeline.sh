#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
.  ${DIR}/set-project-env.sh

[[ $(oc whoami) == "admin" ]] && echo "You are logged into Openshift as Admin. Please logout and login as regular user." && exit 0
pushd ${DIR}/../..
ansible-playbook -i ./applier/bootstrap ./galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml
popd

echo "Project List"
oc get projects

echo "Provisioning sidecar imagestreams into newly created projects"

${DIR}/oc-insert-sidecars.sh

