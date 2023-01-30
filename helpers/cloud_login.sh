#!/bin/bash

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source $SCRIPT_DIR/_helpers.sh

function aws_login() {
    _information "Logging out of AWS..."
    rm ~/.aws/credentials || true
    _success "Logged out of AWS"

    _information "Logging into AWS..."
    aws configure set aws_access_key_id $PKR_VAR_AWS_ACCESS_KEY; aws configure set aws_secret_access_key $PKR_VAR_AWS_SECRET_KEY;
    _success "Logged into AWS"
}

function azure_login() {
    _information "Logging out of Azure..."
    az logout || true 
    _success "Logged out of Azure"

    _information "Logging into Azure..."
    az login --service-principal \
        --username=$PKR_VAR_AZURE_CLIENT_ID \
        --password=$PKR_VAR_AZURE_CLIENT_SECRET \
        --tenant $PKR_VAR_AZURE_TENANT_ID
    
     az account set -s $PKR_VAR_AZURE_SUBSCRIPTION_ID
    _success "Logged into Azure"
}

function gcp_login () {
    _information "Logging out of GCP..."
    gcloud auth revoke $GOOGLE_CLIENT_EMAIL || true
    _success "Logged out of GCP"

    _information "Logging into GCP..."
    gcloud auth activate-service-account --key-file=$PWD/$GOOGLE_APPLICATION_CREDENTIALS_FULL_PATH
    _success "Logged into GCP"
}

function azure_logout() {
    _information "Logging out of Azure..."
    az logout || true
    _success "Logged out of Azure"
}

function aws_logout() {
    _information "Logging out of AWS..."
    rm ~/.aws/credentials || true
    _success "Logged out of AWS"
}

function gcp_logout() {
    _information "Logging out of GCP..."
    gcloud auth revoke $GOOGLE_CLIENT_EMAIL || true
    _success "Logged out of GCP"
}
