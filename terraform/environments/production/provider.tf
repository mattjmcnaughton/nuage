provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "p-mattjmcnaughton-tf-storage"
    key     = "nuage"
    region  = "us-east-1"
    encrypt = true
  }
}
