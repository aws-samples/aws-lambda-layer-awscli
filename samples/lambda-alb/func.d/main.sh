#!/bin/bash

export PATH=$PATH:/opt/awscli

event=$(echo "$1" | jq '.|@json')

cat << EOF
{"body": ${event}, "headers": {"content-type": "application/json"}, "statusCode": 200}
EOF