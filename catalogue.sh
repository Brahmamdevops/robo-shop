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

dnf module disable nodejs -y &>> $LOGFILE

validate $? "disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

validate $? "enabling nodejs"

dnf list installed nodejs
if [ $? -ne 0]
then 
    dnf install nodejs -y &>> $LOGFILE
    validate $? "installing nodejs"
else 
    echo -e "already installed ...$Y Skipping $N"
fi

id roboshop

if [ $? -ne 0 ]
then
    echo -e "$R creating roboshop user $N"  &>> $LOGFILE
    validate $? "roboshop user created"
else
    echo -e "roboshop user already existed $Y Skipping  $N"
fi



mkdir -p /app   &>> $LOGFILE

validate $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE

validate $? "ddownloading catalogue application"

cd /app 

unzip -o /tmp/catalogue.zip &>> $LOGFILE

validate $? "unzipping catalogue"

npm install &>> $LOGFILE

validate $? "roboshop user created"

cp /home/centos/roboshop/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

systemctl daemon-reload &>> $LOGFILE

validate $? "catalogue daemon-reload"

systemctl enable catalogue &>> $LOGFILE

validate $? "enabling catalogue"

systemctl start catalogue &>> $LOGFILE

validate $? "starting catalogue"

cp  /home/centos/roboshop/mongo.repo /etc/yum.repos.d/mongo.repo  &>> $LOGFILE

validate $? "starting catalogue"

dnf list installed mongodb-org-shell 
if [ $? -ne 0]
then 
    dnf install mongodb-org-shell -y &>> $LOGFILE
    validate $? "installing mongodb-org-shell"
else 
    echo -e "already installed ...$Y Skipping $N"
fi

validate $? "installing mongodb-org-shell"


mongo --host $MONGODB_HOST </app/schema/catalogue.js

validate $? "loading catalogue data into mongodb"
