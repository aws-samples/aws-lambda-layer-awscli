#!/bin/bash
#
# This script is a Lambda custom fucntion that watches the Amazon ECS Task state changes 
# and print the task public IP address when new task is RUNNING
#


echo "====[EVENT]===="
echo "$1"
echo "====[/EVENT]===="

region=${AWS_REGION}

taskArn=$(echo "$1"  | \
jq -r 'select(
    .["detail-type"]=="ECS Task State Change" and
    .source=="aws.ecs" and
    .detail.lastStatus=="RUNNING" and 
    .detail.desiredStatus=="RUNNING" and 
    .detail.connectivity=="CONNECTED"
    )  | .detail.taskArn')
    
if [ -z $taskArn ]; then
    echo "[INFO] skipping this event"
    exit 0
fi

eni=$(aws --region $region ecs describe-tasks --tasks $taskArn | \
jq -r '.tasks[0].attachments[0].details[] | select(.name=="networkInterfaceId").value')

publicIp=$(aws --region $region ec2 describe-network-interfaces --network-interface-ids $eni | \
jq -r '.NetworkInterfaces[0].Association.PublicIp')

echo "=> [OK] new Amazon ECS task stablized"
echo "taskArn=$taskArn"
echo "eni=$eni"
echo "publicIp=$publicIp"


exit 0
