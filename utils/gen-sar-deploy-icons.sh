#!/bin/bash
# https://deploy.serverlessrepo.app/ap-northeast-1/?app=arn:aws:serverlessrepo:us-east-1:903779448426:applications/amazon-connect-outbound-prompt-call


appId=${1-arn:aws:serverlessrepo:us-east-1:903779448426:applications/amazon-connect-outbound-prompt-call}

global_regions=($(aws ec2 describe-regions --query "Regions[*].RegionName" --output text))
sorted_regions=($(printf '%s\n' "${global_regions[@]}"|sort))
echo ${sorted_regions[@]}

generate(){
    # generate region repo
    echo "|  **$1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=$1#/create/app?applicationId=$2)|"
}


cat << EOF
|        Region        |                    Click and Deploy                     | 
| :----------------: | :----------------------------------------------------------: | 
EOF

for r in  ${sorted_regions[@]}
do
    generate $r $appId
done


