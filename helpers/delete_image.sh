#!/bin/bash
set -e 

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source "${SCRIPT_DIR}"/_helpers.sh
source "${SCRIPT_DIR}"/cloud_login.sh

# Validate Image ID Provided
if [ -z "$IMAGE_NAME" ]; then
    echo "No Image Name provided"
    exit 1
fi

function delete_aws_image() { 
    aws_login

    _information "Deleting AWS AMI $IMAGE_NAME..."
    IMAGE_ID=$(aws ec2 describe-images \
                --filters "Name=name,Values=${IMAGE_NAME}" \
                --query "sort_by(Images, &CreationDate)[-1].ImageId" \
                --output text)
    aws ec2 deregister-image --image-id "${IMAGE_ID}"
    _success "Deleted AWS Image $IMAGE_NAME"

    aws_logout
}


function delete_azure_image() {
    azure_login

    _information "Retrieving Azure Shared Image Gallery Details..."
    RESOURCE_GROUP=$(terraform -chdir=terraform/bootstrap/"${1}" output -raw packer_shared_image_gallery_resource_group)
    SHARED_IMAGE_GALLERY=$(terraform -chdir=terraform/bootstrap/"${1}" output -raw packer_shared_image_gallery)
    IMAGE_DEFINITION=$(terraform -chdir=terraform/bootstrap/"${1}" output -raw centos_image_definition)
    _success "Retrieved Azure Shared Image Gallery Details"

    _information "Retrieving Image Version..."
    IMAGE_VERSION=$(az sig image-version list \
                            --gallery-image-definition "${IMAGE_DEFINITION}" \
                            --gallery-name "${SHARED_IMAGE_GALLERY}" \
                            --resource-group "${RESOURCE_GROUP}" \
                            --query "[0].name" \
                            --output tsv)
    _success "Retrieved Image Version: ${IMAGE_NAME}"

    _information "Deleting Azure Image Version $IMAGE_VERSION..."
    az sig image-version delete \
        --gallery-image-definition "${IMAGE_DEFINITION}" \
        --gallery-name "${SHARED_IMAGE_GALLERY}" \
        --resource-group "${RESOURCE_GROUP}" \
        --gallery-image-version "${IMAGE_VERSION}"
    _success "Deleted Azure Image Version ${IMAGE_VERSION}"

    _information "Retrieving Azure Shared Image Gallery Details..."
    RESOURCE_GROUP=$(terraform -chdir=terraform/bootstrap/"${1}" output -raw packer_artifacts_resource_group)
    SHARED_IMAGE_GALLERY=$(terraform -chdir=terraform/bootstrap/"${1}" output -raw packer_shared_image_gallery)
    IMAGE_DEFINITION=$(terraform -chdir=terraform/bootstrap/"${1}" output -raw centos_image_definition)
    _success "Retrieved Azure Shared Image Gallery Details"

    _information "Deleting Image ${IMAGE_NAME}..."
    az image delete --resource-group "${RESOURCE_GROUP}" \
                    --name "${IMAGE_NAME}"
    _success "Deleted Image: ${IMAGE_NAME}"
    
    azure_logout
}


function delete_gcp_image() {
    gcp_login ${TERRAFORM_PATH}
    echo 'Y' | gcloud compute images delete "${IMAGE_NAME}"
    gcp_logout
}

"$@"
