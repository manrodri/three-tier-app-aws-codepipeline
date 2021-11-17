#!/usr/bin/env sh
echo "Running: terraform apply infra.tfplan"
terraform apply infra.tfplan
retVal=$?
if [ $retVal -ne 0 ]; then
  echo "Terraform apply exit value === $retVal"
  exit 0
else
  echo "Terraform apply exit value === $retVal"
  echo "Running: terraform destroy --auto-approve"
  terraform destroy --auto-approve
fi

