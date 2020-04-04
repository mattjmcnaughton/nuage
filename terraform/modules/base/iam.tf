resource "aws_iam_policy" "access_mattjmcnaughton_ssl_certs" {
  name = "${local.name_prefix}-access-ssl-certs"
  description = "Allow access to mattjmcnaughton.(com|io) ssl certs"
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
        "arn:aws:s3:::g-mattjmcnaughton/ssl/mattjmcnaughton.com/*",
        "arn:aws:s3:::g-mattjmcnaughton/ssl/mattjmcnaughton.io/*"
      ]
    }
  ]
}
EOF
}
