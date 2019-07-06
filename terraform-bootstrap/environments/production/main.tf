module "bootstrap" {
  source = "../../modules/bootstrap"

  tf_storage_bucket_name = "p-mattjmcnaughton-tf-storage"
  environment = "production"
}
