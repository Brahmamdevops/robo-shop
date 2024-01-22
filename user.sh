#!/bin/bash

ID=$(id -u)

MONGODB_HOST=MONGODB-SERVER-IPADDRESS

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "$0 shell script start time $TIMESTAMP"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 ... failed"
    else 
        echo -e "$G $2 ....success"
}

if [ $ID -ne 0 ]
then 
    echo -e " $R Error : please install with root user $N"
    exit 1
else 
    echo -e "you are root user"
fi

dnf module disable nodejs -y

validate $? "disabling nodejs"

dnf module enable nodejs:18 -y

validate $? "enabling nodejs"

dnf install nodejs -y

validate $? "installing nodejs"


id roboshop
if [ $? -ne 0 ]
then
      useradd roboshop
      validate $? "create user roboshop"
else 
    echo "user already  existed .. $Y Skipping $N "
fi

mkdir /app

validate $? "create user roboshop"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

validate $? "create user roboshop"

cd /app 

validate $? "create user roboshop"

unzip /tmp/user.zip

validate $? "create user roboshop"

cd /app 

validate $? "create user roboshop"


npm install 

validate $? "installing npm"

cp /home/centos/Roboshop/user.service /etc/systemd/system/user.service

validate $? "copying user service"

systemctl daemon-reload

validate $? "daemon reloading"

systemctl enable user 

validate $? "enabling user"

systemctl start user

validate $? "starting user"

cp home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org-shell -y

validate $? "installing mongo-org-shell"

mongo --host $MONGODB_HOST </app/schema/user.js

validate $? "mongo server hosted"



