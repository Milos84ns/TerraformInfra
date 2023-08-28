#!/bin/bash

echo 'Setting up proxmox credentials'
export TF_VAR_proxmox_api_token= # add token created with api user
export TF_VAR_proxmox_api_url= # add link https://<proxmox_ip>:8006/api2/json;
export TF_VAR_proxmox_api_user= # add  api user example user@pam!Terraform

#create images dir
mkdir -p /tmp/images
