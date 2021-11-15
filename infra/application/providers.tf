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
    dynamodb_table = "fastAPICourse/pipeline/terraform.tfstate"
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