#!/usr/bin/env sh
terraform apply infra.tfplan
retVal=$?
if [ $retVal -ne 0 ]; then
  exit 0
else
  terraform destroy --auto-approve
fi

