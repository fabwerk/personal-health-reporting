# TODO: configure Cloud Function deployment
# This will deploy the ingest_api function with an HTTP trigger

# resource "google_cloudfunctions2_function" "ingest_api" {
#   name     = "ingest-api"
#   project  = var.project_id
#   location = var.region
#
#   build_config {
#     runtime     = "python312"
#     entry_point = "ingest_api"
#     source {
#       storage_source {
#         bucket = var.raw_bucket_name
#         object = "cloud-functions/ingest_api.zip"
#       }
#     }
#   }
#
#   service_config {
#     service_account_email = var.service_account_email
#   }
# }
