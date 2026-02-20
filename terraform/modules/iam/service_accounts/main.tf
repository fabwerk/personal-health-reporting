resource "google_service_account" "cloud_function" {
  account_id   = "sa-cloud-function"
  display_name = "Cloud Function SA"
  project      = var.project_id
}

resource "google_service_account" "dbt" {
  account_id   = "sa-dbt"
  display_name = "dbt SA"
  project      = var.project_id
}

resource "google_service_account" "dagster" {
  account_id   = "sa-dagster"
  display_name = "Dagster SA"
  project      = var.project_id
}
