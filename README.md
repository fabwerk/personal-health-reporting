# Personal Health Reporting

Data engineering pipeline that ingests personal health data from an external API, lands it in Google Cloud Storage, loads it into BigQuery, and transforms it with dbt. Dagster orchestrates the full pipeline. Infrastructure is managed with Terraform.

## Quick Start

```bash
# Install dependencies
uv sync

# Run Dagster locally
uv run dagster dev -m dagster.definitions

# Run dbt
cd dbt && dbt run --profiles-dir .

# Terraform (dev)
cd terraform
terraform init -backend-config=backends/dev.tfbackend
terraform plan -var-file=environments/dev.tfvars
```
