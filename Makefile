.PHONY: update exec build/tools console/tools lint/all init/all init deploy deploy/all plan plan/all apply apply/all destroy/all  destroy!/all state push outputs docs docs/tf

COMPONENT_NAME=device-management
STACK_NAME=""
BUCKET_NAME=$(shell cat ./stacks/${STACK_NAME}.tfvars.json | jq -r .state_bucket)
BACKEND_KEY=$(shell cat ./stacks/${STACK_NAME}.tfvars.json | jq -r .state_key)
KMS_KEY_ALIAS=$(shell cat ./stacks/${STACK_NAME}.tfvars.json | jq -r .state_kms_alias)
REGION=$(shell cat ./stacks/${STACK_NAME}.tfvars.json | jq -r .region)

KMS_KEY=$(shell aws kms describe-key --key-id ${KMS_KEY_ALIAS} --query 'KeyMetadata.Arn' --output text)
MODULE_PATHS:=\
iot-management/deploy \
iot-identity/deploy \
iot-devicetwin/deploy

update:
	git submodule update --init --recursive --remote
lint:
	terraform fmt
	terraform validate
	tflint
lint/all: lint
	for path in $(MODULE_PATHS); do \
		$(MAKE) lint -C $$path STACK_NAME=${STACK_NAME}; \
    done
init:
	terraform init \
	-reconfigure \
	-input=false \
	-backend-config "region=${REGION}" \
	-backend-config "bucket=${BUCKET_NAME}" \
	-backend-config "key=${BACKEND_KEY}" \
	-backend-config "kms_key_id=${KMS_KEY}"
init/all: init
	for path in $(MODULE_PATHS); do \
		$(MAKE) init -C $$path STACK_NAME=${STACK_NAME}; \
    done
plan:
	terraform plan -input=false \
	-var-file "stacks/${STACK_NAME}.tfvars.json"
plan/all: plan
	for path in $(MODULE_PATHS); do \
		$(MAKE) plan -C $$path STACK_NAME=${STACK_NAME}; \
    done
apply:
	terraform apply -input=false -auto-approve \
	-var-file "stacks/${STACK_NAME}.tfvars.json"
apply/all:
	for path in $(MODULE_PATHS); do \
		$(MAKE) apply -C $$path STACK_NAME=${STACK_NAME}; \
    done
state:
	terraform state list
destroy/all: 
	for path in $(MODULE_PATHS); do \
		$(MAKE) destroy -C $$path STACK_NAME=${STACK_NAME}; \
    done

	terraform destroy \
	-var-file "stacks/${STACK_NAME}.tfvars.json"
destroy!/all:
	for path in $(MODULE_PATHS); do \
		$(MAKE) destroy! -C $$path STACK_NAME=${STACK_NAME}; \
    done

	terraform destroy -auto-approve \
	-var-file "stacks/${STACK_NAME}.tfvars.json"
deploy: init apply
deploy/all: deploy
	for path in $(MODULE_PATHS); do \
		$(MAKE) deploy -C $$path STACK_NAME=${STACK_NAME}; \
    done
outputs:
	terraform output
docs:
	terraform-docs markdown table --output-file README.md --output-mode inject .
docs/tf: docs
	for path in $(MODULE_PATHS); do \
		$(MAKE) docs/tf -C $$path STACK_NAME=${STACK_NAME}; \
    done
build/tools:
	docker build -t everactive/device-management-tools:latest .
console/tools:
	docker run  \
			   -v $(PWD):/home/device-manager \
			   -v ~/.aws:/root/.aws \
			   -v ~/.kube:/root/.kube \
			   -it --rm everactive/device-management-tools:latest /bin/bash
exec:
	docker run  \
			   -v $(PWD):/home/device-manager \
			   -v ~/.aws:/root/.aws \
			   -v ~/.kube:/root/.kube \
			   -it --rm everactive/device-management-tools:latest ${cmd}