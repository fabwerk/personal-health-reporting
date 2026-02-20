variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "bucket_names" {
  description = "List of GCS bucket names for IAM bindings"
  type        = list(string)
}

variable "dataset_ids" {
  description = "List of BigQuery dataset IDs for IAM bindings"
  type        = list(string)
}
