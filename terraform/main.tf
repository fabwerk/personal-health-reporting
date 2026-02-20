module "cloud_storage" {
  source     = "./modules/cloud_storage"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

module "iam" {
  source       = "./modules/iam"
  project_id   = var.project_id
  bucket_names = module.cloud_storage.bucket_names
  dataset_ids  = module.bigquery.dataset_ids
}

module "cloud_functions" {
  source                = "./modules/cloud_functions"
  project_id            = var.project_id
  region                = var.region
  service_account_email = module.iam.cloud_function_sa_email
  raw_bucket_name       = module.cloud_storage.raw_bucket_name
}
