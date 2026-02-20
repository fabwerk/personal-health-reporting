resource "google_storage_bucket" "raw" {
  name          = "wl-health-${var.env}-raw"
  project       = var.project_id
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "processed" {
  name          = "wl-health-${var.env}-processed"
  project       = var.project_id
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true
}
