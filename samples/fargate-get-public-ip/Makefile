CUSTOM_FILE ?= custom.mk
ifeq ($(shell test -e $(CUSTOM_FILE) && echo -n yes),yes)
    include $(CUSTOM_FILE)
endif

LAYER_NAME ?= awscli-layer
LAYER_DESC ?= awscli-layer
S3BUCKET ?= pahud-tmp-us-west-2
LAMBDA_REGION ?= us-west-2
LAMBDA_FUNC_NAME ?= farget-getIp
LAMBDA_FUNC_DESC ?= farget-getIp
LAMBDA_ROLE_ARN ?= arn:aws:iam::XXXXXXXXXX:role/LambdaSiriDemo
SAM_YAML ?= sam.yaml

build:
	@bash build.sh
	
layer-zip:
	( cd layer; zip -r ../layer.zip * )
	
layer-upload:
	@aws s3 cp layer.zip s3://$(S3BUCKET)/$(LAYER_NAME).zip
	
layer-publish:
	@aws --region $(LAMBDA_REGION) lambda publish-layer-version \
	--layer-name $(LAYER_NAME) \
	--description $(LAYER_DESC) \
	--license-info "MIT" \
	--content S3Bucket=$(S3BUCKET),S3Key=$(LAYER_NAME).zip \
	--compatible-runtimes provided
	
func-zip:
	chmod +x main.sh
	zip -r func-bundle.zip bootstrap main.sh; ls -alh func-bundle.zip
	
create-func: func-zip
	@aws --region $(LAMBDA_REGION) lambda create-function \
	--function-name $(LAMBDA_FUNC_NAME) \
	--description $(LAMBDA_FUNC_DESC) \
	--runtime provided \
	--role  $(LAMBDA_ROLE_ARN) \
	--timeout 30 \
	--layers $(LAMBDA_LAYERS) \
	--handler main \
	--zip-file fileb://func-bundle.zip 

update-func: func-zip
	@aws --region $(LAMBDA_REGION) lambda update-function-code \
	--function-name $(LAMBDA_FUNC_NAME) \
	--zip-file fileb://func-bundle.zip
	
func-all: func-zip update-func
layer-all: build layer-upload layer-publish


invoke:
	@aws --region $(LAMBDA_REGION) lambda invoke --function-name $(LAMBDA_FUNC_NAME)  \
	--payload "" lambda.output --log-type Tail | jq -r .LogResult | base64 -d	
	
add-layer-version-permission:
	@aws --region $(LAMBDA_REGION) lambda add-layer-version-permission \
	--layer-name $(LAYER_NAME) \
	--version-number $(LAYER_VER) \
	--statement-id public-all \
	--action lambda:GetLayerVersion \
	--principal '*'
	

all: build layer-upload layer-publish

prepare:
	@rm -rf ./func-bundle/*
	@cp main.sh bootstrap Makefile func-bundle/ && chmod +x ./func-bundle/main.sh ./func-bundle/bootstrap

sam-package:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam package --template-file $(SAM_YAML) --s3-bucket $(S3BUCKET) --output-template-file packaged.yaml

.PHONY: sam-deploy
sam-deploy: 
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	pahud/aws-sam-cli:latest sam deploy \
	--template-file ./packaged.yaml \
	--stack-name "$(LAMBDA_FUNC_NAME)" \
	--capabilities CAPABILITY_AUTO_EXPAND CAPABILITY_IAM \
	--parameter-overrides \
	LambdaRoleArn=$(LAMBDA_ROLE_ARN) \
	CloudMapServiceId=$(CM_SERVICE_ID) \
	# print the cloudformation stack outputs
	aws --region $(LAMBDA_REGION) cloudformation describe-stacks --stack-name "$(LAMBDA_FUNC_NAME)" --query 'Stacks[0].Outputs'


# .PHONY: cfn-deploy
# cfn-deploy:
# 	@aws --region $(LAMBDA_REGION) cloudformation create-stack --template-body file://packaged.yaml \
# 	--stack-name  "$(LAMBDA_FUNC_NAME)" \
# 	--parameters \
# 	ParameterKey=LambdaRoleArn,ParameterValue=$(LAMBDA_ROLE_ARN) \
# 	ParameterKey=CloudMapServiceId,ParameterValue=$(CM_SERVICE_ID) \
# 	--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND 


.PHONY: cfn-update
cfn-update:
	@aws --region $(LAMBDA_REGION) cloudformation update-stack --template-body file://packaged.yaml \
	--stack-name  "$(LAMBDA_FUNC_NAME)" \
	--parameters \
	ParameterKey=LambdaRoleArn,ParameterValue=$(LAMBDA_ROLE_ARN) \
	--capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND 


sam-destroy:
	# destroy the stack	
	aws --region $(LAMBDA_REGION) cloudformation delete-stack --stack-name "$(LAMBDA_FUNC_NAME)"


clean:
	rm -rf awscli-bundle* layer layer.zip func-bundle.zip lambda.output
	
clean-all: clean
	@aws --region $(LAMBDA_REGION) lambda delete-function --function-name $(LAMBDA_FUNC_NAME)
	
	
