const {
  AwsCdkTypeScriptApp,
  GithubWorkflow,
} = require('projen');

const AUTOMATION_TOKEN = 'GITHUB_TOKEN';

const project = new AwsCdkTypeScriptApp({
  cdkVersion: "1.63.0",
  name: "aws-lambda-layer-awscli",
  authorName: "Pahud Hsieh",
  authorEmail: "hunhsieh@amazon.com",
  repository: "https://github.com/aws-samples/aws-lambda-layer-awscli.git",
  dependabot: false,
  antitamper: false,
  cdkDependencies: [
    "@aws-cdk/core",
    "@aws-cdk/aws-lambda",
    "@aws-cdk/aws-sam",
  ]
});

// project.addDependencies({
//   "@pahud/aws-codebuild-patterns": Semver.caret('1.1.0'),
// });


// create a custom projen and yarn upgrade workflow
const workflow = new GithubWorkflow(project, 'ProjenYarnUpgrade');

workflow.on({
  schedule: [{
    cron: '0 6 * * *'
  }], // 6am every day
  workflow_dispatch: {}, // allow manual triggering
});

workflow.addJobs({
  upgrade: {
    'runs-on': 'ubuntu-latest',
    'steps': [
      ...project.workflowBootstrapSteps,

      // yarn upgrade
      {
        run: `yarn upgrade`
      },

      // upgrade projen
      {
        run: `yarn projen:upgrade`
      },

      // submit a PR
      {
        name: 'Create Pull Request',
        uses: 'peter-evans/create-pull-request@v3',
        with: {
          'token': '${{ secrets.' + AUTOMATION_TOKEN + ' }}',
          'commit-message': 'chore: upgrade projen',
          'branch': 'auto/projen-upgrade',
          'title': 'chore: upgrade projen and yarn',
          'body': 'This PR upgrades projen and yarn upgrade to the latest version',
          'labels': 'auto-merge',
        }
      },
    ],
  },
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
  'AWSCLI_VERSION*'
];
project.npmignore.exclude(...common_exclude);
project.gitignore.exclude(...common_exclude);

project.synth();
