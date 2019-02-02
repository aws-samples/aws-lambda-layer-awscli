LAYER_NAME ?= awscli-layer
LAYER_DESC ?= awscli-layer
S3BUCKET ?= pahud-tmp-cn-northwest-1
LAMBDA_REGION ?= cn-northwest-1
LAMBDA_FUNC_NAME ?= awscli-layer-test-func
LAMBDA_FUNC_DESC ?= awscli-layer-test-func
LAMBDA_ROLE_ARN ?= arn:aws:iam::xxxxxxxx:role/service-role/myLambdaRole
AWS_PROFILE ?= default
PAYLOAD ?= {"foo":"bar"}

build:
	@bash build.sh
	
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
	
func-zip:
	chmod +x main.sh
	zip -r func-bundle.zip bootstrap main.sh; ls -alh func-bundle.zip
	
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
	
	
