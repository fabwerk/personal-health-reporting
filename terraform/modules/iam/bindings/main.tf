# Cloud Function SA: invoke API + write to GCS
resource "google_storage_bucket_iam_member" "cf_raw_writer" {
  for_each = toset(var.bucket_names)
  bucket   = each.value
  role     = "roles/storage.objectCreator"
  member   = "serviceAccount:${var.cloud_function_sa_email}"
}

# dbt SA: read/write BigQuery
resource "google_project_iam_member" "dbt_bq_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.dbt_sa_email}"
}

resource "google_project_iam_member" "dbt_bq_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${var.dbt_sa_email}"
}

# Dagster SA: trigger functions + run dbt
resource "google_project_iam_member" "dagster_cf_invoker" {
  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${var.dagster_sa_email}"
}
