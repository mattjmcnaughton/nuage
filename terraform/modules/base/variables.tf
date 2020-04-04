variable "vpc_id" {
  description = "The id of the vpc in which we create these security groups"
  type = string
}

variable "environment" {
  description = "The environment in which we are creating these security groups"
  type = string
}
