# TODO: We currently hard code this IAM configuration for just the blog. But in the
# future, we should extract.
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "blog" {
  name = "${local.name_prefix}-blog"
  path = "/system/"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = {
    name = "${local.name_prefix}-blog"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_iam_role_policy_attachment" "attach_blog_extra_iam_policies" {
  count = length(var.extra_host_iam_policy)
  role = aws_iam_role.blog.name
  policy_arn = var.extra_host_iam_policy[count.index]
}

resource "aws_iam_instance_profile" "blog" {
  name = "${local.name_prefix}-blog-profile"
  role = aws_iam_role.blog.name
  path = local.iam_default_path
}
