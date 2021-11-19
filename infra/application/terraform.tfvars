region = "eu-west-1"

subnet_count = {
  "development" = 2,
  "no-ssl" = 2,
  "staging" = 2,
  "production" = 3
}

cidr_block = {
  "development" = "10.0.0.0/16",
   "no-ssl" = "10.0.0.0/16",
  "staging" = "10.1.0.0/16",
  "production" = "10.2.0.0/16"
}

public_subnets = {
  "development" = [
    "10.0.1.0/24",
    "10.0.2.0/24"],
  "production" = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24"
  ],
  "no-ssl" = [
    "10.0.1.0/24",
    "10.0.2.0/24"]

  "staging" = [
    "10.1.1.0/24",
    "10.1.2.0/24"],
}

private_subnets = {
  "development" = [
    "10.0.3.0/24",
    "10.0.4.0/24"],
  "no-ssl" = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ],
  "production" = [
    "10.2.5.0/24",
    "10.2.4.0/24",
    "10.2.6.0/24"
  ],
  "staging" = [
    "10.1.3.0/24",
    "10.1.4.0/24"],
}


#########
# compute
#########

asg_instance_size = {
  "development" = "t2.micro",
  "no-ssl": "t2.micro",
  "staging" = "t2.micro",
  "production" = "t2.micro"
}


asg_max_size = {
  "development" = 3,
  "no-ssl" = 3,
  "staging" = 6,
  "production" = 6
}

asg_min_size = {
  "development" = 1,
  "no-ssl" = 1,
  "staging" = 3,
  "production" = 3
}

key = "devops"
