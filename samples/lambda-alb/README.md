# lambda-alb-sample

This sample creates an ALB with Lambda as target group.

# HOWTO

1. update `Makefile` and `sam.yaml`
2. deploy it
```bash
# SAM package and SAM deploy the stack
$ make sam-package sam-deploy
```
response:
```bash
[
    {
        "Description": "Test URL", 
        "OutputKey": "TestURL", 
        "OutputValue": "http://demo-lambda-alb-425419861.ap-northeast-1.elb.amazonaws.com/"
    }, 
    {
        "Description": "ALB DNS NAME", 
        "OutputKey": "AlbDnsName", 
        "OutputValue": "demo-lambda-alb-425419861.ap-northeast-1.elb.amazonaws.com"
    }, 
    {
        "Description": "Lambda Function Arn", 
        "OutputKey": "LambdaFuncArn", 
        "OutputValue": "arn:aws:lambda:ap-northeast-1:xxxxxxxxx:function:lambda-alb-sample-stack-SampleFunction-EGE7ZIAABOBL"
    }
]
```
3. `cURL` the `Test URL` with additional request uri `path` and `arguments`:
```bash
$ curl -s "http://demo-lambda-alb-425419861.ap-northeast-1.elb.amazonaws.com/demo?foo=bar" | jq .   
{
  "requestContext": {
    "elb": {
      "targetGroupArn": "arn:aws:elasticloadbalancing:ap-northeast-1:xxxxxxxxx:targetgroup/demo-public-trg/06906f4f9a8e5661"
    }
  },
  "httpMethod": "GET",
  "path": "/demo",
  "queryStringParameters": {
    "foo": "bar"
  },
  "headers": {
    "accept": "*/*",
    "host": "demo-lambda-alb-425419861.ap-northeast-1.elb.amazonaws.com",
    "user-agent": "curl/7.61.1",
    "x-amzn-trace-id": "Root=1-5ce17f99-836049e3e9f57b3b85a34375",
    "x-forwarded-for": "13.231.166.126",
    "x-forwarded-port": "80",
    "x-forwarded-proto": "http"
  },
  "body": "",
  "isBase64Encoded": false
}
```
