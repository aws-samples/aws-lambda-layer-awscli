#!/bin/bash

export PATH=$PATH:/opt/awscli


first_date_this_month=$(date +%Y-%m-01)
last_date_this_month=$(date -d "$(date -d 'next month' +%Y-%m-01) -1 day" +%Y-%m-%d)
yesterday=$(date -d 'yesterday' +%Y-%m-%d)
tomorrow=$(date -d 'tomorrow' +%Y-%m-%d)

today=$(date +%Y-%m-%d)


mtd(){
    aws ce get-cost-and-usage --granularity MONTHLY --time-period Start=${first_date_this_month},End=${last_date_this_month} --metrics AmortizedCost \
    --query 'ResultsByTime[0].Total.AmortizedCost.Amount' --output text
}

mtd2(){
    aws ce get-cost-forecast --granularity MONTHLY --time-period Start=${tomorrow},End=${last_date_this_month} --metric AMORTIZED_COST \
    --query 'Total.Amount' --output text
}

yesterday_cost(){
    aws ce get-cost-and-usage --granularity MONTHLY --time-period Start=${yesterday},End=${today} --metrics AmortizedCost \
    --query 'ResultsByTime[0].Total.AmortizedCost.Amount' --output text
}

mtd=$(mtd)
ycost=$(yesterday_cost)
fcst=$(echo "$(mtd2) + ${ycost}" | bc)


result="本月到目前 $(printf "%.2f" $mtd) , 本月到月底預估 $(printf "%.2f" $fcst)"

# echo the http response for API Gateway proxy integration
cat << EOF
{"body": "$result", "headers": {"content-type": "text/plain"}, "statusCode": 200}
EOF
