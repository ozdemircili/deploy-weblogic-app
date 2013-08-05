#!/bin/bash

echo -n "Please Enter the fullpath to your ear file: "
read source 
echo -n "What is your application called?: "
read appname
echo -n "Please enter the target name: "
read target
echo -n "Please enter the weblogic username: "
read username
echo -n "Please enter the weblogic password: "
read password


echo "Setting Environment"
find /-name "setWLSEnv.sh" -exec /bin/bash {} \;


echo "Undeploying application..."
java weblogic.Deployer -adminurl http://localhost:7001 -user $USERNAME -password $PASSWORD -undeploy -name $APPNAME -targets $TARGET 

java weblogic.Deployer -adminurl http://localhost:7001 -user $USERNAME -password $PASSWORD -deploy -name $APPNAME -targets $TARGET  -nowait -source $SOURCE

echo $APPNAME "is deployed successfully"

exit
