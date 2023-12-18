#1/bin/bash

ID=$(id -u)

echo " $0 is started"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

validate(){
    if [ $1 -ne 0 ]
    then
        echo  -e "$R $2 ... error $N"
    else
        echo  -e "$G $2 ... success $N"
    fi
}


if [ $ID -ne 0 ]
then
    echo "please install with root user"
    exit 1
else
    echo "you are root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo

validate $? "coping mongo repo"

dnf install mongodb-org -y  &>> $LOGFILE

validate $? "installing mongodb"

systemctl enable mongod &>> $LOGFILE

validate $? "enabling mongodb"

systemctl start mongod &>> $LOGFILE

validate $? "starting mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

validate $? "remote access"

systemctl restart mongod &>> $LOGFILE

validate $? "restarting mongodb"
