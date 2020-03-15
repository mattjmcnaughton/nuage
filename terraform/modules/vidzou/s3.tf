resource "aws_s3_bucket" "vidzou_bucket" {
  bucket = local.vidzou_bucket
  acl = "private"

  tags = {
    Name = local.vidzou_bucket
    name = local.vidzou_bucket
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
