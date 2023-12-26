#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-0e550adac10662ae6
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
ZONE_ID=Z015866725GKGKSNADT5C
DOMAIN_NAME="mvaws.online"

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb"] || [ $i == "mysql"] || [ $i == "shipping"]
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-087e7afb3a936fce7 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=production}]" --query 'Instances[0]. PrivateIpAddress' --output text)

    echo "$i : $IP_ADDRESS" 

    #create R53 records, make sure that delete existing records
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Testing creating a record set"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
    '

done