output "raw_bucket_name" {
  description = "Name of the raw landing GCS bucket"
  value       = module.cloud_storage.raw_bucket_name
}

output "cloud_function_sa_email" {
  description = "Email of the Cloud Function service account"
  value       = module.iam.cloud_function_sa_email
}
