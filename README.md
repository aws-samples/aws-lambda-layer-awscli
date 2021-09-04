![](https://travis-ci.org/aws-samples/aws-lambda-layer-awscli.svg?branch=master)
[![](https://img.shields.io/badge/Available-serverless%20app%20repository-blue.svg)](https://serverlessrepo.aws.amazon.com/#/applications/arn:aws:serverlessrepo:us-east-1:903779448426:applications~lambda-layer-awscli)
![](https://codebuild.ap-northeast-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiMnZzMmFZZ1U2OTk1WmxZWUJWVW9QaWJxR3Zxd09PU2hoYmJCUlh4eWpLLzJlNUUrNFhVZnEvbGhxa0N0ZlAvN0FVRHE0amsrK3U2ZEFxblVFZ2o4akZRPSIsIml2UGFyYW1ldGVyU3BlYyI6Im5CblF1UFJyWkhha2x3cHMiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# lambda-layer-awscli

AWS CDK(Cloud Development Kit) comes with [lambda-layer-awscli](https://github.com/aws/aws-cdk/tree/master/packages/%40aws-cdk/lambda-layer-awscli) which allows you to build your private AWS Lambda layer with AWS CLI executable. This repository demonstrates how to create your own AWS Lambda layer with AWS CLI in AWS CDK.


## Basic Usage

```ts
import { App, CfnOutput, Construct, Stack, StackProps } from '@aws-cdk/core';
import * as layer from '@aws-cdk/lambda-layer-awscli';

export class MyStack extends Stack {
  constructor(scope: Construct, id: string, props: StackProps = {}) {
    super(scope, id, props);

    const awscliLayer = new layer.AwsCliLayer(this, 'AwsCliLayer');
    new CfnOutput(this, 'LayerVersionArn', { value: awscliLayer.layerVersionArn })

  }
}

const devEnv = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new App();

new MyStack(app, 'awscli-layer-stack', { env: devEnv });

app.synth();
```

After deployment, the AWS Lambda layer version ARN will be returned and you can use this ARN in your Lambda functions in the same AWS region.

```
Outputs:
awscli-layer-stack.LayerVersionArn = arn:aws:lambda:us-east-1:123456789012:layer:AwsCliLayerF44AAF94:34
```

## Customize your layer

The [AwsCliLayer](https://github.com/aws/aws-cdk/blob/6e2a3e0f855221df98f78f6465586d5524f5c7d5/packages/%40aws-cdk/lambda-layer-awscli/lib/awscli-layer.ts#L10-L20) from AWS CDK upstream does not allow you to pass custom Dockerfile(see the [built-in Dockerfile](https://github.com/aws/aws-cdk/blob/master/packages/%40aws-cdk/lambda-layer-awscli/layer/Dockerfile)). To customize the layer, we simply create our own `AwsCliLayer` construct class in our CDK application with our custom `Dockerfile`.

```sh
cd src/custom-layer
# edit and customize the Dockerfile under the `custom-layer` directory
# login ECR public
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
# generate the layer.zip from Dockerfile
bash build.sh
```

Now prepare your custom `AwsCliLayer` construct class and run `cdk deploy` to generate your own layer.


```ts
import { App, CfnOutput, Construct, Stack, StackProps } from '@aws-cdk/core';
import * as layer from '@aws-cdk/lambda-layer-awscli';
import * as customlayer from './custom-layer/custom-layer';

export class CustomLayerStack extends Stack {
  constructor(scope: Construct, id: string, props: StackProps = {}) {
    super(scope, id, props);

    const awscliLayer = new customlayer.AwsCliLayer(this, 'CustomAwsCliLayer');
    new CfnOutput(this, 'LayerVersionArn', { value: awscliLayer.layerVersionArn });
  }
}

// for development, use account/region from cdk cli
const devEnv = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new App();

new CustomLayerStack(app, 'custom-awscli-layer-stack', { env: devEnv });

app.synth();
```

## License Summary

This sample code is made available under the MIT-0 license. See the LICENSE file.
