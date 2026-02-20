resource "google_bigquery_dataset" "raw" {
  dataset_id = "raw"
  project    = var.project_id
  location   = var.region
}

resource "google_bigquery_dataset" "staging" {
  dataset_id = "staging"
  project    = var.project_id
  location   = var.region
}

resource "google_bigquery_dataset" "intermediate" {
  dataset_id = "intermediate"
  project    = var.project_id
  location   = var.region
}

resource "google_bigquery_dataset" "marts" {
  dataset_id = "marts"
  project    = var.project_id
  location   = var.region
}
