import '@aws-cdk/assert/jest';
import { App } from '@aws-cdk/core';
import { LayerStack } from '../src/main';

test('Layer with basic configuration', () => {
  const app = new App();
  const stack = new LayerStack(app, 'test');

  expect(stack).toHaveResource('AWS::Lambda::LayerVersion');
});
