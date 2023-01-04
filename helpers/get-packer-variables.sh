#!/bin/bash

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source $SCRIPT_DIR/_helpers.sh


function get_azure_packer_variables() {
    _information "Retrieving variables for Azure Packer..."
    PKR_VAR_AZURE_CLIENT_ID=$(terraform -chdir=terraform/${1} output -raw packer_client_id)
    PKR_VAR_AZURE_CLIENT_SECRET=$(terraform -chdir=terraform/${1} output -raw packer_client_secret)
    echo "export PKR_VAR_AZURE_CLIENT_ID=${PKR_VAR_AZURE_CLIENT_ID}"
    echo "export PKR_VAR_AZURE_CLIENT_SECRET=${PKR_VAR_AZURE_CLIENT_SECRET}"
    echo "export PKR_VAR_AZURE_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}"
    echo "export PKR_VAR_AZURE_TENANT_ID=${ARM_TENANT_ID}"
    _success "Retrieved variables for Azure Packer"
}

function get_aws_packer_variables() {
    _information "Retrieving variables for AWS Packer..."
    PKR_VAR_AWS_ACCESS_KEY=$(terraform -chdir=terraform/${1} output -raw packer_access_key)
    PKR_VAR_AWS_SECRET_KEY=$(terraform -chdir=terraform/${1} output -raw packer_secret_key)
    echo "export PKR_VAR_AWS_ACCESS_KEY=${PKR_VAR_AWS_ACCESS_KEY}"
    echo "export PKR_VAR_AWS_SECRET_KEY=${PKR_VAR_AWS_SECRET_KEY}"
    _success "Retrieved variables for AWS Packer"
}

function get_gcp_packer_variables() {
    _information "Retrieving variables for GCP Packer..."
    terraform -chdir=terraform/${1} output -raw packer_private_key | base64 --decode > packer/auth.json
    echo "export PKR_VAR_GCP_ACCOUNT_CREDENTIALS=./packer/auth.json"
    _success "Retrieved variables for GCP Packer"
}


"$@"
