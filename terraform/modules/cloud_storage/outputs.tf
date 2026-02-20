output "raw_bucket_name" {
  description = "Name of the raw landing bucket"
  value       = google_storage_bucket.raw.name
}

output "bucket_names" {
  description = "List of all bucket names"
  value       = [google_storage_bucket.raw.name, google_storage_bucket.processed.name]
}
