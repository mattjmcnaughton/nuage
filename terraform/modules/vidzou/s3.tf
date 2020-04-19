resource "aws_s3_bucket" "vidzou_log_bucket" {
  bucket = "${local.vidzou_bucket}-logs"
  acl = "log-delivery-write"

  tags = {
    Name = "${local.vidzou_bucket}-logs"
    name = "${local.vidzou_bucket}-logs"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_s3_bucket" "vidzou_bucket" {
  bucket = local.vidzou_bucket
  acl = "private"

  logging {
    target_bucket = aws_s3_bucket.vidzou_log_bucket.id
    target_prefix = "log/"
  }

  tags = {
    Name = local.vidzou_bucket
    name = local.vidzou_bucket
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
