import cdk = require('@aws-cdk/core');
import sam = require('@aws-cdk/aws-sam');
import lambda = require('@aws-cdk/aws-lambda');

const AWSCLI_LAYER_APP_ARN = 'arn:aws:serverlessrepo:us-east-1:903779448426:applications/lambda-layer-awscli';
const AWSCLI_VERSION = '1.16.213';
    
/**
 * An AWS Lambda layer and sample function that includes the AWS CLI.
 *
 * @see https://github.com/aws-samples/aws-lambda-layer-awscli
 */
export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const resource = new sam.CfnApplication(this, 'awscliLayer', {
      location: {
        applicationId: AWSCLI_LAYER_APP_ARN,
        semanticVersion: AWSCLI_VERSION  
      }
    })

    const layerVersionArn = resource.getAtt('Outputs.LayerVersionArn').toString()

    const func = new lambda.Function(this, 'AwsVersionFunc', {
      code: new lambda.AssetCode('../func.d'),
      handler: 'main',
      runtime: lambda.Runtime.PROVIDED,
      memorySize: 512,
    })

    func.addLayers( 
      lambda.LayerVersion.fromLayerVersionArn(this, 'LayerVersion', layerVersionArn)
    )   

    new cdk.CfnOutput(this, 'LayerVersionArn', {
      value: layerVersionArn,
    }) 

    new cdk.CfnOutput(this, 'FuncArn', {
      value: func.functionArn,
    }) 
  }
}


  