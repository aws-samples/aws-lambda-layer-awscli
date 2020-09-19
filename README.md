![](https://travis-ci.org/aws-samples/aws-lambda-layer-awscli.svg?branch=master)
[![](https://img.shields.io/badge/Available-serverless%20app%20repository-blue.svg)](https://serverlessrepo.aws.amazon.com/#/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-awscli)
![](https://codebuild.ap-northeast-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiMnZzMmFZZ1U2OTk1WmxZWUJWVW9QaWJxR3Zxd09PU2hoYmJCUlh4eWpLLzJlNUUrNFhVZnEvbGhxa0N0ZlAvN0FVRHE0amsrK3U2ZEFxblVFZ2o4akZRPSIsIml2UGFyYW1ldGVyU3BlYyI6Im5CblF1UFJyWkhha2x3cHMiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# lambda-layer-awscli


`lambda-layer-awscli` is a AWS Lambda Layer for AWS CLI

# Features
- [x] build your own `awscli` layer from scratch or simply from SAR(Serverless App Repository) with the latest version of `awscli` 
- [x] ships `jq` that helps you parse the JSON payload
- [x] ships `make` command
- [x] easy to build, ship and invoke your lambda function
- [x] support deployment to China Beijing and Ningxia regions

# Layer structure

Layer will be installed into `/opt/awscli` in your lambda sandbox with the structure tree as below:

```
/opt/awscli/
    .
    ├── PyYAML-5.3.1-py2.7.egg-info
    ├── aws
    ├── awscli
    ├── awscli-1.18.74-py2.7.egg-info
    ├── bin
    ├── botocore
    ├── botocore-1.16.24-py2.7.egg-info
    ├── colorama
    ├── colorama-0.4.3-py2.7.egg-info
    ├── concurrent
    ├── dateutil
    ├── docutils
    ├── docutils-0.15.2-py2.7.egg-info
    ├── easy_install.py
    ├── easy_install.pyc
    ├── futures-3.3.0-py2.7.egg-info
    ├── jmespath
    ├── jmespath-0.10.0-py2.7.egg-info
    ├── jq
    ├── make
    ├── pkg_resources
    ├── pyasn1
    ├── pyasn1-0.4.8-py2.7.egg-info
    ├── python_dateutil-2.8.0.dist-info
    ├── rsa
    ├── rsa-3.4.2-py2.7.egg-info
    ├── s3transfer
    ├── s3transfer-0.3.3-py2.7.egg-info
    ├── six-1.15.0-py2.7.egg-info
    ├── six.py
    ├── six.pyc
    ├── urllib3
    ├── urllib3-1.25.9-py2.7.egg-info
    ├── wheel
    ├── wheel-0.33.6-py2.7.egg-info
    └── yaml


29 directories, 7 files
```


# create your own awscli layer

You have many options to create and deploy your awscli lambda layer. 


## OPTION #1 Deploy with AWS CDK from SAR(Serverless Application Repository)

Check the [aws-version sample](samples/aws-version).


## OPTION #2 Deploy from SAR from console or CLI

You may deploy from the SAR console or from the CLI.

### Deploy from SAR console

|        Region        |                    Click and Deploy                     | 
| :----------------: | :----------------------------------------------------------: | 
|  **ap-northeast-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ap-northeast-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **ap-northeast-2**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ap-northeast-2#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **ap-northeast-3**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ap-northeast-3#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **ap-south-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ap-south-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **ap-southeast-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ap-southeast-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **ap-southeast-2**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ap-southeast-2#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **ca-central-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=ca-central-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **eu-central-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=eu-central-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **eu-north-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=eu-north-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **eu-west-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=eu-west-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **eu-west-2**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=eu-west-2#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **eu-west-3**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=eu-west-3#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **sa-east-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=sa-east-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **us-east-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=us-east-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **us-east-2**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=us-east-2#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **us-west-1**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=us-west-1#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|
|  **us-west-2**  |[![](https://img.shields.io/badge/SAR-Deploy%20Now-yellow.svg)](https://console.aws.amazon.com/lambda/home?region=us-west-2#/create/app?applicationId=arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli)|

### Deploy from CLI


```
$ aws --region us-east-1 serverlessrepo create-cloud-formation-template --application-id arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli
{
    "Status": "PREPARING", 
    "TemplateId": "89be5908-520b-4911-bde7-71bf73040e47", 
    "CreationTime": "2019-02-20T14:51:56.826Z", 
    "SemanticVersion": "1.0.0", 
    "ExpirationTime": "2019-02-20T20:51:56.826Z", 
    "ApplicationId": "arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli", 
    "TemplateUrl": ""
}
```
please note your current IAM identity will need relevant `serverlessrepo` IAM policies. If you encounter `AccessDeniedException` error, you may attach an extra IAM inline policy like this in your current 
IAM identity.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "sar-allow-all",
            "Effect": "Allow",
            "Action": "serverlessrepo:*",
            "Resource": "*"
        }
    ]
}
```


Copy the `TemplateUrl` value and deploy with `cloudformation create-stack`


```
aws --region us-east-1 cloudformation create-stack --template-url {TemplateUrl} --stack-name {StackName} --capabilities CAPABILITY_AUTO_EXPAND
```
On stack create complete, get the stack outputs as below

```
$ aws --region us-east-1 cloudformation describe-stacks --stack-name {StackName} --query 'Stacks[0].Outputs'
[
    {
        "Description": "ARN for the published Layer version", 
        "ExportName": "LayerVersionArn-{StackName}", 
        "OutputKey": "LayerVersionArn", 
        "OutputValue": "arn:aws:lambda:us-east-1:123456789012:layer:layer-{StackName}:1"
    }
]
```

Now you got your own Lambda Layer Arn.



## OPTION #3 create Layer from scratch

You may also create your own awscli layer from scratch.

Before that, you must edit the `Makefile` fist.

| Name                 | Description                                                  | required to update          |
| -------------------- | ------------------------------------------------------------ | --------------------------- |
| **LAYER_NAME**       | Layer Name                                                   |                             |
| **LAYER_DESC**       | Layer Description                                            |                             |
| **INPUT_JSON**       | input json payload file for lambda invocation                |                             |
| **S3BUCKET**         | Your S3 bucket to store the intermediate Lambda bundle zip.<br />Make sure the S3 bucket in the same region with your Lambda function to deploy. | YES                         |
| **LAMBDA_REGION**    | The region code to deploy your Lambda function               | Optional                    |
| **LAMBDA_FUNC_NAME** | Lambda function name                                         |                             |
| **LAMBDA_ROLE_ARN**  | Lambda IAM role ARN                                          | Optional(for function only) |

```
$ make build layer-zip layer-upload layer-publish
```

response:

```
{
    "LayerVersionArn": "arn:aws:lambda:ap-northeast-1:YOUR_AWS_ACCOUNT_ID:layer:awscli-layer:1", 
    "Description": "awscli-layer", 
    "CreatedDate": "2019-01-09T02:22:52.425+0000", 
    "LayerArn": "arn:aws:lambda:ap-northeast-1:YOUR_AWS_ACCOUNT_ID:layer:awscli-layer2", 
    "Content": {
        "CodeSize": 11356080, 
        "CodeSha256": "fAXh9KfM0H9oAaFmzY0xuX4AXZISbMUiV0xnfFvQrnI=", 
        "Location": "https://...."
    }, 
    "Version": 2, 
    "CompatibleRuntimes": [
        "provided"
    ], 
    "LicenseInfo": "MIT"
}
```


## OPTION #4 create Layer with SAM CLI

Or alternatively, create your Layer with SAM CLI as below:

```
# build the layer from scratch 
$ make layer-build 

# package and deploy the layer with `SAM` CLI 
$ make sam-layer-package sam-layer-deploy 

# destroy the layer 
$ make sam-layer-destroy
```


### create lambda func with your awscli layer

OK. Now you have your own awscli layer deployed and you got the layer ARN. 
Create your function with this layer as below:


```
$ LAMBDA_LAYERS=LAMBDA_LAYER_VERSION_ARN make create-func 
```
* specify the `LayerVersionArn` you just published above.

You may also create your lambda function and API Gateway along with other resoruces with `SAM`, check the sample `sam.yaml` and `Makefile` in [this folder](./samples/launch-ec2-instance/).

### invoke function

this will execute `main.sh` in the lambda function zip bundle. Check the [sample](./main.sh).

```
$ make invoke
```

response:

```
START RequestId: 3a3f0718-13b8-11e9-9d26-8f14b26be384 Version: $LATEST
=========[RESPONSE]=======
aws-cli/1.16.85 Python/2.7.12 Linux/4.14.88-72.73.amzn1.x86_64 botocore/1.12.75
=========[/RESPONSE]=======
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    95  100    16  100    79   1145   5653 --:--:-- --:--:-- --:--:--  6076
{"status":"OK"}
END RequestId: 3a3f0718-13b8-11e9-9d26-8f14b26be384
REPORT RequestId: 3a3f0718-13b8-11e9-9d26-8f14b26be384  Duration: 1059.15 ms    Billed Duration: 1100 ms        Memory Size: 512 MBMax Memory Used: 69 MB
```



# local testing

edit your `main.sh` as below:

```
#!/bin/bash

PATH=$PATH:/opt/awscli

echo "---[payload]---"
stdin=$(test -s /dev/stdin && cat -)

if [ "${stdin}X" != "X" ]; then
    # got stdin
    payload="$stdin"
else
    payload="$1"
fi

echo $payload

instanceId=$(echo $payload | jq -r .instanceId)
echo "---[/payload]---"
echo "instanceId=$instanceId"

# your business logic here to handle $instanceId
#aws --version 2>&1

exit 0

```

# test from local 

You can pass the payload as the shell argument

```
$ bash main.sh '{"instanceId":"i-12345"}'
---[payload]---
{"instanceId":"i-12345"}
---[/payload]---
instanceId=i-12345
```
or through the pipeline
```
 $ echo '{"instanceId":"i-12345"}' | bash main.sh
---[payload]---
{"instanceId":"i-12345"}
---[/payload]---
instanceId=i-12345
```

OK update function and invoke with this payload
```
$ PAYLOAD='{"instanceId":"i-12345"}' make update-func invoke
{
    "Layers": [
        {
            "CodeSize": 11418917,
            "Arn": "arn:aws-cn:lambda:cn-northwest-1:xxxxxxxx:layer:awscli-layer:5"
        }
    ],
    "CodeSha256": "BgNz/g85/JEuie/cYqQfjp6jfK1sbyFeRGjBfcS/xdY=",
    "FunctionName": "awscli-layer-test-func",
    "CodeSize": 1002,
    "RevisionId": "0631c90b-836c-469c-8001-257ac3d0ba7b",
    "MemorySize": 512,
    "FunctionArn": "arn:aws-cn:lambda:cn-northwest-1:xxxxxxxx:function:awscli-layer-test-func",
    "Version": "$LATEST",
    "Role": "arn:aws-cn:iam::xxxxxxxx:role/service-role/myLambdaRole",
    "Timeout": 30,
    "LastModified": "2019-01-28T19:54:03.802+0000",
    "Handler": "main",
    "Runtime": "provided",
    "Description": "awscli-layer-test-func"
}
START RequestId: 22ab1fe1-5edd-48af-9d7d-324a2d02efa6 Version: $LATEST
=========[RESPONSE]=======
---[payload]---
{"instanceId":"i-12345"}
---[/payload]---
instanceId=i-12345
=========[/RESPONSE]=======
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    92  100    16  100    76    878   4174 --:--:-- --:--:-- --:--:--  4222
{"status":"OK"}
END RequestId: 22ab1fe1-5edd-48af-9d7d-324a2d02efa6
REPORT RequestId: 22ab1fe1-5edd-48af-9d7d-324a2d02efa6  Duration: 187.60 ms     Billed Duration: 200 ms         Memory Size: 512 MB     Max Memory Used: 18 MB
9801a7a9620b:lambda-layer-awscli hunhsieh $
```
You can develop and test your lambda function locally in this way.



## Node10 and Node12 AWS Lambda runtime support

To support node10 and node12 lambda runtime, at this moment, you need build this layer from scratch with python2.7 support(will support python3 in the future).

```bash
# build the layer.zip with python2.7 support for node10 and node12 runtime
$ make layer-build-python27  # this will generate layer.zip in current directory
# build and deploy your cusotm layer
$ S3BUCKET={YOUR_STAGING_BUCKET_NAME} LAMBDA_REGION={REGION_CODE_TO_DEPLOY} make sam-layer-package sam-layer-deploy
```

Response

```bash
[
    {
        "OutputKey": "LayerVersionArn",
        "OutputValue": "arn:aws:lambda:ap-northeast-1:112233445566:layer:awscli-layer-stack:1",
        "Description": "ARN for the published Layer version",
        "ExportName": "LayerVersionArn-awscli-layer-stack"
    }
]
[OK] Layer version deployed.
```

Now your layer has been deployed with a new version.

Create a Lambda function with `Node.js 12.x` runtime with memory no less than 256MB and timeout no less than 10 sec. And specify the following environment variables



| Name            | Value                                                        |
| --------------- | ------------------------------------------------------------ |
| LD_LIBRARY_PATH | /opt/awscli/lib                                              |
| PYTHONHOME      | /opt/awscli/lib/python2.7                                    |
| PYTHONPATH      | /opt/awscli/lib/python2.7:/opt/awscli/lib/python2.7/lib-dynload |

Compose your sample NodeJS Lambda function 

```js
const shell = require('child_process').execSync

exports.handler = () => {
    const version = shell('/opt/awscli/aws --version')
    console.log(version)
}
```

Test it and you will see the response of `aws --version` as below

```
START RequestId: 08483127-5388-40b4-90c7-a2b255db9e13 Version: $LATEST
aws-cli/1.16.309 Python/2.7.16 Linux/4.14.138-99.102.amzn2.x86_64 exec-env/AWS_Lambda_nodejs12.x botocore/1.13.45
2020-01-02T15:32:35.625Z	08483127-5388-40b4-90c7-a2b255db9e13	INFO	<Buffer >END RequestId: 08483127-5388-40b4-90c7-a2b255db9e13
REPORT RequestId: 08483127-5388-40b4-90c7-a2b255db9e13	Duration: 3133.77 ms	Billed Duration: 3200 ms	Memory Size: 256 MB	Max Memory Used: 156 MB	

```

(see issue [#5](https://github.com/aws-samples/aws-lambda-layer-awscli/issues/5) for more details)

## License Summary

This sample code is made available under the MIT-0 license. See the LICENSE file.

