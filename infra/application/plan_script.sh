#!/usr/bin/env sh

terraform workspace new ${ENV}
if [ $? == 0 ]; then
  terraform ${TF_COMMAND} -auto-approve
else
  terraform workspace select ${ENV}
  terraform ${TF_COMMAND} -out infra.tfplan
fi
