#!/usr/bin/env sh

if [${DELETE} == "true"]; then
  terraform destroy --auto-approve
  if [ $? == 0 ]; then
    exit 0
  else
    exit 1
  fi
fi

terraform workspace new ${ENV}
if [ $? == 0 ]; then
  terraform ${TF_COMMAND} -auto-approve
else
  terraform select ${ENV}
  terraform ${TF_COMMAND} -auto-approve
fi
