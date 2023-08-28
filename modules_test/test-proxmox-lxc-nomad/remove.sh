#!/bin/bash
#run environment setup if not set
. ../../env.sh

terraform  destroy -auto-approve -var-file="vars.tfvars"