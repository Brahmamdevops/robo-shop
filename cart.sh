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

dnf module disable nodejs -y

validate $? "disabling nodejs"

dnf module enable nodejs:18 -y

validate $? "enabling nodejs"

dnf install nodejs -y

validate $? "installing nodejs"

id useradd roboshop
if [ $? -ne 0 ]
then
    useradd roboshop
    validate $? "created user roboshop"
else 
    "user already existed ...$Y skipping $N"
fi

mkdir /app

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip

validate $? ""

cd /app 

validate $? ""

unzip /tmp/cart.zip

validate $? ""

cd /app 

validate $? ""

npm install 

validate $? " install dependencies"

systemctl daemon-reload

validate $? "daemon reloading"

systemctl enable cart 

validate $? "enabling cart"

systemctl start cart

validate $? "starting cart"


