variable "tf_storage_bucket_name" {
  description = "The name of the s3 bucket in which we'll store tf state"
  type = string
}

variable "environment" {
  description = "The environment in which we are creating this resource"
  type = string
}
