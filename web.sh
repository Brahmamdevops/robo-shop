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

dnf install nginx -y

validate $? "installing nginx"

systemctl enable nginx

validate $? "installing nginx"

systemctl start nginx

http://<public-IP>:80

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

cd /usr/share/nginx/html

unzip /tmp/web.zip

systemctl restart nginx 