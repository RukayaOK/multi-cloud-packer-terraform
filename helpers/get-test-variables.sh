#!/bin/bash

# Global Variables
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Includes
source "${SCRIPT_DIR}"/_helpers.sh


function get_public_ip() {
    _information "Retrieving ${1} Public IP address..."
    PUBLIC_IP_ADDRESS=$(terraform -chdir=terraform/tests/"${1}" output -raw public_ip)
    echo "${1}_IP_ADDRESS=${PUBLIC_IP_ADDRESS}"
    _success "Retrieved ${1} Public IP address"
}

"$@"
