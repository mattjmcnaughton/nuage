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

variable "main_aws_lb_listener_https_arn" {
  description = "Arn for main aws lb https listener"
  type = string
}

variable "main_aws_lb_dns_name" {
  description = "The dns name for our main aws lb"
  type = string
}

variable "main_aws_lb_zone_id" {
  description = "The zone id for the main aws lb"
  type = string
}

variable "extra_lb_target_groups" {
  description = "Extra lb target groups with which to register our asg instances"
  type = list(string)
  default = []
}

variable "aws_key_pair_key_name" {
  description = "The key pair used to launch the host"
  default = "mattjmcnaughton_personal_rsa"
  type = string
}

variable "additional_alias_records_for_lb" {
  description = "Additional alias records for which we want to redirect the lb."
  type = list(string)
  default = []
}
