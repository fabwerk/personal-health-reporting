variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "service_account_email" {
  description = "Service account email for the Cloud Function"
  type        = string
}

variable "raw_bucket_name" {
  description = "Name of the raw GCS bucket"
  type        = string
}
