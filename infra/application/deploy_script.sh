#!/usr/bin/env sh
echo "Running ----> terraform apply infra.tfplan"
terraform apply infra.tfplan
if [ $? -eq 0 ]; then
  exit 0
else
  echo "Running ----> terraform destroy --auto-approve"
  terraform destroy --auto-approve
fi

