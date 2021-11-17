#!/usr/bin/env sh
echo "Running ----> terraform apply infra.tfplan"
terraform apply infra.tfplan
retVal=$?
if [ $? -e 0 ]; then
  exit 0
else
  echo "Running ----> terraform destroy --auto-approve"
  terraform destroy --auto-approve
fi

