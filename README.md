# lambda-layer-awscli
`lambda-layer-awscli` is a AWS Lambda Layer for AWS CLI


# Layer ARN
`arn:aws:lambda:ap-northeast-1:903779448426:layer:awscli-layer:14`

# create lambda func with awscli layer
```
$ LAMBDA_LAYERS=arn:aws:lambda:ap-northeast-1:903779448426:layer:awscli-layer:14 make create-func 
```

# invoke function

```
$ make invoke
START RequestId: 50aaed4a-0ba1-11e9-9383-7d95168f3155 Version: $LATEST
=========[RESPONSE]=======
aws-cli/1.16.81 Python/2.7.12 Linux/4.14.77-70.59.amzn1.x86_64 botocore/1.12.71
{
    "Account": "903779448426", 
    "UserId": "AROAJFR4LL2ABRRXEKOUC:awscli-layer-test-func", 
    "Arn": "arn:aws:sts::903779448426:assumed-role/EKSLambdaDrainer/awscli-layer-test-func"
}
=========[/RESPONSE]=======
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   286  100    16  100   270    400   6762 --:--:-- --:--:-- --:--:--  6923
{"status":"OK"}
END RequestId: 50aaed4a-0ba1-11e9-9383-7d95168f3155
REPORT RequestId: 50aaed4a-0ba1-11e9-9383-7d95168f3155  Init Duration: 9.27 ms  Duration: 12219.37 ms Billed Duration: 12300 ms       Memory Size: 128 MB     Max Memory Used: 57 MB
```
