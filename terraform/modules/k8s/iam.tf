data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "k8s" {
  name = "${local.name_prefix}-k8s"
  path = "/system/"

  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

  tags = {
    name = "${local.name_prefix}-k8s"
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

resource "aws_iam_policy" "read_write_k8s_admin_conf" {
  name = "${local.name_prefix}-read-write-k8s-admin-conf"
  description = "Read/write access to k8s admin conf"
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
        "arn:aws:s3:::${local.name_prefix}-mattjmcnaughton"
      ]
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${local.name_prefix}-mattjmcnaughton/k8s/admin.conf"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_k8s_access_mattjmcnaughton_com_ssl_certs" {
  role = aws_iam_role.k8s.name
  policy_arn = aws_iam_policy.access_mattjmcnaughton_com_ssl_certs.arn
}

resource "aws_iam_instance_profile" "k8s" {
  name = "${local.name_prefix}-k8s-profile"
  role = aws_iam_role.k8s.name
  path = local.iam_default_path
}
