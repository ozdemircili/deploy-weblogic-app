#!/bin/bash


#This program is used to deploy Weblogic App version directly from Console

cat << EOF

This program is used to deploy Weblogic Apps  directly from shell prompt.

Actually very useful as it is painless and very very fast.

Usage: Best way to add the following entry to the .bashrc or .bash_profile of the weblogic user. 

Eg: alias Deploy="/bin/bash /etc/scripts/Deploy.sh"


VERSION: 1.7

EOF

export hostname=`hostname`

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


echo "Killing Managed01"

export ManagedPid=`ps -C java --no-headers -o pid,args | grep Managed01 | awk '{print $1}'`
echo $ManagedPid
if [ "$ManagedPid" != "" ]
then
   kill -9 $ManagedPid
fi

sleep 1


echo "Starting Managed01"

cd /u01/app/oracle/middleware/user_projects/domains/base_domain/bin

./startManagedWebLogic.sh Managed01 ${hostname}:7001 1>/u01/app/oracle/middleware/user_projects/domains/base_domain/servers/Managed01/logs/Managed01.out 2>&1 &

echo "Waiting for Managed01"
v=0
echo -e "

         \|||/
         (o o)
 ,~~~ooO~~(_)~~~~~~~~~,
 |     Waiting        |
 |    a bit here      |
 |                    |
 '~~~~~~~~~~~~~~ooO~~~'
        |__|__|
         || ||
        ooO Ooo

"

sleep 1
while [ $v -eq 0 ]
do
   sleep 1
   v=`tail --lines=10 /u01/app/oracle/middleware/user_projects/domains/base_domain/servers/Managed01/logs/Managed01.log | grep -c "Server started in RUNNING mode"`
done


echo "Setting Environment"
cd /u01/app/oracle/middleware/wlserver_10.3/server/bin/
. setWLSEnv.sh

echo "Undeploying application..."
java weblogic.Deployer -adminurl http://${hostname}:7001 -user $USERNAME -password $PASSWORD -undeploy -name $APPNAME -targets $TARGET 

java weblogic.Deployer -adminurl http://${hostname}localhost:7001 -user $USERNAME -password $PASSWORD -deploy -name $APPNAME -targets $TARGET  -nowait -source $SOURCE

echo $APPNAME "is deployed successfully"

exit
