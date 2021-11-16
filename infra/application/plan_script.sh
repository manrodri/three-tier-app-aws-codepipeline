#!/usr/bin/env sh

terraform workspace new ${ENV}
retVal=$?
if [ $retVal -ne 0 ]; then
    terraform workspace select ${ENV}
    terraform plan -out infra.tfplan
else
  terraform plan -auto-approve
fi

