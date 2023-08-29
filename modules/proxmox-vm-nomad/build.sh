#!/bin/bash
#run environment setup if not set
. ../../env.sh


bash remove.sh
terraform init
terraform plan -var-file="vars.tfvars"
terraform apply -auto-approve -var-file="vars.tfvars"