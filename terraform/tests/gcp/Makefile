# Coloured Text 
red:=$(shell tput setaf 1)
yellow:=$(shell tput setaf 3)
reset:=$(shell tput sgr0)


# Ensure the CLOUD variable is set. This is used to: \
1. Navigate to the correct terraform folder \
2. Reference the name of the docker container to start \
3. Set the Packer Builder type \
4. Lookup the right Packer cloud variable file \
5. Validate the cloud-specific terraform and packer variables that need to be set
CLOUD_OPTS := azure aws gcp
ifneq ($(filter $(CLOUD),$(CLOUD_OPTS)),)
    $(info $(yellow)Cloud: $(CLOUD)$(reset))
else
    $(error $(red)Variable CLOUD is not set to one of the following: $(CLOUD_OPTS)$(reset))
endif

BOOTSTRAP_OR_TEST_OPTS := bootstrap test
ifneq ($(filter $(BOOTSTRAP_OR_TEST),$(CLOUD_OPTS)),)
    $(info $(yellow)Bootstrap or Test: $(BOOTSTRAP_OR_TEST)$(reset))
else
    $(error $(red)Variable BOOTSTRAP_OR_TEST is not set to one of the following: $(BOOTSTRAP_OR_TEST_OPTS)$(reset))
endif

# Based on the CLOUD variable \
set the cloud-specific terraform and packer variables to validate
ifeq ($(strip $(CLOUD)),azure) 
	PACKER_BUILDER=azure-arm
	TERRAFORM_VARS := ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID ARM_SUBSCRIPTION_ID ARM_ACCESS_KEY
	PACKER_VARS := PKR_VAR_AZURE_CLIENT_ID PKR_VAR_AZURE_CLIENT_SECRET PKR_VAR_AZURE_SUBSCRIPTION_ID PKR_VAR_AZURE_TENANT_ID
else ifeq ($(strip $(CLOUD)),aws) 
	PACKER_BUILDER=amazon-ebs
	TERRAFORM_VARS := AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
	PACKER_VARS := PKR_VAR_AWS_ACCESS_KEY PKR_VAR_AWS_SECRET_KEY
else ifeq ($(strip $(CLOUD)),gcp) 
	PACKER_BUILDER=googlecompute
	TERRAFORM_VARS := TF_VAR_GOOGLE_APPLICATION_CREDENTIALS GOOGLE_APPLICATION_CREDENTIALS_FULL_PATH GOOGLE_CLIENT_EMAIL
	PACKER_VARS := PKR_VAR_GCP_ACCOUNT_CREDENTIALS PKR_VAR_GCP_SERVICE_ACCOUNT_EMAIL
endif

# Ensure the RUNTIME_ENV variable is set. This is used to: \
Determine whether to run commands locally, in container or in pipeline
RUNTIME_ENV_OPTS := local container pipeline
ifneq ($(filter $(RUNTIME_ENV),$(RUNTIME_ENV_OPTS)),)
    $(info $(yellow)Runtime Environment: $(RUNTIME_ENV)$(reset))
else
    $(error $(red)Variable RUNTIME_ENV is not set to one of the following: $(RUNTIME_ENV_OPTS)$(reset))
endif


.PHONY: help
help:					## Displays the help
	@printf "\nUsage : make <command> \n\nThe following commands are available: \n\n"
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@printf "\n"

.PHONY: pre-commit
pre-commit:				## Run pre-commit checks
	pre-commit run --all-files

terra-env:				## Set Terraform Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(TERRAFORM_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

packer-env:				## Set Packer Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(PACKER_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

.PHONY: docker-build
docker-build:					## Builds the docker image
	docker-compose -f docker/docker-compose.yml build ${CLOUD}-terraform-packer

.PHONY: docker-start
docker-start: 					## Runs the docker container
	docker-compose -f docker/docker-compose.yml up -d ${CLOUD}-terraform-packer

.PHONY: docker-stop
docker-stop:					## Stops and Remove the docker container
	docker-compose -f docker/docker-compose.yml stop ${CLOUD}-terraform-packer
	docker rm ${CLOUD}-terraform-packer

.PHONY: docker-restart
docker-restart: stop start			## Restart the docker container

.PHONY: docker-exec
docker-exec: docker-start				## Runs the docker container
	docker exec -it ${CLOUD}-terraform-packer bash

.PHONY: terra-init
terra-init: terra-env			## Initialises Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} init
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} fmt --recursive
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make restart
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} init
endif

.PHONY: terra-plan
terra-plan: terra-init			## Plans Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} validate
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} plan -out=plan/tfplan.binary -var-file vars.tfvars
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} validate
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} plan -out=plan/tfplan.binary -var-file vars.tfvars
endif

.PHONY: terra-sec
terra-sec: terra-plan			## Security Check Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} show -json plan/tfplan.binary > terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/plan/tfplan.json
	checkov -f terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/plan/tfplan.json
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} show -json plan/tfplan.binary > terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/plan/tfplan.json
	docker exec -it ${CLOUD}-terraform-packer checkov -f terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/plan/tfplan.json
endif

.PHONY: terra-lint
terra-lint: 				## Lint Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	tflint terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/ --init --config=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/.tflint.hcl --var-file=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/vars.tfvars
	tflint terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/ --config=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/.tflint.hcl --var-file=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/vars.tfvars
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make terra-init 
	docker exec -it ${CLOUD}-terraform-packer tflint terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/ --init --config=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/.tflint.hcl --var-file=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/vars.tfvars
	docker exec -it ${CLOUD}-terraform-packer tflint terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/ --config=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/.tflint.hcl --var-file=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}/vars.tfvars
endif

.PHONY: terra-apply
terra-apply: terra-plan			## Apply Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} apply plan/tfplan.binary
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} apply plan/tfplan.binary
endif

.PHONY: terra-output
terra-output: terra-init		## Output Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} output
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} output
endif

.PHONY: terra-destroy
terra-destroy: terra-init		## Destroy Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} destroy -var-file vars.tfvars -auto-approve
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD} destroy -var-file vars.tfvars -auto-approve
endif

packer-image: 
# Ensure the IMAGE variable is set. This is used to: \
Determine what packer image to build
IMAGE_OPTS := nginx elasticsearch
ifneq ($(filter $(IMAGE),$(IMAGE_OPTS)),)
    $(info $(yellow)Image: $(IMAGE)$(reset))
else
    $(error $(red)Variable IMAGE is not set to one of the following: $(IMAGE_OPTS)$(reset))
endif

.PHONY: packer-init
packer-init: packer-image packer-env	## Initialises Packer
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer init packer/${IMAGE}
	packer fmt packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make restart
	docker exec -it ${CLOUD}-terraform-packer packer init packer/${IMAGE} 
	docker exec -it ${CLOUD}-terraform-packer packer fmt packer/${IMAGE}
endif

.PHONY: packer-validate
packer-validate: packer-init		## Validates Packer Image
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer validate -only=${PACKER_BUILDER}.${IMAGE} -var-file=packer/${IMAGE}/${CLOUD}.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer validate -only=${PACKER_BUILDER} -var-file=packer/${IMAGE}/variables.${CLOUD}.json packer/${IMAGE}/packer.json
endif

.PHONY: packer-validate-all
packer-validate-all: packer-init		## Validate Packer Image for all Cloud Providers
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer validate -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer validate -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
endif

.PHONY: packer-build
packer-build: packer-validate		## Builds Packer Image
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer build -only=${PACKER_BUILDER}.${IMAGE} -var-file=packer/${IMAGE}/${CLOUD}.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer build -only=${PACKER_BUILDER} -var-file=packer/${IMAGE}/${CLOUD}.pkrvars.hcl packer/${IMAGE}
endif

.PHONY: packer-build-all
packer-build-all: packer-validate-all		## Builds Packer Image for all Cloud Providers
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer build -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer build -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
endif

.PHONY: packer-delete
packer-delete: 		## Deletes Packer Image [ARG: IMAGE_ID="<Image ID>"]
ifeq ($(strip $(RUNTIME_ENV)),local)
	sh ./helpers/delete-image.sh delete_${CLOUD}_image ${CLOUD} $$IMAGE_ID
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer sh ./helpers/delete-image.sh delete_${CLOUD}_image $$IMAGE_ID
endif
	
.PHONY: packer-variables
packer-variables: 		## Deletes Packer Image [ARG: IMAGE_ID="<Image ID>"]
ifeq ($(strip $(RUNTIME_ENV)),local)
	sh ./helpers/get-packer-variables.sh get_${CLOUD}_packer_variables ${CLOUD} 
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer sh ./helpers/delete-image.sh delete-${CLOUD}-image $$IMAGE_ID
endif