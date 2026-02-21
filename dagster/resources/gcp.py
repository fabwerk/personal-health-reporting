"""GCP resource configurations for Dagster."""

import os

ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")
GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID", f"wl-health-{ENVIRONMENT}")
GCP_REGION = os.getenv("GCP_REGION", "us-central1")

GCS_BUCKET_RAW = f"wl-health-{ENVIRONMENT}-raw"
GCS_BUCKET_PROCESSED = f"wl-health-{ENVIRONMENT}-processed"
