#!/bin/bash

project_config_file="project_config.yaml"

export BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." >/dev/null 2>&1 && pwd )"
project_config_file="project_config.yaml"

if [ ! -f ${BASE_DIR}/${project_config_file} ]; then
    echo "Project config file ${project_config_file} missing in current directory"
    exit 0
fi


echo .
echo "Bootstraping Openshift project"
echo .

cp ${BASE_DIR}/${project_config_file} ${BASE_DIR}/applier/project-setup/playbooks/roles/new-project-setup/vars/main.yml

pushd ${BASE_DIR}
# Install openshift ansible pipeline roles
ansible-galaxy install -r requirements.yml --roles-path=galaxy
# Create the project files from template.
ansible-playbook -i ./applier/bootstrap ./applier/project-setup/playbooks/setup.yaml
# Commit git changes
git add .
git commit -m "Setup Project files"
git push --set-upstream origin master
popd
