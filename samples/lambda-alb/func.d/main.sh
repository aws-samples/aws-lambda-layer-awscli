#!/bin/bash

export PATH=$PATH:/opt/awscli

event_json_dump=$(echo "$1" | jq '.|@json')


# echo the http response for API Gateway proxy integration
cat << EOF
{"body": ${event_json_dump}, "headers": {"content-type": "application/json"}, "statusCode": 200}
EOF