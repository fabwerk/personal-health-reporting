variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "bucket_names" {
  description = "List of GCS bucket names"
  type        = list(string)
}

variable "dataset_ids" {
  description = "List of BigQuery dataset IDs"
  type        = list(string)
}

variable "cloud_function_sa_email" {
  description = "Cloud Function service account email"
  type        = string
}

variable "dbt_sa_email" {
  description = "dbt service account email"
  type        = string
}

variable "dagster_sa_email" {
  description = "Dagster service account email"
  type        = string
}
