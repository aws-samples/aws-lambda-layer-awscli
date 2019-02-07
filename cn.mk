#
# Beijing Region
#
sam-layer-package-bjs:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=cn-north-1 \
	-e AWS_PROFILE=$(shell echo ${AWS_PROFILE}) \
	pahud/aws-sam-cli:latest sam package --template-file sam-layer.yaml --s3-bucket pahud-tmp-cn-north-1 --output-template-file sam-layer-packaged.yaml
	@echo "[OK] Now type 'make sam-layer-deploy' to deploy your Lambda layer with SAM"
	
sam-layer-deploy-bjs:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=cn-north-1 \
	-e AWS_PROFILE=$(shell echo ${AWS_PROFILE}) \
	pahud/aws-sam-cli:latest sam deploy --template-file ./sam-layer-packaged.yaml --stack-name "$(LAYER_NAME)-stack"
	# print the cloudformation stack outputs
	aws --region cn-north-1 cloudformation describe-stacks --stack-name "$(LAYER_NAME)-stack" --query 'Stacks[0].Outputs'
	@echo "[OK] Layer version deployed."

sam-layer-destroy-bjs:
	# destroy the layer stack	
	aws --region cn-north-1 cloudformation delete-stack --stack-name "$(LAYER_NAME)-stack"
	@echo "[OK] Layer version destroyed."
	

#
# Ningxia Region
#
sam-layer-package-zhy:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=cn-north-1 \
	-e AWS_PROFILE=$(shell echo ${AWS_PROFILE}) \
	pahud/aws-sam-cli:latest sam package --template-file sam-layer.yaml --s3-bucket pahud-tmp-cn-north-1 --output-template-file sam-layer-packaged.yaml
	@echo "[OK] Now type 'make sam-layer-deploy' to deploy your Lambda layer with SAM"
	
sam-layer-deploy-zhy:
	@docker run -ti \
	-v $(PWD):/home/samcli/workdir \
	-v $(HOME)/.aws:/home/samcli/.aws \
	-w /home/samcli/workdir \
	-e AWS_DEFAULT_REGION=cn-north-1 \
	-e AWS_PROFILE=$(shell echo ${AWS_PROFILE}) \
	pahud/aws-sam-cli:latest sam deploy --template-file ./sam-layer-packaged.yaml --stack-name "$(LAYER_NAME)-stack"
	# print the cloudformation stack outputs
	aws --region cn-north-1 cloudformation describe-stacks --stack-name "$(LAYER_NAME)-stack" --query 'Stacks[0].Outputs'
	@echo "[OK] Layer version deployed."

sam-layer-destroy-zhy:
	# destroy the layer stack	
	aws --region cn-north-1 cloudformation delete-stack --stack-name "$(LAYER_NAME)-stack"
	@echo "[OK] Layer version destroyed."
