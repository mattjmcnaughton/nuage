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

# TODO: We will DEFINITELY want to extract this component.
resource "aws_iam_policy" "access_mattjmcnaughton_com_ssl_certs" {
  name = "${local.name_prefix}-access-ssl-certs"
  description = "Allow access to mattjmcnaughton.com ssl certs"
  path = local.iam_default_path

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::g-mattjmcnaughton"
      ]
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::g-mattjmcnaughton/ssl/mattjmcnaughton.com/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_blog_access_mattjmcnaughton_com_ssl_certs" {
  role = aws_iam_role.blog.name
  policy_arn = aws_iam_policy.access_mattjmcnaughton_com_ssl_certs.arn
}

resource "aws_iam_instance_profile" "blog" {
  name = "${local.name_prefix}-blog-profile"
  role = aws_iam_role.blog.name
  path = local.iam_default_path
}
