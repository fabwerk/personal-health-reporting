module "service_accounts" {
  source     = "./service_accounts"
  project_id = var.project_id
}

module "bindings" {
  source       = "./bindings"
  project_id   = var.project_id
  bucket_names = var.bucket_names
  dataset_ids  = var.dataset_ids

  cloud_function_sa_email = module.service_accounts.cloud_function_sa_email
  dbt_sa_email            = module.service_accounts.dbt_sa_email
  dagster_sa_email        = module.service_accounts.dagster_sa_email
}
