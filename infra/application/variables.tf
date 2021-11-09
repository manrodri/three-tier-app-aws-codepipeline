variable "profile" {
  type    = string
  default = "devops"
}
variable "region" {
  type    = string
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
    environment  = terraform.workspace
    team         = "Cloud and Hosting"
    project_name = "demo-project"
  }
}

######
# dns
######
variable "demo_dns_zone" {
  type = string
  default = "manrodri.com"

}

variable "demo_dns_name" {
  type = string
  default = "myapp"
}



####
# compute
####

variable "ip_range" {
  default = "0.0.0.0/0"
}

variable "asg_instance_size" {
  type = map(string)
}

variable "asg_max_size" {
  type = map(number)
}
variable "asg_min_size" {
  type = map(number)
}

variable "key" {
  type = string
}
