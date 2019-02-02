#!/bin/bash

export PATH=$PATH:/opt/awscli


cal(){
    aws ce get-cost-and-usage --granularity MONTHLY --time-period Start=2019-02-01,End=2019-02-28 --metrics AmortizedCost \
    --query 'ResultsByTime[0].Total.AmortizedCost.Amount' --output text
}

result=$(cal)

# echo the http response for API Gateway proxy integration
cat << EOF
{"body": "$result", "headers": {"content-type": "text/plain"}, "statusCode": 200}
EOF
