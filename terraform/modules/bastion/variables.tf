variable "vpc_id" {
  description = "The id of the vpc in which we create these security groups"
  type = string
}

variable "public_subnet_ids" {
  # We pass these values explicitly as a variable so terraform knows that the
  # `vpc` must succeed in creating them before it can create the `bastion` host.
  description = "The ids of the public subnets in which we will launch the bastion hosts."
  type = list(string)
}

variable "environment" {
  description = "The environment in which we are creating these security groups"
  type = string
}

variable "aws_key_pair_key_name" {
  description = "The key pair used to launch the bastion host"
  default = "mattjmcnaughton_personal_rsa"
  type = string
}
