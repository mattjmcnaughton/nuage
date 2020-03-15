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

# TODO: Need to create a policy for retrieving the `.htaccess`...

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

resource "aws_iam_role_policy_attachment" "attach_vidzou_access_mattjmcnaughton_com_ssl_certs" {
  role = aws_iam_role.vidzou.name
  policy_arn = aws_iam_policy.access_mattjmcnaughton_com_ssl_certs.arn
}

resource "aws_iam_role_policy_attachment" "attach_vidzou_read_write_vidzou_bucket" {
  role = aws_iam_role.vidzou.name
  policy_arn = aws_iam_policy.read_write_vidzou_bucket.arn
}

resource "aws_iam_instance_profile" "vidzou" {
  name = "${local.name_prefix}-vidzou-profile"
  role = aws_iam_role.vidzou.name
  path = local.iam_default_path
}
