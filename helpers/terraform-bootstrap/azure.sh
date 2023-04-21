#!/bin/bash

set -e 

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source $SCRIPT_DIR/../_helpers.sh

read -p 'TENANT_ID: ' TENANT_ID
read -p 'SUBSCRIPTION_ID: ' SUBSCRIPTION_ID
read -p 'RESOURCE_GROUP: ' RESOURCE_GROUP
read -p 'STORAGE_ACCOUNT_LOCATION (uksouth): ' STORAGE_ACCOUNT_LOCATION
read -p 'STORAGE_ACCOUNT_NAME: ' STORAGE_ACCOUNT_NAME
read -p 'STORAGE_ACCOUNT_SKU (Standard_LRS): ' STORAGE_ACCOUNT_SKU
read -p 'STORAGE_CONTAINER_NAME: ' STORAGE_CONTAINER_NAME
read -p 'SERVICE_PRINCIPAL_NAME: ' SERVICE_PRINCIPAL_NAME
read -p 'TERRAFORM_STATE_NAME: ' TERRAFORM_STATE_NAME
export SUBSCRIPTION_ROLE="Owner"
export GRAPH_API_PERMISSIONS=(
    Directory.ReadWrite.All
    RoleManagement.ReadWrite.Directory
    Application.ReadWrite.OwnedBy
    DelegatedPermissionGrant.ReadWrite.All
    AppRoleAssignment.ReadWrite.All
    Group.ReadWrite.All
    Application.ReadWrite.All
  )


function az_login_user () {
  _information "Creating JSON file for Azure account details..."
  export az_account_details="$HOME/.az_details.json"
  touch "${az_account_details}"
  _success "Created JSON file for Azure account details"

  _information "Prompting Login to Azure..."
  az login --tenant $TENANT_ID | grep -v "Opening in existing browser session.">  "${az_account_details}" 
  _success "Logged into Azure" 

  _information "Setting Azure Subscription ID..."
  az account set -s $SUBSCRIPTION_ID
  _success "Set Azure Subscription ID"
}

function az_login_sp () {
  echo 1
}

function create_resource_group () {
  if [ $(az group exists --name "${RESOURCE_GROUP}") = false ]; then
      _information "Creating Resource Group..."
      az group create \
          --location "${STORAGE_ACCOUNT_LOCATION}" \
          --name "${RESOURCE_GROUP}"
      _success "Created Resource Group"
    else
      _information "Resource Group $RESOURCE_GROUP already exists"
    fi
}

function create_storage_account () {

  STORAGE_ACCOUNT=$(az storage account list \
        --query "[?name == '$STORAGE_ACCOUNT_NAME']" \
        --only-show-errors)

  if [[ "${STORAGE_ACCOUNT}" == "[]" ]]; then
    _information "Creating Storage Account..."
    az storage account create \
        --name "${STORAGE_ACCOUNT_NAME}" \
        --resource-group "${RESOURCE_GROUP}" \
        --location "${STORAGE_ACCOUNT_LOCATION}" \
        --sku "${STORAGE_ACCOUNT_SKU}"
    _success "Created Storage Account"
  fi

  _information "----------------"
  _information "Retrieving Storage Account Key..."
  storage_account_key=$(az storage account keys list \
      --account-name "${STORAGE_ACCOUNT_NAME}" \
      --query "[0].value" \
      -o tsv)
  _success "Retrieved Storage Account Key"
  _information "----------------"

  CONTAINER=$(az storage container list \
    --account-name "${STORAGE_ACCOUNT_NAME}" \
    --account-key "${storage_account_key}" \
    --query "[?name == '$STORAGE_CONTAINER_NAME']")

  if [[ "${CONTAINER}" == "[]" ]]; then
    _information "Creating Storage Account Container..."
    az storage container create \
      --name "${STORAGE_CONTAINER_NAME}" \
      --account-name "${STORAGE_ACCOUNT_NAME}"
    _success "Created Storage Account Container"
  fi
  
}

function create_service_principal () {
  _information "Creating Service Principal..."
  created_service_principal=$(az ad sp create-for-rbac \
      --name "${SERVICE_PRINCIPAL_NAME}" \
      --role "${SUBSCRIPTION_ROLE}" \
      --scopes /subscriptions/"${SUBSCRIPTION_ID}")
  created_app_id=$(echo $created_service_principal | jq -r '.appId')
  created_password=$(echo $created_service_principal | jq -r '.password')
  _success "Created Service Principal"

}

function assign_service_principal_permissions () {

   _information "Retrieving resource ID for Microsoft Graph..."
    GRAPH_API_PERMISSION_ID=$(az ad sp list \
        --query "[?appDisplayName=='Microsoft Graph'].{appId:appId}[0]" \
        --all --only-show-errors | jq -r .appId) && echo "GRAPH_API_PERMISSION_ID: ${GRAPH_API_PERMISSION_ID}"

    RESOURCE_ID=$(az ad sp show --id "${GRAPH_API_PERMISSION_ID}" --query "id" -o tsv) && echo "RESOURCE_ID: ${RESOURCE_ID}"
    _success "Retrieved resource ID for Microsoft Graph"

    _information "Retrieving Service Principal ID..."
    export SERVICE_PRINCIPAL_ID=$(az ad sp list \
      --display-name $SERVICE_PRINCIPAL_NAME \
      --query "[].id" \
      --output tsv \
      --only-show-errors)
    _success "Retrieved Service Principal ID"

    GRAPH_API_PERMISSIONS=("$@")
    for PERMISSION_NAME in "${GRAPH_API_PERMISSIONS[@]}";
      do
          _information "Retrieving App Role ID..."
          API_PERMISSION_ID=$(az ad sp show \
              --id "${GRAPH_API_PERMISSION_ID}" \
              --query "appRoles[?value=='${PERMISSION_NAME}'].id" \
              --output tsv \
              --only-show-errors) && echo "API_PERMISSION_ID: ${API_PERMISSION_ID}" && echo "API_PERMISSION_ID: ${API_PERMISSION_ID}"
          _success "Retrieved App Role ID"

          # GET URI CONSTRUCTORS
          _information "Constructing URI..."
          MICROSOFT_GRAPH_ENDPOINT=$(az cloud show | jq -r ".endpoints.microsoftGraphResourceId") && echo "MICROSOFT_GRAPH_ENDPOINT: ${MICROSOFT_GRAPH_ENDPOINT}"
          LIST_URI=$(echo "${MICROSOFT_GRAPH_ENDPOINT}v1.0/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignments") && echo "LIST_URI: ${LIST_URI}"
          _success "Constructed URI"

          # CHECK IF API PERMISSION EXISTS
          _information "Checking if API permission exists..."
          EXISTING_APP_PERMISSION_ID=$(az rest --method GET --uri ${LIST_URI} \
              --query "value[?appRoleId=='${API_PERMISSION_ID}' && principalId=='${SERVICE_PRINCIPAL_ID}' && resourceId=='${RESOURCE_ID}'].id" -o tsv) &&
              echo "EXISTING_APP_PERMISSION_ID: ${EXISTING_APP_PERMISSION_ID}"
          _success "Checked if API permission exists"

          if [ -z "${EXISTING_APP_PERMISSION_ID}" ]; then
              _information "Assigning API permission..."
              ADD_URI=$(echo "${MICROSOFT_GRAPH_ENDPOINT}v1.0/servicePrincipals/${SERVICE_PRINCIPAL_ID}/appRoleAssignments") && echo "ADD_URI: ${ADD_URI}"

              JSON=$(jq -n \
                  --arg principalId "${SERVICE_PRINCIPAL_ID}" \
                  --arg resourceId "${RESOURCE_ID}" \
                  --arg appRoleId "${API_PERMISSION_ID}" \
                  '{principalId: $principalId, resourceId: $resourceId, appRoleId: $appRoleId}') && echo "JSON: $JSON"

              az rest --method POST --uri $ADD_URI --header Content-Type=application/json --body "$JSON"
              _success "Assigned API permission"
          else
              _information "API permission already granted."
          fi
      done
    
}

function terraform_output () {
  _information "----------------"
  _information "For env.local.sh..."
  echo "export ARM_CLIENT_ID=$created_app_id"
  echo "export ARM_CLIENT_SECRET=$created_password"
  echo "export ARM_TENANT_ID=$TENANT_ID"
  echo "export ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
  echo "export ARM_ACCESS_KEY=$storage_account_key"
  _information "----------------"

  _information "----------------"
  _information "For backend.tf..."
  cat << EndOfMessage
terraform {
  backend "azurerm" {
    resource_group_name  = "$RESOURCE_GROUP"
    storage_account_name = "$STORAGE_ACCOUNT_NAME"
    container_name       = "$STORAGE_CONTAINER_NAME"
    key                  = "$TERRAFORM_STATE_NAME"
  }
}
EndOfMessage
  _information "----------------"
}

function delete_resource_group () {
  _information "Deleting Resource Group..."
  az group delete \
        --name $RESOURCE_GROUP \
        --yes
  _success "Deleted Resource Group"
}

function delete_service_principal () {
    _information "Retrieving Service Principal ID..."
    export SERVICE_PRINCIPAL_ID=$(az ad sp list \
      --display-name $SERVICE_PRINCIPAL_NAME \
      --query "[].id" \
      --output tsv \
      --only-show-errors)
    _success "Retrieved Service Principal ID"

    _information "Deleting Service Principal..."
    az ad sp delete --id $SERVICE_PRINCIPAL_ID
    _success "Deleted Service Principal"
}


function create () {
  az_login_user
  create_resource_group
  create_storage_account
  create_service_principal
  assign_service_principal_permissions "${GRAPH_API_PERMISSIONS[@]}"
  terraform_output
  az logout
}

function destroy () {
  az_login_user
  delete_resource_group
  delete_service_principal
  az logout
}

"$@"

