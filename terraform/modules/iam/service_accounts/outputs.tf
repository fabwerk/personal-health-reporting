output "cloud_function_sa_email" {
  description = "Email of the Cloud Function service account"
  value       = google_service_account.cloud_function.email
}

output "dbt_sa_email" {
  description = "Email of the dbt service account"
  value       = google_service_account.dbt.email
}

output "dagster_sa_email" {
  description = "Email of the Dagster service account"
  value       = google_service_account.dagster.email
}
