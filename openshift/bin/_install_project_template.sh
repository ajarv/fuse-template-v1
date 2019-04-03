#!/bin/bash


base_template="fuse-template-v2"
project_config_file="project_config.yaml"
template_git_repo="https://aplsiscmp001/sdge-si-fuse-templates/${base_template}"

echo "###############################################"
echo "# OpenShift Project Setup Script"
echo "###############################################"
echo .

export BASE_DIR=$(pwd)
echo   "BASE_DIR : $BASE_DIR" 
#Check if project config exists

if [ ! -f ${BASE_DIR}/${project_config_file} ]; then
    echo "Project config file ${project_config_file} missing in current directory"
    echo "Please go through the readme file at  ${template_git_repo} to create it."
    exit 0
fi

echo .
echo "Cloning Template project to /tmp/${base_template}"
echo .
rm -rf /tmp/${base_template}
git clone ${template_git_repo} /tmp/${base_template}

echo .
echo "Creating ${BASE_DIR}/openshift ${BASE_DIR}/applier from template"
echo .

cp -r /tmp/${base_template}/openshift ${BASE_DIR}
cp -r /tmp/${base_template}/applier ${BASE_DIR}
cp  /tmp/${base_template}/Jenkinsfile ${BASE_DIR}
cp  /tmp/${base_template}/requirements.yml ${BASE_DIR}
cp  /tmp/${base_template}/.gitignore ${BASE_DIR}
cp  -r /tmp/${base_template}/.docker ${BASE_DIR}

if [ ! -f ${BASE_DIR}/pom.xml ]; then
    echo "Copying a demo maven project with springboot application to project"
    cp -r /tmp/${base_template}/src ${BASE_DIR}
    cp -r /tmp/${base_template}/pom.xml ${BASE_DIR}
else
    echo "Using existing Maven project"
fi

# Call Bootstrap script
${BASE_DIR}/openshift/bin/_bootstrap-project.sh