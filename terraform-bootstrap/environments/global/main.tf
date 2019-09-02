module "bootstrap" {
  source = "../../modules/bootstrap"

  tf_storage_bucket_name = "g-mattjmcnaughton-tf-storage"
  environment = "global"
}
