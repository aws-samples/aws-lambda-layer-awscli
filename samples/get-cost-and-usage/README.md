# get-cost-and-usage 

_First, check the cool demo video in my 👉 [tweet](https://twitter.com/pahudnet/status/1091556349043924993)!_ 😎

![](https://pbs.twimg.com/media/Dyh20-4V4AAxGhy.jpg:small)

This sample generates API Gateway endpoint and Lambda function with `SAM`.


## HOWTO

execute the shippped `main.sh` and you should be able to see the results like this:

```
$ bash main.sh 
{"body": "本月到目前 155.55 , 本月到月底預估 1231.47", "headers": {"content-type": "text/plain"}, "statusCode": 200}
```
**please note**
1. this script will query your aws cost and usage. You may need to modify the period specified in `main.sh`)
2. the response is a standard response for API Gateway http proxy integration wich containers `statusCode`, `headers` and `body`

**create and publish your AWS CLI layer**
If you have no existing `awscli` lambda layer, create a new one:

```
$ make build layer-zip layer-upload layer-publish
```
You'll get the `arn` of the published layer.

**update `sam.yaml`**

1. specify the layer arn in `Layers` attribute
2. specify correct IAM Role arn in `Role` attribute

**deploy the stack**
```
$ make func-zip sam-package sam-deploy
```
Output
```
chmod +x main.sh
zip -r func-bundle.zip bootstrap main.sh; ls -alh func-bundle.zip
updating: bootstrap (deflated 43%)
updating: main.sh (deflated 26%)
-rw-rw-r-- 1 ec2-user ec2-user 1.1K Feb  2 13:43 func-bundle.zip
Uploading to 5f8ab945aa003a7c964b84c64bcceb21  1078 / 1078.0  (100.00%)
Successfully packaged artifacts and wrote output template to file packaged.yaml.
Execute the following command to deploy the packaged template
aws cloudformation deploy --template-file /home/samcli/workdir/packaged.yaml --stack-name <YOUR STACK NAME>

Waiting for changeset to be created..
Waiting for stack create/update to complete
Successfully created/updated stack - whats-my-spend-stack
# print the cloudformation stack outputs
aws --region ap-northeast-1 cloudformation describe-stacks --stack-name "whats-my-spend-stack" --query 'Stacks[0].Outputs'
[
    {
        "Description": "URL for application", 
        "ExportName": "DemoApiURL-whats-my-spend-stack", 
        "OutputKey": "DemoApiURL", 
        "OutputValue": "https://{API_ID}.execute-api.ap-northeast-1.amazonaws.com/Prod/demo"
    }, 
    {
        "Description": "API Key for the request", 
        "ExportName": "DemoApiApiKey-whats-my-spend-stack", 
        "OutputKey": "ApiKey", 
        "OutputValue": "stgjwzmf0d"
    }
]

```
The `OutputValue` of `DemoApiURL` would be the deployed API URL.

Get the `value` of your API Key. Your API Key ID is the value of `OutputValue` of `OutputKey` above.

```
$ aws  apigateway  get-api-key --api-key stgjwzmf0d --include-value --query 'value' --output text
<YOUR_API_KEY_VALUE>
```


Try it
```
 $ curl -H 'x-api-key:<YOUR_API_KEY_VALUE>' https://{API_ID}.execute-api.ap-northeast-1.amazonaws.com/Prod/demo
本月到目前 155.55 , 本月到月底預估 123
```

You got the response!

## Build your Siri shortcut

construct your HTTP request in Siri shortcut and make sure you specify `x-api-key` in the http request header.

![](https://pbs.twimg.com/media/DyiWd7WU0Acyeyq.jpg:small)

