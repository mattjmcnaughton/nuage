# TODO: We currently hard code this IAM configuration for just the vidzou. But in the
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

resource "aws_iam_role" "vidzou" {
  name = "${local.name_prefix}-vidzou"
  path = "/system/"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = {
    name = "${local.name_prefix}-vidzou"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_iam_policy" "read_write_vidzou_bucket" {
  name = "${local.name_prefix}-read-write-vidzou-bucket"
  description = "Allow read/write in bucket where we store vidzou content"
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
        "arn:aws:s3:::${local.vidzou_bucket}"
      ]
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${local.vidzou_bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy" "read_vidzou_htpasswd" {
  name = "${local.name_prefix}-vidzou-htpasswd"
  description = "Allow access to vidzou htpasswd"
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
        "arn:aws:s3:::g-mattjmcnaughton/htpasswd/vidzou.htpasswd"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_vidzou_read_write_vidzou_bucket" {
  role = aws_iam_role.vidzou.name
  policy_arn = aws_iam_policy.read_write_vidzou_bucket.arn
}

resource "aws_iam_role_policy_attachment" "attach_vidzou_read_vidzou_htpasswd" {
  role = aws_iam_role.vidzou.name
  policy_arn = aws_iam_policy.read_vidzou_htpasswd.arn
}

resource "aws_iam_role_policy_attachment" "attach_vidzou_extra_iam_policies" {
  count = length(var.extra_host_iam_policy)
  role = aws_iam_role.vidzou.name
  policy_arn = var.extra_host_iam_policy[count.index]
}

resource "aws_iam_instance_profile" "vidzou" {
  name = "${local.name_prefix}-vidzou-profile"
  role = aws_iam_role.vidzou.name
  path = local.iam_default_path
}
