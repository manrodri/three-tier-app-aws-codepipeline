# Build Infrastructure with Terraform in a CI/CD pipeline

## Tools

* CI/CD: AWS CODEPIPELINE
* Terraform backend: S3/DynamoDB
* Code repository: GitHub

We are building an Python API in AWS cloud.

## CI/CD infrastructure

### Bucket

* ARN: arn:aws:s3:::manrodri.com-terraform
* Region: eu-west-1

### DynamoDB table

* name:  	terraform-state-lock-dynamo
* region: eu-west-1
* capacity units: 1 read and 1 write
* Primary key:  LockID
* Sort key : none


### Pipeline

* ARN: arn:aws:codepipeline:eu-west-1:423754860743:myPipeline
* Service role: arn:aws:iam::423754860743:role/service-role/AWSCodePipelineServiceRole-eu-west-1-myPipeline
* Region: eu-west-1

#### Environment variables

TF_COMMAND: apply
ENV: development

