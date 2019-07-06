module "bootstrap" {
  source = "../../modules/bootstrap"

  tf_storage_bucket_name = "s-mattjmcnaughton-tf-storage"
  environment = "staging"
}
