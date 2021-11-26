terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}