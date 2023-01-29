#!/bin/bash
set -e 

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source "${SCRIPT_DIR}"/_helpers.sh
source "${SCRIPT_DIR}"/cloud-login.sh

# Validate Image ID Provided
if [ -z "$IMAGE_ID" ]; then
    echo "No Image ID or Name provided"
    exit 1
fi

function delete_aws_image() { 
    aws_login

    _information "Deleting AWS AMI $IMAGE_ID..."
    aws ec2 deregister-image --image-id "${IMAGE_ID}"
    _success "Deleted AWS AMI $IMAGE_ID"

    aws_logout
}


function delete_azure_image() {
    azure_login

    _information "Retrieving Azure Shared Image Gallery Details..."
    RESOURCE_GROUP=$(terraform -chdir=terraform/"${1}" output -raw packer_shared_image_gallery_resource_group)
    SHARED_IMAGE_GALLERY=$(terraform -chdir=terraform/"${1}" output -raw packer_shared_image_gallery)
    IMAGE_DEFINITION=$(terraform -chdir=terraform/"${1}" output -raw centos_image_definition)
    _success "Retrieved Azure Shared Image Gallery Details"

    _information "Deleting Azure Image $IMAGE_ID..."
    az sig image-version delete \
        --gallery-image-definition "${IMAGE_DEFINITION}" \
        --gallery-name "${SHARED_IMAGE_GALLERY}" \
        --resource-group "${RESOURCE_GROUP}" \
        --gallery-image-version "${IMAGE_ID}"
    _success "Deleted Azure Image ${IMAGE_ID}"

    azure_logout
}


function delete_gcp_image() {
    gcp_login
    echo 'Y' | gcloud compute images delete "${IMAGE_ID}"
    gcp_logout
}

"$@"
