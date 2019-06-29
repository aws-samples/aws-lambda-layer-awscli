.PHONY: layer-zip layer-upload layer-publish func-zip create-func update-func layer-all func-all invoke clean

S3BUCKET ?= pahud-tmp-nrt
LAMBDA_REGION ?= ap-northeast-1
LAMBDA_FUNC_NAME ?= ec2-instance-connect-sg
CLUSTER_NAME ?= default
VPCID ?= vpc-e549a281


.PHONY: build 
build: layer-build

.PHONY: layer-build
layer-build:
	@bash build.sh
	@echo "[OK] Layer built at ./layer.zip"
	@ls -alh ./layer.zip

.PHONY: sam-layer-package
sam-layer-package:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam package --template-file sam-layer.yaml --s3-bucket $(S3BUCKET) --output-template-file sam-layer-packaged.yaml
	@echo "[OK] Now type 'make sam-layer-deploy' to deploy your Lambda layer with SAM"

.PHONY: sam-layer-deploy
sam-layer-deploy:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam deploy --template-file ./sam-layer-packaged.yaml --stack-name "$(LAYER_NAME)-stack"
	# print the cloudformation stack outputs
	aws --region $(LAMBDA_REGION) cloudformation describe-stacks --stack-name "$(LAYER_NAME)-stack" --query 'Stacks[0].Outputs'
	@echo "[OK] Layer version deployed."
	
.PHONY: sam-layer-info
sam-layer-info:
	@aws --region $(LAMBDA_REGION) cloudformation describe-stacks --stack-name "$(LAYER_NAME)-stack" --query 'Stacks[0].Outputs'
	

.PHONY: sam-layer-destroy
sam-layer-destroy:
	# destroy the layer stack	
	aws --region $(LAMBDA_REGION) cloudformation delete-stack --stack-name "$(LAYER_NAME)-stack"
	@echo "[OK] Layer version destroyed."
	
	
.PHONY: func-prep	
func-prep:
	@rm -rf ./func.d
	@[ ! -d ./func.d ] && mkdir ./func.d || true
	@cp main.sh bootstrap ./func.d	
	
.PHONY: sam-package
sam-package:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam package --template-file sam.yaml --s3-bucket $(S3BUCKET) --output-template-file packaged.yaml


.PHONY: sam-package-from-sar
sam-package-from-sar:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam package --template-file sam-sar.yaml --s3-bucket $(S3BUCKET) --output-template-file packaged.yaml

.PHONY: sam-publish
sam-publish:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam publish --region $(LAMBDA_REGION) --template packaged.yaml
	
	
.PHONY: sam-publish-global
sam-publish-global:
	$(foreach LAMBDA_REGION,$(GLOBAL_REGIONS), LAMBDA_REGION=$(LAMBDA_REGION) make sam-publish;)


.PHONY: sam-deploy
sam-deploy:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam deploy \
	--parameter-overrides ClusterName=$(CLUSTER_NAME) FunctionName=$(LAMBDA_FUNC_NAME) LambdaRoleArn=$(LambdaRoleArn) VpcId=$(VPCID) \
	--template-file ./packaged.yaml --stack-name "$(LAMBDA_FUNC_NAME)" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
	# print the cloudformation stack outputs
	aws --region $(LAMBDA_REGION) cloudformation describe-stacks --stack-name "$(LAMBDA_FUNC_NAME)" --query 'Stacks[0].Outputs'


.PHONY: sam-logs-tail
sam-logs-tail:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam logs --name $(LAMBDA_FUNC_NAME) --tail

.PHONY: sam-destroy
sam-destroy:
	# destroy the stack	
	aws --region $(LAMBDA_REGION) cloudformation delete-stack --stack-name "$(LAMBDA_FUNC_NAME)"
