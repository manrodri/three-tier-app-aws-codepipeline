#!/usr/bin/env sh

terraform workspace new ${ENV}
if [ $? -ne 0 ]; then
    terraform workspace select ${ENV}
fi
  terraform validate
  terraform plan -out infra.tfplan

