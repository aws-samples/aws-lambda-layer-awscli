#!/bin/bash
# set -euo pipefail

export PATH=$PATH:/opt/awscli
echo $1

new_cidrs=($(curl -s https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r ".prefixes[]| select(.service == \"$SERVICE_NAME\").ip_prefix"))
existing_cidrs=($(aws --region ${REGION} ec2 describe-security-groups --group-ids ${GROUP_ID} --query 'SecurityGroups[0].IpPermissions[0].IpRanges[*].CidrIp' --output text))

echo "====[ new CIDRs ] ==="
echo ${new_cidrs[@]}
echo "====[ end new CIDRs ] ==="

add_ingress(){
  aws --region ${REGION} ec2 authorize-security-group-ingress --group-id ${GROUP_ID} --protocol tcp --port 22 --cidr $1
}

revoke(){
    aws --region ${REGION} ec2 revoke-security-group-ingress --group-id ${GROUP_ID}   --port 22 --protocol tcp --cidr $1
}

echo "====[ existing CIDRs ] ==="
echo ${existing_cidrs[@]}
echo "====[ end existing CIDRs ] ==="






empty_sg(){
  for e in ${existing_cidrs[@]}
  do
    revoke $e
  done
}

tidy_up_sg(){
    # we revoke old cidrs that are not in new ip range anymore
    if [[ "${existing_cidrs[0]}" != 'None' ]]; then
        # revoke the cidr if not in new range
        for e in  ${existing_cidrs[@]}
        do
            echo "processing $e"
            [[ " ${new_cidrs[@]} " =~ " $e " ]] && echo "[OK] ${e} is still in the range" || \
            ( echo "[WARNING] $e not in new cidr anymore, revoking $e"; revoke $e )
        done
    else
        echo "[INFO] SG is empty"
    fi
}

add_new_cidr_to_sg(){
  for n in ${new_cidrs[@]}
  do  
    echo "processing $n"
    [[ " ${existing_cidrs[@]} " =~ " $n " ]] && echo "[OK] ${n} is already in existing cidrs" || \
    ( echo "[WARNING] $n not in existing cidrs, add into SG now"; add_ingress $n)
  done
}


#
# Your business logic starts here
#
StackId=$(echo $1 | jq -r '.StackId | select(type == "string")')
ResponseURL=$(echo $1 | jq -r '.ResponseURL | select(type == "string")')
NodeInstanceRole=$(echo $1 | jq -r '.ResourceProperties.NodeInstanceRole | select(type == "string")')
RequestType=$(echo $1 | jq -r '.RequestType | select(type == "string")')
RequestId=$(echo $1 | jq -r '.RequestId | select(type == "string")')
ServiceToken=$(echo $1 | jq -r '.ServiceToken | select(type == "string")')
LogicalResourceId=$(echo $1 | jq -r '.LogicalResourceId | select(type == "string")')

sendResponseCurl(){
  # Usage: sendRespose body_file_name url
  curl -s -XPUT \
  -H "Content-Type: " \
  -d @$1 $2
}

sendResponseSuccess(){
  cat << EOF > /tmp/sendResponse.body.json
{
    "Status": "SUCCESS",
    "Reason": "",
    "PhysicalResourceId": "${RequestId}",
    "StackId": "${StackId}",
    "RequestId": "${RequestId}",
    "LogicalResourceId": "${LogicalResourceId}",
    "Data": {
        "Result": "OK"
    }
}
EOF
  if [[ -n ${ResponseURL} ]]; then
    echo "=> sending cfn custom resource callback"
    sendResponseCurl /tmp/sendResponse.body.json $ResponseURL
  fi
}

sendResponseFailed(){
  cat << EOF > /tmp/sendResponse.body.json
{
    "Status": "FAILED",
    "Reason": "",
    "PhysicalResourceId": "${RequestId}",
    "StackId": "${StackId}",
    "RequestId": "${RequestId}",
    "LogicalResourceId": "${LogicalResourceId}",
    "Data": {
        "Result": "OK"
    }
}
EOF

  if [[ -n ${ResponseURL} ]]; then
    echo "=> sending callback to $ResponseURL"
    sendResponseCurl /tmp/sendResponse.body.json $ResponseURL
  fi
}


case $RequestType in 
  "Create")
    echo "[INFO] start update sg"
    add_new_cidr_to_sg
    tidy_up_sg
    echo "[INFO] sending response success"
    sendResponseSuccess
  ;;
  "Delete")
    echo "[INFO] astart empty sg"
    empty_sg
    echo "[INFO] asending response success"
    sendResponseSuccess
  ;;
  "Update")
    echo "[INFO] start update sg"
    add_new_cidr_to_sg
    tidy_up_sg
    echo "[INFO] asending response success"
    sendResponseSuccess
  ;;
  *)
    echo "[INFO] start update sg"
    add_new_cidr_to_sg
    tidy_up_sg
    echo "[INFO] asending response success"
    sendResponseSuccess
  ;;
esac

