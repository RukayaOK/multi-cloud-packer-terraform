#!/bin/bash 

# MAKEFILE 
export CLOUD="" # options: azure aws gcp
export RUNTIME_ENV="" # options: local container
export IMAGE="" # options: nginx

# GITHUB
export GITHUB_TOKEN="" 

# AZURE TERRAFORM
export ARM_CLIENT_ID=""
export ARM_CLIENT_SECRET=""
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""
export ARM_ACCESS_KEY=""

# AZURE PACKER 
export PKR_VAR_AZURE_CLIENT_ID=""
export PKR_VAR_AZURE_CLIENT_SECRET=""
export PKR_VAR_AZURE_SUBSCRIPTION_ID=""
export PKR_VAR_AZURE_TENANT_ID=""

# AWS TERRAFORM
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

# AWS PACKER 
export PKR_VAR_AWS_ACCESS_KEY=""
export PKR_VAR_AWS_SECRET_KEY=""

# CLOUDFLARE
export CLOUDFLARE_API_TOKEN=""
export CLOUDFLARE_EMAIL=""
export TF_VAR_CLOUDFLARE_ZONE_ID=""