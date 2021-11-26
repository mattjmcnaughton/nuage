data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "go_carbon_neutral" {
  name = "${local.name_prefix}-go-carbon-neutral"
  path = "/system/"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = {
    name = "${local.name_prefix}-go-carbon-neutral"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_iam_role_policy_attachment" "attach_go_carbon_neutral_extra_iam_policies" {
  count = length(var.extra_host_iam_policy)
  role = aws_iam_role.go_carbon_neutral.name
  policy_arn = var.extra_host_iam_policy[count.index]
}

resource "aws_iam_instance_profile" "go_carbon_neutral" {
  name = "${local.name_prefix}-go-carbon-neutral-profile"
  role = aws_iam_role.go_carbon_neutral.name
  path = local.iam_default_path
}
