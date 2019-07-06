resource "aws_s3_bucket" "tf_storage" {
  bucket = var.tf_storage_bucket_name
  acl = "private"

  tags = {
    Name = var.tf_storage_bucket_name
    name = var.tf_storage_bucket_name
    environment = var.environment
    project = "cloud-foundation"
  }
}
