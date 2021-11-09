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
  region = var.region
  profile = var.profile
  alias = "dns"
}

provider "aws" {
  //  certificate must be in us-east-1 to be used by cloudfront
  alias   = "acm_provider"
  profile = var.profile
  region  = "us-east-1"
}