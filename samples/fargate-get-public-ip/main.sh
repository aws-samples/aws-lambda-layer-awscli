#!/bin/bash
#
# This script is a Lambda custom fucntion that watches the Amazon ECS Task state changes 
# and print the task public IP address when new task is RUNNING
# check https://twitter.com/pahudnet/status/1080491306420363264 for screenshot


# update with cloudmap
cm_register_instance() {
    # Usage: cm_register_instance serviceId instanceId ipAddress
    aws servicediscovery register-instance --service-id $1 \
    --instance-id "$2" \
    --attributes=AWS_INSTANCE_IPV4="$3"
}

cm_deregister_instance() {
    # Usage: cm_deregister_instance serviceId instanceId 
    aws servicediscovery deregister-instance --service-id $1 --instance-id "$2" 
}



echo "====[EVENT]===="
echo "$1"
echo "====[/EVENT]===="

region=${AWS_REGION}

clusterArn=$(echo $1 | jq -r '.detail.clusterArn')

taskArnRunning=$(echo "$1"  | \
jq -r 'select(
    .["detail-type"]=="ECS Task State Change" and
    .source=="aws.ecs" and
    .detail.lastStatus=="RUNNING" and 
    .detail.desiredStatus=="RUNNING" and 
    .detail.connectivity=="CONNECTED"
    )  | .detail.taskArn')

taskArnStopped=$(echo "$1"  | \
jq -r 'select(
    .["detail-type"]=="ECS Task State Change" and
    .source=="aws.ecs" and
    .detail.lastStatus=="STOPPED" and 
    .detail.desiredStatus=="STOPPED" and 
    .detail.connectivity=="CONNECTED"
    )  | .detail.taskArn')
    
if [[ -z $taskArnRunning && -z  $taskArnStopped ]]; then
    echo "[INFO] skipping this event"
    exit 0
fi

if [ ! -z $taskArnRunning ]; then
    eni=$(aws --region $region ecs describe-tasks --tasks $taskArnRunning --cluster $clusterArn | \
    jq -r '.tasks[0].attachments[0].details[] | select(.name=="networkInterfaceId").value')
    
    publicIp=$(aws --region $region ec2 describe-network-interfaces --network-interface-ids $eni | \
    jq -r '.NetworkInterfaces[0].Association.PublicIp')
    echo "=> [OK] new Amazon ECS task stablized"
    echo "taskArn=$taskArnRunning"
    echo "eni=$eni"
    echo "publicIp=$publicIp"
    echo "new task running - register cloudmap now"
    cm_register_instance 'srv-emzgomv5qbxsqtd4' "${taskArnRunning##*/}" "$publicIp"
elif [ ! -z $taskArnStopped ]; then
    echo "task stopped - deregister cloudmap now"
    cm_deregister_instance 'srv-emzgomv5qbxsqtd4' "${taskArnStopped##*/}"
fi

exit 0
