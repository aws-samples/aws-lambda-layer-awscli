ROOT ?= $(shell pwd)
AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query 'Account' --output text)
LAYER_NAME ?= awscli-layer
LAYER_DESC ?= awscli-layer
S3BUCKET ?= pahud-tmp-ap-northeast-1
LAMBDA_REGION ?= ap-northeast-1
LAMBDA_FUNC_NAME ?= awscli-layer-test-func
LAMBDA_FUNC_DESC ?= awscli-layer-test-func
LAMBDA_ROLE_ARN ?= arn:aws:iam::$(AWS_ACCOUNT_ID):role/service-role/LambdaDefaultRole
AWS_PROFILE ?= default
PAYLOAD ?= {"foo":"bar"}

.PHONY: build layer-build layer-zip layer-upload layer-publish sam-layer-package sam-layer-deploy sam-layer-destroy func-zip create-func update-func func-all layer-all invoke add-layer-version-permission all clean clean-all delete-func 

build: layer-build

layer-build:
	@bash build.sh
	@echo "[OK] Layer built at ./layer.zip"
	@ls -alh ./layer.zip
	
layer-zip:
	( cd layer; zip -r ../layer.zip * )
	
layer-upload:
	@aws --profile=$(AWS_PROFILE) s3 cp layer.zip s3://$(S3BUCKET)/$(LAYER_NAME).zip
	
layer-publish:
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda publish-layer-version \
	--layer-name $(LAYER_NAME) \
	--description $(LAYER_DESC) \
	--license-info "MIT" \
	--content S3Bucket=$(S3BUCKET),S3Key=$(LAYER_NAME).zip \
	--compatible-runtimes provided

sam-layer-package:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	pahud/aws-sam-cli:latest sam package --template-file sam-layer.yaml --s3-bucket $(S3BUCKET) --output-template-file sam-layer-packaged.yaml
	@echo "[OK] Now type 'make sam-layer-deploy' to deploy your Lambda layer with SAM"
	
.PHONY: sam-layer-publish
sam-layer-publish:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	pahud/aws-sam-cli:latest sam publish --region $(LAMBDA_REGION) --template sam-layer-packaged.yaml

sam-layer-deploy:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	pahud/aws-sam-cli:latest sam deploy --template-file ./sam-layer-packaged.yaml --stack-name "$(LAYER_NAME)-stack"
	# print the cloudformation stack outputs
	aws --region $(LAMBDA_REGION) cloudformation describe-stacks --stack-name "$(LAYER_NAME)-stack" --query 'Stacks[0].Outputs'
	@echo "[OK] Layer version deployed."

sam-layer-destroy:
	# destroy the layer stack	
	aws --region $(LAMBDA_REGION) cloudformation delete-stack --stack-name "$(LAYER_NAME)-stack"
	@echo "[OK] Layer version destroyed."
	

# Makefile for China regions	
include cn.mk	

	
func-zip:
	rm -rf ./lambda-bundle; mkdir ./lambda-bundle
	chmod +x main.sh
	cp main.sh bootstrap ./lambda-bundle;
	cp Makefile.lambda ./lambda-bundle/Makefile;
	cd ./lambda-bundle && \
	zip -r ../func-bundle.zip *; ls -alh ../func-bundle.zip
	
create-func: func-zip
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda create-function \
	--function-name $(LAMBDA_FUNC_NAME) \
	--description $(LAMBDA_FUNC_DESC) \
	--runtime provided \
	--role  $(LAMBDA_ROLE_ARN) \
	--timeout 30 \
	--memory-size 512 \
	--layers $(LAMBDA_LAYERS) \
	--handler main \
	--zip-file fileb://func-bundle.zip 

update-func: func-zip
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda update-function-code \
	--function-name $(LAMBDA_FUNC_NAME) \
	--zip-file fileb://func-bundle.zip
	
func-all: func-zip update-func
layer-all: build layer-upload layer-publish


invoke:
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda invoke --function-name $(LAMBDA_FUNC_NAME)  \
	--payload '$(PAYLOAD)' lambda.output --log-type Tail | jq -r .LogResult | base64 -D	
	
add-layer-version-permission:
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda add-layer-version-permission \
	--layer-name $(LAYER_NAME) \
	--version-number $(LAYER_VER) \
	--statement-id public-all \
	--action lambda:GetLayerVersion \
	--principal '*'
	

all: build layer-upload layer-publish
	
clean:
	rm -rf awscli-bundle* layer layer.zip func-bundle.zip lambda.output
	

delete-func:
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda delete-function --function-name $(LAMBDA_FUNC_NAME)
	
clean-all: clean
	@aws --profile=$(AWS_PROFILE) --region $(LAMBDA_REGION) lambda delete-function --function-name $(LAMBDA_FUNC_NAME)
	
	
