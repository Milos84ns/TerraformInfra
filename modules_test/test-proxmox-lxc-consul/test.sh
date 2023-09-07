#!/bin/bash
#run environment setup if not set
. ../../env.sh

bash remove.sh
terraform init
terraform plan
terraform apply -auto-approve -var-file="vars.tfvars"