#!/bin/bash
set -e 

# Helpers
wipe="\033[1m\033[0m"

_information() {
    _color='\033[0;35m' #cyan
    echo "${_color} $1 ${wipe}"
}

_success() {
    _color='\033[0;32m' #green
    echo "${_color} $1 ${wipe}"
}

_information "Updating Machine..."
yum -y update
yum -y install epel-release
_success "Updated Machine"

_information "Installing NGINX..."
yum -y install nginx
_success "Installed NGINX"

_information "Enabling NGINX..."
systemctl daemon-reload
systemctl enable nginx.service
_success "Enabled NGINX"
