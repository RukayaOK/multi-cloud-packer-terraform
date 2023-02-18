ARG ANSIBLE_VERSION=3.16

FROM alpine:${ANSIBLE_VERSION} as base 

#########################
####### TERRAFORM #######
#########################
# Set Terraform Variables
ENV TERRAFORM_VERSION=1.2.1 \
    TERRAFORM_OSNAME=linux \
    TERRAFORM_OSARCH=amd64 \
    TERRAFORM_DEST=/usr/local/bin
ENV TERRAFORM_ZIPFILE=terraform_${TERRAFORM_VERSION}_${TERRAFORM_OSNAME}_${TERRAFORM_OSARCH}.zip

# Download Terraform 
RUN wget -qP ${TERRAFORM_DEST}/ https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${TERRAFORM_ZIPFILE}

# Unzip Terraform and Remove zip file
RUN unzip ${TERRAFORM_DEST}/${TERRAFORM_ZIPFILE} -d ${TERRAFORM_DEST} \
    && rm ${TERRAFORM_DEST}/${TERRAFORM_ZIPFILE}


######################
####### TFLINT #######
######################
# Set Terraform Variables
ENV TFLINT_VERSION=0.43.0 \
    TFLINT_OSNAME=linux \
    TFLINT_OSARCH=amd64 \
    TFLINT_DEST=/usr/local/bin
ENV TFLINT_ZIPFILE=tflint_${TFLINT_OSNAME}_${TFLINT_OSARCH}.zip

RUN wget -qP ${TFLINT_DEST}/ https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/${TFLINT_ZIPFILE}

# Unzip Terraform and Remove zip file
RUN unzip ${TFLINT_DEST}/${TFLINT_ZIPFILE} -d ${TFLINT_DEST} \
    && rm ${TFLINT_DEST}/${TFLINT_ZIPFILE}


######################
####### PACKER #######
######################
# Set Packer Variables
ENV PACKER_VERSION=1.8.5 \
    PACKER_OSNAME=linux \
    PACKER_OSARCH=amd64 \
    PACKER_DEST=/usr/local/bin
ENV PACKER_ZIPFILE=packer_${PACKER_VERSION}_${PACKER_OSNAME}_${PACKER_OSARCH}.zip

# Download Packer
RUN wget -qP ${PACKER_DEST}/ https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_ZIPFILE}

# Unzip Terraform and Remove zip file
RUN unzip ${PACKER_DEST}/${PACKER_ZIPFILE} -d ${PACKER_DEST} \
    && rm -rf ${PACKER_DEST}/${PACKER_ZIPFILE}

###############################
####### ALPINE PACKAGES #######
###############################
# Download Alpine Packages and Remove apk cache
RUN apk add --update py3-pip python3-dev gcc libc-dev libffi-dev \
    && apk add bash openssl ca-certificates jq \
    && rm -rf /var/cache/apk/* 

#######################
####### ANSIBLE #######
#######################
# Set Ansible Variables
ENV ANSIBLE_VERSION=2.9.0
# Install Ansible
RUN pip3 install --no-cache-dir -U ansible==$ANSIBLE_VERSION 

#######################
####### CHECKOV #######
#######################
# Set Checkov Variables
ENV CHECKOV_VERSION=2.1.242
# Install Checkov
RUN pip3 install --no-cache-dir -U checkov==$CHECKOV_VERSION

################################
####### PROJECT SPECIFIC #######
################################
WORKDIR /src
COPY terraform ./terraform
COPY packer ./packer
COPY ansible ./ansible
COPY helpers ./helpers

###########################
####### AZURE LAYER #######
###########################
FROM base as azure

# Set Azure CLI Variables
ENV AZURE_CLI_VERSION=2.43.0
# Install Azure CLI 
RUN pip3 install --no-cache-dir -U azure-cli==$AZURE_CLI_VERSION


#################################
####### ADD NON-ROOT USER #######
#################################
# RUN groupadd --gid 1001 nonroot \
#   # user needs a home folder to store aws credentials
#   && useradd --gid nonroot --create-home --uid 1001 nonroot \
#   && chown nonroot:nonroot /workspace
# USER nonroot

# CMD ["bash"]

#########################
####### AWS LAYER #######
#########################
FROM base as aws

# Set AWS CLI Variables
ENV SETUP_TOOLS=64.0.1
ENV AWS_CLI_VERSION=2.9.2
# Install AWS CLI 
RUN pip3 install --no-cache-dir setuptools==${SETUP_TOOLS} \
    && pip3 install --no-cache-dir awscli==${AWS_CLI_VERSION}

#########################
####### GCP LAYER #######
#########################
FROM base as gcp

# Set Google Cloud Variables
ENV GCLOUD_VERSION=412.0.0 \
    GCLOUD_OSNAME=linux \
    GCLOUD_OSARCH=x86_64 \
    GCLOUD_DEST=/usr/local/bin 
ENV GCLOUD_ZIPFILE=google-cloud-cli-${GCLOUD_VERSION}-${GCLOUD_OSNAME}-${GCLOUD_OSARCH}.tar.gz

# Download Google Cloud
RUN wget -qP "${GCLOUD_DEST}"/ https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_ZIPFILE} \
    && tar xzf ${GCLOUD_DEST}/${GCLOUD_ZIPFILE} -C ${GCLOUD_DEST} \
    && rm ${GCLOUD_DEST}/${GCLOUD_ZIPFILE} \
    && export PATH=$PATH:${GCLOUD_DEST}/google-cloud-sdk/bin

# Add Google Cloud to PATH
ENV PATH ${GCLOUD_DEST}/google-cloud-sdk/bin:$PATH