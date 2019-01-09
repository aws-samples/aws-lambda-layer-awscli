# lambda-layer-awscli
`lambda-layer-awscli` is a AWS Lambda Layer for AWS CLI

# Features
- [x] build your own `awscli` layer from scratch with the latest version of `awscli`
- [x] ships with `jq` and potential other useful utilities
- [x] easy to build, ship and invoke your lambda function

# Layer structure

Layer will be installed into `/opt/awscli` in your lambda runtime with the structure tree as below:

```
└── awscli
    ├── aws
    ├── awscli
    ├── awscli-1.16.85-py2.7.egg-info
    ├── bin
    ├── botocore
    ├── botocore-1.12.75-py2.7.egg-info
    ├── colorama
    ├── colorama-0.3.9-py2.7.egg-info
    ├── concurrent
    ├── dateutil
    ├── docutils
    ├── docutils-0.14-py2.7.egg-info
    ├── easy_install.py
    ├── easy_install.pyc
    ├── futures-3.2.0-py2.7.egg-info
    ├── jmespath
    ├── jmespath-0.9.3-py2.7.egg-info
    ├── jq
    ├── pkg_resources
    ├── pyasn1
    ├── pyasn1-0.4.5-py2.7.egg-info
    ├── python_dateutil-2.7.5-py2.7.egg-info
    ├── PyYAML-3.13-py2.7.egg-info
    ├── rsa
    ├── rsa-3.4.2-py2.7.egg-info
    ├── s3transfer
    ├── s3transfer-0.1.13-py2.7.egg-info
    ├── site-packages
    ├── six-1.12.0-py2.7.egg-info
    ├── six.py
    ├── six.pyc
    ├── urllib3
    ├── urllib3-1.24.1-py2.7.egg-info
    ├── wheel
    ├── wheel-0.29.0.dist-info
    └── yaml

31 directories, 6 files
```


# Layer ARN
`arn:aws:lambda:ap-northeast-1:903779448426:layer:awscli-layer:15`

# create your own awscli layer from scratch


edit the `Makefile`

| Name                 | Description                                                  | required to update |
| -------------------- | ------------------------------------------------------------ | ------------------ |
| **LAYER_NAME**       | Layer Name                                                   |                    |
| **LAYER_DESC**       | Layer Description                                            |                    |
| **INPUT_JSON**       | input json payload file for lambda invocation                |                    |
| **S3BUCKET**         | Your S3 bucket to store the intermediate Lambda bundle zip.<br />Make sure the S3 bucket in the same region with your Lambda function to deploy. | YES                |
| **LAMBDA_REGION**    | The region code to deploy your Lambda function               | Optional           |
| **LAMBDA_FUNC_NAME** | Lambda function name                                         |                    |
| **LAMBDA_ROLE_ARN**  | Lambda IAM role ARN                                          | Optional(for function only)            |


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



# create lambda func with your awscli layer
```
$ LAMBDA_LAYERS=LAMBDA_LAYER_VERSION_ARN make create-func 
```
* specify the `LayerVersionArn` you just published above.


# invoke function

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
