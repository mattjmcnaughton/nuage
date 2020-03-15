locals {
  name_prefix = substr(var.environment, 0, 1)
  iam_default_path = "/system/"
  vidzou_bucket = "${local.name_prefix}-mattjmcnaughton-vidzou"
}
