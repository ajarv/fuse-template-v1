openshift.withCluster() {
  env.NAMESPACE = openshift.project()
  env.POM_FILE = env.BUILD_CONTEXT_DIR ? "${env.BUILD_CONTEXT_DIR}/pom.xml" : "pom.xml"
  env.APP_NAME = "${env.JOB_NAME}".replaceAll(/-?pipeline-?/, '').replaceAll(/-?${env.NAMESPACE}-?/, '').replaceAll("/", '')
  echo "Starting Pipeline for ${APP_NAME}..."
  def projectBase = "${env.NAMESPACE}".replaceAll(/-build/, '')
  env.BUILD = "${projectBase}-build"
  env.DEV = "${projectBase}-dev"
  env.INT = "${projectBase}-int"
  env.QA = "${projectBase}-qa"
}

 pipeline {
  // Use Jenkins Maven slave
  // Jenkins will dynamically provision this as OpenShift Pod
  // All the stages and steps of this Pipeline will be executed on this Pod
  // After Pipeline completes the Pod is killed so every run will have clean
  // workspace
  agent {
    label 'maven'
  }

  // Pipeline Stages start here
  // Requeres at least one stage
  stages {

    // Checkout source code
    // This is required as Pipeline code is originally checkedout to
    // Jenkins Master but this will also pull this same code to this slave
    stage('Git Checkout') {
      steps {

        echo "APPLICATION_SOURCE_REPO is ${APPLICATION_SOURCE_REPO}"

        git url: "https://github.com/jenkinsci/kubernetes-plugin.git"
          // Turn off Git's SSL cert check, uncomment if needed
          // sh 'git config --global http.sslVerify false'
        git url: "${APPLICATION_SOURCE_REPO}"
      }
    }

    // Run Maven build, skipping tests
    stage('Build'){
      steps {        
          sh "mvn clean install -DskipTests=true -f ${POM_FILE}"
      }
    }

    // Run Maven unit tests
    stage('Unit Test'){
      steps {
          sh "mvn test -f ${POM_FILE}"
      }
    }

    // Build Container Image using the artifacts produced in previous stages
    stage('Build Container Image'){
      steps {
          // Copy the resulting artifacts into common directory
          sh """
            ls target/*
            rm -rf oc-build && mkdir -p oc-build/deployments
            for t in \$(echo "jar;war;ear" | tr ";" "\\n"); do
              cp -rfv ./target/*.\$t oc-build/deployments/ 2> /dev/null || echo "No \$t files"
            done
          """

          // Build container image using local Openshift cluster
          // Giving all the artifacts to OpenShift Binary Build
          // This places your artifacts into right location inside your S2I image
          // if the S2I image supports it.
          script {
            openshift.withCluster() {
              openshift.withProject("${BUILD}") {
                openshift.selector("bc", "${APP_NAME}").startBuild("--from-dir=oc-build").logs("-f")
              }
            }
          }
      }
    }
    stage('Promote from Build to Dev') {
      steps {
          // Deploy Fuse Console
          sh """
            oc project ${DEV}
            oc get --export templates -n openshift fuse70-console -o yaml > openshift/templates/fuse70-console.yml
          """
          // Apply env specific configuration 
          sh """
            oc project ${DEV}
            /bin/bash ./applier/configmap.sh app-config openshift/config/dev-app-config.yml
          """
          // Run openshift applier playbook for this env
          sh """
            oc project ${DEV}
            ansible-galaxy install -r requirements.yml --roles-path=galaxy
            ansible-playbook -i ./applier/deployments galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml --extra-vars "env_name=dev"
          """
          script {
            openshift.withCluster() {
              openshift.tag("${env.BUILD}/${env.APP_NAME}:latest", "${env.DEV}/${env.APP_NAME}:latest")
            }
          }
      }
    }

    stage ('Verify Deployment to Dev') {
      steps {
        
          script {
            openshift.withCluster() {
                openshift.withProject("${DEV}") {
                def dcObj = openshift.selector('dc', env.APP_NAME).object()
                def podSelector = openshift.selector('pod', [deployment: "${APP_NAME}-${dcObj.status.latestVersion}"])
                podSelector.untilEach {
                    echo "pod: ${it.name()}"
                    return it.object().status.containerStatuses[0].ready
                }
              }
            }
          }
        
      }
    }

    stage('Promote from Dev to Int') {  
      steps {
          input "Promote from Dev to Int?"
          // Deploy Fuse Console
          sh """
            oc project ${INT}
            oc get --export templates -n openshift fuse70-console -o yaml > openshift/templates/fuse70-console.yml
          """
          // Apply env specific configuration 
          sh """
            oc project ${INT}
            /bin/bash ./applier/configmap.sh app-config openshift/config/dev-app-config.yml
          """
          // Run openshift applier playbook for this env
          sh """
            oc project ${INT}
            ansible-galaxy install -r requirements.yml --roles-path=galaxy
            ansible-playbook -i ./applier/deployments galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml --extra-vars "env_name=int"
          """
          script {
            openshift.withCluster() {
              openshift.tag("${env.DEV}/${env.APP_NAME}:latest", "${env.INT}/${env.APP_NAME}:latest")
            }
          }
      }
    }

    stage ('Verify Deployment to Int') {
      steps {
        
          script {
            openshift.withCluster() {
                openshift.withProject("${INT}") {
                def dcObj = openshift.selector('dc', env.APP_NAME).object()
                def podSelector = openshift.selector('pod', [deployment: "${APP_NAME}-${dcObj.status.latestVersion}"])
                podSelector.untilEach {
                    echo "pod: ${it.name()}"
                    return it.object().status.containerStatuses[0].ready
                }
              }
            }
          }
        
      }
    }
    stage('Promote from Int to QA') {
      steps {
        
          input "Promote from Int to QA?"
          // Deploy Fuse Console
          sh """
            oc project ${QA}
            oc get --export templates -n openshift fuse70-console -o yaml > openshift/templates/fuse70-console.yml
          """
          // Apply env specific configuration 
          sh """
            oc project ${QA}
            /bin/bash ./applier/configmap.sh app-config openshift/config/dev-app-config.yml
          """
          // Run openshift applier playbook for this env
          sh """
            oc project ${QA}
            ansible-galaxy install -r requirements.yml --roles-path=galaxy
            ansible-playbook -i ./applier/deployments galaxy/openshift-applier/playbooks/openshift-cluster-seed.yml --extra-vars "env_name=qa"
          """
          script {
            openshift.withCluster() {
              openshift.tag("${env.INT}/${env.APP_NAME}:latest", "${env.QA}/${env.APP_NAME}:latest")
            }
          }
        
      }
    }

    stage ('Verify Deployment to QA') {
      steps {
        
          script {
            openshift.withCluster() {
                openshift.withProject("${QA}") {
                def dcObj = openshift.selector('dc', env.APP_NAME).object()
                def podSelector = openshift.selector('pod', [deployment: "${APP_NAME}-${dcObj.status.latestVersion}"])
                podSelector.untilEach {
                    echo "pod: ${it.name()}"
                    return it.object().status.containerStatuses[0].ready
                }
              }
            }
          }
        
      }
    }
    stage('Publish Image to Nexus') {
	    steps {
        sh """
          mkdir $HOME/.docker
          oc whoami -t | xargs -I {} echo -n "unused:{}" | base64 -w 0 | xargs -I {} sed -i 's/LOGIN_TOKEN/{}/g' .docker/config.json
          cp .docker/config.json $HOME/.docker/
          python -c 'from xml.etree.ElementTree import ElementTree; print ElementTree(file="pom.xml").findtext("{http://maven.apache.org/POM/4.0.0}version")' | xargs -I {} \
        	oc image mirror docker-registry.default.svc:5000/${APP_NAME}-qa/${APP_NAME}:latest nexus-repo-hostname:8443/registry/${APP_NAME}-prod/${APP_NAME}:{} --insecure=true
        """
      }
    }
  }
}
