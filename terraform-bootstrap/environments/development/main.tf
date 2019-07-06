module "bootstrap" {
  source = "../../modules/bootstrap"

  tf_storage_bucket_name = "d-mattjmcnaughton-tf-storage"
  environment = "development"
}
