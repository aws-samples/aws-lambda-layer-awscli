SECRETS_FILE ?= secrets.mk
ifeq ($(shell test -e $(SECRETS_FILE) && echo -n yes),yes)
    include $(SECRETS_FILE)
endif
CUSTOM_FILE ?= custom.mk
ifeq ($(shell test -e $(CUSTOM_FILE) && echo -n yes),yes)
    include $(CUSTOM_FILE)
endif
ROOT ?= $(shell pwd)

S3BUCKET ?= pahud-tmp-ap-northeast-1
LAMBDA_REGION ?= ap-northeast-1
LAMBDA_FUNC_NAME ?= lambda-alb-sample
LAMBDA_FUNC_DESC ?= 'aws lambda alb sample'

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

sam-package:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	pahud/aws-sam-cli:latest sam package --template-file sam.yaml --s3-bucket $(S3BUCKET) --output-template-file packaged.yaml

sam-deploy:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=$(LAMBDA_REGION) \
	-e AWS_PROFILE=$(AWS_PROFILE) \
	pahud/aws-sam-cli:latest sam deploy --template-file ./packaged.yaml --stack-name "$(LAMBDA_FUNC_NAME)-stack" --capabilities CAPABILITY_IAM
	# print the cloudformation stack outputs
	aws --region $(LAMBDA_REGION) cloudformation describe-stacks --stack-name "$(LAMBDA_FUNC_NAME)-stack" --query 'Stacks[0].Outputs'


sam-destroy:
	# destroy the stack	
	aws --region $(LAMBDA_REGION) cloudformation delete-stack --stack-name "$(LAMBDA_FUNC_NAME)-stack"


clean:
	rm -rf awscli-bundle* layer layer.zip func-bundle.zip lambda.output
	
clean-all: clean
	@aws --region $(LAMBDA_REGION) lambda delete-function --function-name $(LAMBDA_FUNC_NAME)
	
	
