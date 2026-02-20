resource "google_storage_bucket" "tfstate" {
  name          = "wl-health-${var.env}-tfstate"
  project       = var.project_id
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
