terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    encrypt = true
    bucket = "manrodri.com-terraform"
    key = "terraform.tfstate"
    workspace_key_prefix = "fastAPICourse/pipeline/development"
    dynamodb_table = "terraform-state-lock-dynamo"
    region = "eu-west-1"
  }

}

provider "aws" {
  region = var.region
}


provider "aws" {
  //  certificate must be in us-east-1 to be used by cloudfront
  alias   = "acm_provider"
  region  = "us-east-1"
}