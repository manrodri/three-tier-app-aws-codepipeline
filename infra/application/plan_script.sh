#!/usr/bin/env sh

terraform workspace new ${ENV}
retVal=$?
if [ $retVal -ne 0 ]; then
    terraform workspace select ${ENV}
    terraform ${TF_COMMAND} -out infra.tfplan
else
  terraform ${TF_COMMAND} -auto-approve
fi

