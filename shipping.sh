#1/bin/bash

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
        echo  -e "$R $2 ... error $N"
    else
        echo  -e "$G $2 ... success $N"
    fi
}


if [ $ID -ne 0 ]
then
    echo -e " $R please install with root user $N"
    exit 1
else
    echo "you are root user"
fi

dnf install maven -y

validate $? "installing maven"

id roboshop
if [ $? -ne 0 ]
then
      useradd roboshop
      validate $? "create user roboshop"
else 
    echo "user already  existed .. $Y Skipping $N "
fi

mkdir /app

validate $? "installing maven"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /app

unzip /tmp/shipping.zip

validate $? "shipping unzip"


cd /app

mvn clean package

validate $? "cleaning maven"

mv target/shipping-1.0.jar shipping.jar

systemctl daemon-reload

validate $? "daemon reloading"

systemctl enable shipping 

validate $? "enabling shipping"

systemctl start shipping

validate $? "starting shipping"

dnf install mysql -y

validate $? "installing mysql"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql 

systemctl restart shipping  

validate $? "restarting shipping"

