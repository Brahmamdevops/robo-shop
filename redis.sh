#!/bin/bash

ID=$(id -u)


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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  

validate $? "redis api installing" 

dnf module enable redis:remi-6.2 -y

validate $? "enabling redis" 

dnf install redis -y

validate $? "installing redis" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf 

validate $? "allowing remote connections" 

systemctl enable redis

validate $? "enabling redis" 

systemctl start redis

validate $? "starting redis" 








