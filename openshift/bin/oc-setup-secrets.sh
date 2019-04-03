# !/bin/bash

# Use this script to setup the passwords, secrets and keystores in the Openshift projects.

# ------------------
# setup for dev env
# ------------------
oc project sample-app-dev

identity_jks=./openshift/config/identity.jks
trust_jks=./openshift/config/trust.jks
password=password

mkdir -p /tmp/ssl-keystore 
cp  ${identity_jks} /tmp/ssl-keystore
cp  ${trust_jks} /tmp/ssl-keystore

oc delete secret ssl-keystore ssl-keystore-password
oc create secret generic ssl-keystore --from-file=/tmp/ssl-keystore 
oc create secret generic ssl-keystore-password --from-literal=password=${password}
rm -rf /tmp/ssl-keystore

# ------------------
# setup for dev int
# ------------------
oc project sample-app-int

identity_jks=./openshift/config/identity.jks
trust_jks=./openshift/config/trust.jks
password=password

mkdir -p /tmp/ssl-keystore 
cp  ${identity_jks} /tmp/ssl-keystore
cp  ${trust_jks} /tmp/ssl-keystore

oc delete secret ssl-keystore ssl-keystore-password
oc create secret generic ssl-keystore --from-file=/tmp/ssl-keystore 
oc create secret generic ssl-keystore-password --from-literal=password=${password}
rm -rf /tmp/ssl-keystore

# ------------------
# setup for dev qa
# ------------------
oc project sample-app-qa

identity_jks=./openshift/config/identity.jks
trust_jks=./openshift/config/trust.jks
password=password

mkdir -p /tmp/ssl-keystore 
cp  ${identity_jks} /tmp/ssl-keystore
cp  ${trust_jks} /tmp/ssl-keystore

oc delete secret ssl-keystore ssl-keystore-password
oc create secret generic ssl-keystore --from-file=/tmp/ssl-keystore 
oc create secret generic ssl-keystore-password --from-literal=password=${password}
rm -rf /tmp/ssl-keystore

oc project sample-app-build
