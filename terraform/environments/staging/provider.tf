provider "aws" {
  region = "us-east-1"
  version = ">= 2.23.0"
}

terraform {
  backend "s3" {
    bucket = "s-mattjmcnaughton-tf-storage"
    key = "nuage"
    region = "us-east-1"
    encrypt = true
  }
}
