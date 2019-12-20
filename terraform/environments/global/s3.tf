resource "aws_s3_bucket" "g-mattjmcnaughton" {
  bucket = "g-mattjmcnaughton"
  acl = "private"

  tags = {
    Name = "g-mattjmcnaughton"
    name = "g-mattjmcnaughton"
    environment = "global"
    Terraform = "true"
    project = "nuage"
  }
}
