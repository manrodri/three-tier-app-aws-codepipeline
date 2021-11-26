#!/bin/bash
if [[ $DELETE == 'true' ]] ; then
  echo "Running ----> terraform destroy --auto-approve"
  terraform init -migrate-state
  terraform destroy --auto-approve
  exit 0
fi
echo "Running ----> terraform apply infra.tfplan"
terraform apply infra.tfplan
if [ $? -eq 0 ]; then
  exit 0
else
  echo "Running ----> terraform destroy --auto-approve"
  terraform init -migrate-state
  terraform destroy --auto-approve
fi

