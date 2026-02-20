output "dataset_ids" {
  description = "List of all BigQuery dataset IDs"
  value = [
    google_bigquery_dataset.raw.dataset_id,
    google_bigquery_dataset.staging.dataset_id,
    google_bigquery_dataset.intermediate.dataset_id,
    google_bigquery_dataset.marts.dataset_id,
  ]
}
