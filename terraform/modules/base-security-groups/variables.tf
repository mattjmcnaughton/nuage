variable "vpc_id" {
  description = "The id of the vpc in which we create these security groups"
  type = string
}

variable "name_prefix" {
  # TODO(mattjmcnaughton) Can we determine this value dynamically based on the
  # `environment` variable?
  description = "The prefix which we will add to all names"
  type = string
}

variable "environment" {
  description = "The environment in which we are creating these security groups"
  type = string
}
