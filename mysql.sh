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

dnf module disable mysql -y

validate $? "disabling mysql"

dnf install mysql-community-server -y

validate $? "installing mysql-community-server"

systemctl enable mysqld

validate $? "enabling mysqld"

systemctl start mysqld

validate $? "starting mysqld"

mysql_secure_installation --set-root-pass RoboShop@1

mysql -uroot -pRoboShop@1



