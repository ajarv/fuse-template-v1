#!/bin/bash
NAME=$1
CONFIG_MAP=$2
T1=$(oc get configmap  --no-headers --output=custom-columns=NAME:.metadata.name | grep "^${NAME}\$")

if [ "$T1" == "$NAME" ]; then
    oc apply -f $CONFIG_MAP
else
    oc create --save-config -f $CONFIG_MAP
fi
