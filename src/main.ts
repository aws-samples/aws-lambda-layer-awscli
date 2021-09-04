import { App, CfnOutput, Construct, Stack, StackProps } from '@aws-cdk/core';
import * as layer from '@aws-cdk/lambda-layer-awscli';
import * as customlayer from './custom-layer/custom-layer';

export class LayerStack extends Stack {
  constructor(scope: Construct, id: string, props: StackProps = {}) {
    super(scope, id, props);

    const awscliLayer = new layer.AwsCliLayer(this, 'AwsCliLayer');
    new CfnOutput(this, 'LayerVersionArn', { value: awscliLayer.layerVersionArn });

  }
}

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

new LayerStack(app, 'awscli-layer-stack', { env: devEnv });
new CustomLayerStack(app, 'custom-awscli-layer-stack', { env: devEnv });

app.synth();
