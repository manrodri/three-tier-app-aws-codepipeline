terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
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