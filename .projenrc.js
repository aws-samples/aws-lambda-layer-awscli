const { AwsCdkTypeScriptApp, DependenciesUpgradeMechanism } = require('projen');

const AUTOMATION_TOKEN = 'PROJEN_GITHUB_TOKEN';

const project = new AwsCdkTypeScriptApp({
  cdkVersion: '1.77.0',
  name: 'aws-lambda-layer-awscli',
  authorName: 'Pahud Hsieh',
  authorEmail: 'hunhsieh@amazon.com',
  repository: 'https://github.com/aws-samples/aws-lambda-layer-awscli.git',
  depsUpgrade: DependenciesUpgradeMechanism.githubWorkflow({
    workflowOptions: {
      labels: ['auto-approve', 'auto-merge'],
      secret: AUTOMATION_TOKEN,
    },
  }),
  autoApproveOptions: {
    secret: 'GITHUB_TOKEN',
    allowedUsernames: ['pahud'],
  },
  antitamper: false,
  cdkDependencies: [
    '@aws-cdk/core',
    '@aws-cdk/aws-lambda',
    '@aws-cdk/aws-sam',
  ],
  defaultReleaseBranch: 'main',
});


const common_exclude = [
  'cdk.out',
  'cdk.context.json',
  'LICENSE',
  'images',
  'yarn-error.log',
  'sam-layer-packaged.yaml',
  'sam-sar-packaged.yaml',
  'packaged.yaml',
  'layer.zip',
  'coverage',
  'AWSCLI_VERSION*',
];
project.npmignore.exclude(...common_exclude);
project.gitignore.exclude(...common_exclude);

project.synth();
