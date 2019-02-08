#!/bin/bash
#
# This script is a Lambda custom fucntion that watches the Amazon ECS Task state changes 
# and print the task public IP address when new task is RUNNING
# check https://twitter.com/pahudnet/status/1080491306420363264 for screenshot


echo "====[EVENT]===="
echo "$1"
echo "====[/EVENT]===="

region=${AWS_REGION}

clusterArn=$(echo $1 | jq -r '.detail.clusterArn')

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

eni=$(aws --region $region ecs describe-tasks --tasks $taskArn --cluster $clusterArn | \
jq -r '.tasks[0].attachments[0].details[] | select(.name=="networkInterfaceId").value')

publicIp=$(aws --region $region ec2 describe-network-interfaces --network-interface-ids $eni | \
jq -r '.NetworkInterfaces[0].Association.PublicIp')

echo "=> [OK] new Amazon ECS task stablized"
echo "taskArn=$taskArn"
echo "eni=$eni"
echo "publicIp=$publicIp"


# update route53
cat << EOF > /tmp/update.json
{
    "Comment": "UPSERT a record ",
    "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
        "Name": "fargate.demo.pahud.net",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [{ "Value": "$publicIp"}]
}}]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id Z2N5MJJUEIAVLZ --change-batch file:///tmp/update.json

exit 0
