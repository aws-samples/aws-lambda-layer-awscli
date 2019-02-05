#!/bin/bash

export PATH=$PATH:/opt/awscli

CLUSTER_URL='https://s3-us-west-2.amazonaws.com/pahud-cfn-us-west-2/eks-templates/cloudformation/cluster.yaml'
CLUSTER_STACK_NAME='eksdemo-cluster-stack'
CLUSTER_NAME='eksdemo'
# we got AWS_ACCOUNT_ID from bootstrap env var export
CLUSTER_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/eksServiceRole"


createCluster(){
    aws cloudformation create-stack --template-url $CLUSTER_URL  \
	--stack-name  ${CLUSTER_STACK_NAME} \
	--parameters \
	ParameterKey=VpcId,ParameterValue=vpc-e549a281 \
	ParameterKey=SecurityGroupIds,ParameterValue=sg-064d7e7c3fd058fc0 \
	ParameterKey=ClusterName,ParameterValue=${CLUSTER_NAME} \
	ParameterKey=ClusterRoleArn,ParameterValue=${CLUSTER_ROLE_ARN} \
	ParameterKey=SubnetIds,ParameterValue=subnet-05b643f57a6997deb\\,subnet-09e79eb1dec82b7e2\\,subnet-0c365d97cbc75ceec
}

createCluster 2>&1 > /dev/null

if [ $? -eq 0 ]; then
    result="EKS集群創建中，請稍後..."
else
    result="執行失敗"
fi

# echo the http response for API Gateway proxy integration
cat << EOF
{"body": "$result", "headers": {"content-type": "text/plain"}, "statusCode": 200}
EOF

exit 0