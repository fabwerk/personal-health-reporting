output "cloud_function_sa_email" {
  description = "Email of the Cloud Function service account"
  value       = module.service_accounts.cloud_function_sa_email
}

output "dbt_sa_email" {
  description = "Email of the dbt service account"
  value       = module.service_accounts.dbt_sa_email
}

output "dagster_sa_email" {
  description = "Email of the Dagster service account"
  value       = module.service_accounts.dagster_sa_email
}
