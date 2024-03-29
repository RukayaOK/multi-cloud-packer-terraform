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
CLOUD_OPTS := azure aws gcp cloudflare
ifneq ($(filter $(CLOUD),$(CLOUD_OPTS)),)
    $(info $(yellow)Cloud: $(CLOUD)$(reset))
else
    $(error $(red)Variable CLOUD is not set to one of the following: $(CLOUD_OPTS)$(reset))
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
else ifeq ($(strip $(CLOUD)),cloudflare)
	TERRAFORM_VARS := CLOUDFLARE_API_TOKEN CLOUDFLARE_EMAIL
endif

# Ensure the RUNTIME_ENV variable is set. This is used to: \
Determine whether to run commands locally, in container or in pipeline
RUNTIME_ENV_OPTS := local container
ifneq ($(filter $(RUNTIME_ENV),$(RUNTIME_ENV_OPTS)),)
    $(info $(yellow)Runtime Environment: $(RUNTIME_ENV)$(reset))
else
    $(error $(red)Variable RUNTIME_ENV is not set to one of the following: $(RUNTIME_ENV_OPTS)$(reset))
endif

BOOTSTRAP_OR_TEST_OPTS := bootstrap test
ifneq ($(filter $(BOOTSTRAP_OR_TEST),$(BOOTSTRAP_OR_TEST_OPTS)),)
    $(info $(yellow)Bootstrap or Test: $(BOOTSTRAP_OR_TEST)$(reset))
else
    $(error $(red)Variable BOOTSTRAP_OR_TEST is not set to one of the following: $(BOOTSTRAP_OR_TEST_OPTS)$(reset))
endif

# cloudflare only run when testing images so BOOTSTRAP_OR_TEST=test if CLOUD=cloudflare
ifeq ($(CLOUD),cloudflare)
ifeq ($(BOOTSTRAP_OR_TEST),bootstrap)
    $(error $(red)No Clouflare Terraform to Bootstrap$(reset))
endif
endif

ifeq ($(BOOTSTRAP_OR_TEST),bootstrap)
	TERRAFORM_PATH=terraform/${BOOTSTRAP_OR_TEST}/${CLOUD}
else ifeq ($(strip $(TERRAFORM_PATH)),test)
	TERRAFORM_PATH=terraform/${BOOTSTRAP_OR_TEST}/${IMAGE}/${CLOUD}
endif


.PHONY: help
help:					## Displays the help
	@printf "\nUsage : make <command> \n\nThe following commands are available: \n\n"
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@printf "\n"

.PHONY: pre-commit
pre-commit:				## Run pre-commit checks
	pre-commit run --all-files

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
docker-restart: docker-stop docker-start			## Restart the docker container

.PHONY: docker-exec
docker-exec: docker-start				## Runs the docker container
	docker exec -it ${CLOUD}-terraform-packer bash

.PHONY: create-terra-bootstrap
create-terra-bootstrap:			## Bootstrap Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	sh ./helpers/terraform-bootstrap/${CLOUD}.sh create
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make docker-restart
	docker exec -it ${CLOUD}-terraform-packer sh ./helpers/terraform-bootstrap/${CLOUD}.sh create
endif

.PHONY: destroy-terra-bootstrap
destroy-terra-bootstrap:			## Bootstrap Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	sh ./helpers/terraform-bootstrap/${CLOUD}.sh destroy
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make docker-restart
	docker exec -it ${CLOUD}-terraform-packer sh ./helpers/terraform-bootstrap/${CLOUD}.sh destroy
endif

terra-env:				## Set Terraform Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(TERRAFORM_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

.PHONY: terra-init
terra-init: terra-env			## Initialises Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=${TERRAFORM_PATH} init
	terraform -chdir=${TERRAFORM_PATH} fmt --recursive
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make docker-restart
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} init
endif

.PHONY: terra-plan
terra-plan: terra-init			## Plans Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=${TERRAFORM_PATH} validate
	terraform -chdir=${TERRAFORM_PATH} plan -out=plan/tfplan.binary -var-file vars.tfvars
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} validate
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} plan -out=plan/tfplan.binary -var-file vars.tfvars
endif

.PHONY: terra-sec
terra-sec: terra-plan			## Security Check Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=${TERRAFORM_PATH} show -json plan/tfplan.binary > ${TERRAFORM_PATH}/plan/tfplan.json
	checkov -f ${TERRAFORM_PATH}/plan/tfplan.json
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} show -json plan/tfplan.binary > ${TERRAFORM_PATH}/plan/tfplan.json
	docker exec -it ${CLOUD}-terraform-packer checkov -f ${TERRAFORM_PATH}/plan/tfplan.json
endif

.PHONY: terra-lint
terra-lint: 				## Lint Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	tflint ${TERRAFORM_PATH}/ --init --config=${TERRAFORM_PATH}/.tflint.hcl --var-file=${TERRAFORM_PATH}/vars.tfvars
	tflint ${TERRAFORM_PATH}/ --config=${TERRAFORM_PATH}/.tflint.hcl --var-file=${TERRAFORM_PATH}/vars.tfvars
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make terra-init 
	docker exec -it ${CLOUD}-terraform-packer tflint ${TERRAFORM_PATH}/ --init --config=${TERRAFORM_PATH}/.tflint.hcl --var-file=${TERRAFORM_PATH}/vars.tfvars
	docker exec -it ${CLOUD}-terraform-packer tflint ${TERRAFORM_PATH}/ --config=${TERRAFORM_PATH}/.tflint.hcl --var-file=${TERRAFORM_PATH}/vars.tfvars
endif

.PHONY: terra-apply
terra-apply: terra-plan			## Apply Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=${TERRAFORM_PATH} apply plan/tfplan.binary
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} apply plan/tfplan.binary
endif

.PHONY: terra-output
terra-output: terra-init		## Output Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=${TERRAFORM_PATH} output
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} output
endif

.PHONY: terra-destroy
terra-destroy: terra-init		## Destroy Terraform
ifeq ($(strip $(RUNTIME_ENV)),local)
	terraform -chdir=${TERRAFORM_PATH} destroy -var-file vars.tfvars -auto-approve
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer terraform -chdir=${TERRAFORM_PATH} destroy -var-file vars.tfvars -auto-approve
endif

.PHONY: terra-plan-all
terra-plan-all: 	## Plan terraform for all Cloud Providers
	@for cloud in azure aws gcp ; do \
		export CLOUD=$$cloud ; \
		echo $$CLOUD ; \
		make terra-plan ; \
    done

.PHONY: terra-apply-all
terra-apply-all: 	## Apply terraform for all Cloud Providers
ifeq ($(strip $(BOOTSTRAP_OR_TEST)),bootstrap)
	@for cloud in azure aws gcp ; do \
		export CLOUD=$$cloud ; \
		make terra-apply ; \
    done
else ifeq ($(strip $(BOOTSTRAP_OR_TEST)),test)
	@for cloud in azure aws gcp cloudflare ; do \
		export CLOUD=$$cloud ; \
		make terra-apply ; \
    done
endif

.PHONY: terra-destroy-all
terra-destroy-all: 	## Destroy terraform for all Cloud Providers
ifeq ($(strip $(BOOTSTRAP_OR_TEST)),bootstrap)
	@for cloud in azure aws gcp ; do \
		export CLOUD=$$cloud ; \
		make terra-destroy ; \
    done
else ifeq ($(strip $(BOOTSTRAP_OR_TEST)),test)
	@for cloud in cloudflare azure aws gcp ; do \
		export CLOUD=$$cloud ; \
		make terra-destroy ; \
    done
endif

packer-env:				## Set Packer Environment Variables
ifeq ($(strip $(filter $(NOGOAL), $(MAKECMDGOALS))),)
	$(foreach v,$(PACKER_VARS),$(if $($v),$(info Variable $v defined),$(error Error: $v undefined)))
endif

packer-image: 
# Ensure the IMAGE variable is set. This is used to: \
Determine what packer image to build
IMAGE_OPTS := nginx
ifneq ($(filter $(IMAGE),$(IMAGE_OPTS)),)
    $(info $(yellow)Image: $(IMAGE)$(reset))
else
    $(error $(red)Variable IMAGE is not set to one of the following: $(IMAGE_OPTS)$(reset))
endif

.PHONY: packer-init
packer-init: packer-env packer-image 	## Initialises Packer
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer init packer/${IMAGE}
	packer fmt packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	make docker-restart
	docker exec -it ${CLOUD}-terraform-packer packer init packer/${IMAGE} 
	docker exec -it ${CLOUD}-terraform-packer packer fmt packer/${IMAGE}
endif

.PHONY: packer-variables
packer-variables: 		## Get variables for packer
ifeq ($(strip $(RUNTIME_ENV)),local)
	sh ./helpers/get_packer_variables.sh get_${CLOUD}_packer_variables
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer sh ./helpers/get_packer_variables.sh get_${CLOUD}_packer_variables
endif

.PHONY: packer-validate
packer-validate: packer-init		## Validates Packer Image
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer validate -only=${PACKER_BUILDER}.${IMAGE} -var-file=packer/${IMAGE}/${CLOUD}.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer validate -only=${PACKER_BUILDER} -var-file=packer/${IMAGE}/variables.${CLOUD}.json packer/${IMAGE}/packer.json
endif

.PHONY: packer-build
packer-build: packer-validate		## Builds Packer Image
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer build -only=${PACKER_BUILDER}.${IMAGE} -var-file=packer/${IMAGE}/${CLOUD}.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer build -only=${PACKER_BUILDER} -var-file=packer/${IMAGE}/${CLOUD}.pkrvars.hcl packer/${IMAGE}
endif

.PHONY: packer-delete
packer-delete: 		## Deletes Packer Image [ARG: IMAGE_NAME="<Image Name>"]
ifeq ($(strip $(RUNTIME_ENV)),local)
	sh ./helpers/delete_image.sh delete_${CLOUD}_image ${CLOUD} ${TERRAFORM_PATH} $$IMAGE_NAME
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer sh ./helpers/delete_image.sh delete_${CLOUD}_image $$IMAGE_NAME
endif

.PHONY: packer-validate-all
packer-validate-all: packer-init		## Validate Packer Image for all Cloud Providers
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer validate -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer validate -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
endif

.PHONY: packer-build-all
packer-build-all: packer-validate-all		## Builds Packer Image for all Cloud Providers
ifeq ($(strip $(RUNTIME_ENV)),local)
	packer build -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
else ifeq ($(strip $(RUNTIME_ENV)),container)
	docker exec -it ${CLOUD}-terraform-packer packer build -var-file=packer/${IMAGE}/azure.pkrvars.hcl -var-file=packer/${IMAGE}/aws.pkrvars.hcl -var-file=packer/${IMAGE}/gcp.pkrvars.hcl packer/${IMAGE}
endif

.PHONY: packer-variables-all
packer-variables-all: 		## Get variables for packer
	@for cloud in azure aws gcp ; do \
		export CLOUD=$$cloud ; \
		make packer-variables ; \
    done
