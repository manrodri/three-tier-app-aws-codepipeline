variable "profile" {
  type = string
  default = "devops"
}
variable "region" {
  type = string
  default = "eu-west-1"
}

// networking
variable "cidr_block" {
  type = map(string)
}

variable "subnet_count" {
  type = map(number)
}

variable "private_subnets" {
  type = map(list(string))
}

variable "public_subnets" {
  type = map(list(string))
}

locals {
  common_tags = {
    environment = terraform.workspace
    team = "Cloud and Hosting"
    project_name = "demo-project"
  }
}