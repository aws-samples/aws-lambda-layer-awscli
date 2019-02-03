#!/bin/bash

export PATH=$PATH:/opt/awscli

runInstance(){
    aws ec2 run-instances --launch-template LaunchTemplateId=lt-09f5b266cb7aa1070,Version=1 --subnet-id subnet-b22861d5 --query 'Instances[0].InstanceId' --output text
}

getPublicIp(){
    aws ec2 describe-instances --instance-ids $1 --query 'Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicIp' --output text
}

instanceId=$(runInstance)

publicIp=$(getPublicIp $instanceId)

result="已開啟位於美西主機, IP：$publicIp. 請使用public key登入"

# echo the http response for API Gateway proxy integration
cat << EOF
{"body": "$result", "headers": {"content-type": "text/plain"}, "statusCode": 200}
EOF
