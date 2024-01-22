#!/bin/bash

ID=$(id -u)

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "$0 shell script start time $TIMESTAMP"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGODB_HOST=MONGODB-SERVER-IPADDRESS

validate(){
    if [ $? -ne 0]
    then 
        echo -e "$R . . . error $N"
    else
        echo -e "$G success $N"
}

if [ $ID -ne 0 ]
then
    echo -e "$R please install with root user $N"
    exit 1
else
    echo -e "$G you are root user $N"
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

dnf install rabbitmq-server -y 

validate $? "installing rabbitmq-server"

systemctl enable rabbitmq-server 

validate $? "enabling rabbitmq-server"

systemctl start rabbitmq-server 

validate $? "starting rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"