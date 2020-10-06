import * as lambda from '@aws-cdk/aws-lambda';
import * as sam from '@aws-cdk/aws-sam';
import * as cdk from '@aws-cdk/core';


const AWSCLI_LAYER_APP_ARN = 'arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli';
const AWSCLI_VERSION = '1.18.142';


export class MyStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props: cdk.StackProps = {}) {
    super(scope, id, props);


    const resource = new sam.CfnApplication(this, 'awscliLayer', {
      location: {
        applicationId: AWSCLI_LAYER_APP_ARN,
        semanticVersion: AWSCLI_VERSION,
      },
    });

    const layerVersionArn = resource.getAtt('Outputs.LayerVersionArn').toString();

    const func = new lambda.Function(this, 'AwsVersionFunc', {
      code: new lambda.AssetCode('./samples/aws-version/func.d'),
      handler: 'main',
      runtime: lambda.Runtime.PROVIDED,
      memorySize: 512,
    });

    func.addLayers(
      lambda.LayerVersion.fromLayerVersionArn(this, 'LayerVersion', layerVersionArn),
    );

    new cdk.CfnOutput(this, 'LayerVersionArn', {
      value: layerVersionArn,
    });

    new cdk.CfnOutput(this, 'FuncArn', {
      value: func.functionArn,
    });

  }
}

// for development, use account/region from cdk cli
const devEnv = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();

new MyStack(app, 'my-stack-dev', { env: devEnv });
// new MyStack(app, 'my-stack-prod', { env: prodEnv });

app.synth();
