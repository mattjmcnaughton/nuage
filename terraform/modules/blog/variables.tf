variable "vpc_id" {
  description = "The id of the vpc in which we create these security groups"
  type = string
}

variable "public_subnet_ids" {
  # We pass these values explicitly as a variable so terraform knows that the
  # `vpc` must succeed in creating them before it can create the host.
  description = "The ids of the public subnets in which we will launch the host."
  type = list(string)
}

variable "environment" {
  description = "The environment in which we are creating these security groups"
  type = string
}

variable "extra_host_iam_policy" {
  description = "The additional iam policies we want to add to the host"
  type = list(string)
}

variable "extra_host_security_groups" {
  description = "The additional security groups we want to add to the host"
  type = list(string)
}

variable "extra_elb_security_groups" {
  description = "The additional security groups we want to add to the elb"
  type = list(string)
}

variable "aws_key_pair_key_name" {
  description = "The key pair used to launch the host"
  default = "mattjmcnaughton_personal_rsa"
  type = string
}

variable "additional_alias_records_for_elb" {
  description = "Additional alias records for which we want to redirect the elb."
  type = list(string)
  default = []
}
