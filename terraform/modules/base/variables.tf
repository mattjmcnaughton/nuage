variable "vpc_id" {
  description = "The id of the vpc in which we create these security groups"
  type = string
}

variable "public_subnet_ids" {
  description = "The ids of the public subnets in which we will launch the lb."
  type = list(string)
}

variable "environment" {
  description = "The environment in which we are creating these security groups"
  type = string
}
