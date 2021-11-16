#!/usr/bin/env sh
cd infra/application

terraform apply infra.tfplan
if [ $? == 0 ]; then
  exit 0
else
  terraform destroy --auto-approve
fi

