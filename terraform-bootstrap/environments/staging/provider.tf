provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = ">= 2.0.0"
  }
}
