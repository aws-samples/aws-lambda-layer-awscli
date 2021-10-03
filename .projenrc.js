const { AwsCdkTypeScriptApp, DevEnvironmentDockerImage, Gitpod } = require('projen');

const AUTOMATION_TOKEN = 'PROJEN_GITHUB_TOKEN';

const project = new AwsCdkTypeScriptApp({
  cdkVersion: '1.95.2',
  defaultReleaseBranch: 'main',
  name: 'aws-lambda-layer-awscli',
  authorName: 'Pahud Hsieh',
  authorEmail: 'hunhsieh@amazon.com',
  repository: 'https://github.com/aws-samples/aws-lambda-layer-awscli.git',
  cdkDependencies: [
    '@aws-cdk/lambda-layer-awscli',
    '@aws-cdk/aws-lambda',
  ],
  depsUpgradeOptions: {
    ignoreProjen: false,
    workflowOptions: {
      labels: ['auto-approve', 'auto-merge'],
      secret: AUTOMATION_TOKEN,
    },
  },
  autoApproveOptions: {
    secret: 'GITHUB_TOKEN',
    allowedUsernames: ['pahud'],
  },
});

const common_exclude = [
  'cdk.out',
  'cdk.context.json',
  'LICENSE',
  'images',
  'yarn-error.log',
  'packaged.yaml',
  'layer.zip',
  'coverage',
];

project.package.addField('resolutions', {
  'pac-resolver': '^5.0.0',
  'set-value': '^4.0.1',
  'ansi-regex': '^5.0.1',
});


const gitpodPrebuild = project.addTask('gitpod:prebuild', {
  description: 'Prebuild setup for Gitpod',
});
// install and compile only, do not test or package.
gitpodPrebuild.exec('yarn install --frozen-lockfile --check-files');
gitpodPrebuild.exec('npx projen compile');

let gitpod = new Gitpod(project, {
  dockerImage: DevEnvironmentDockerImage.fromImage('public.ecr.aws/pahudnet/gitpod-workspace:latest'),
  prebuilds: {
    addCheck: true,
    addBadge: true,
    addLabel: true,
    branches: true,
    pullRequests: true,
    pullRequestsFromForks: true,
  },
});

gitpod.addCustomTask({
  init: 'yarn gitpod:prebuild',
  // always upgrade after init
  command: 'npx projen upgrade',
});

gitpod.addVscodeExtensions(
  'dbaeumer.vscode-eslint',
  'ms-azuretools.vscode-docker',
  'AmazonWebServices.aws-toolkit-vscode',
);


project.npmignore.exclude(...common_exclude);
project.gitignore.exclude(...common_exclude);

project.synth();
