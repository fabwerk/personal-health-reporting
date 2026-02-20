# CLAUDE.md — Project Guide

## Overview

This is a data engineering pet project that ingests data from an external API using dlt, lands it in BigQuery, and transforms it with dbt. Dagster orchestrates the full pipeline. Rill provides local dashboards-as-code. Infrastructure is managed with Terraform.

## Tech Stack

- **Language**: Python 3.12
- **Package manager**: uv
- **Infrastructure**: Terraform (GCP)
- **Orchestration**: Dagster (local for now, GitHub Actions later)
- **Transformation**: dbt-core (via dagster-dbt, no dbt Cloud)
- **Cloud**: Google Cloud Platform (BigQuery, Cloud Storage, Cloud Functions)
- **Ingestion**: dlt (data load tool) with BigQuery destination
- **Dashboard**: Rill Developer (local dev, dashboards-as-code)
- **CI/CD**: GitHub Actions (future)

## GCP Environments

| Environment | GCP Project ID              |
|-------------|-----------------------------|
| dev         | `wl-health-dev`   |
| prod        | `wl-health-prod`  |

## Project Structure

```
.
├── CLAUDE.md
├── .gitignore
├── .python-version                  # 3.12
├── pyproject.toml                   # uv project config, all Python deps
├── uv.lock
├── README.md
│
├── .github/
│   └── workflows/
│       ├── ci.yml                   # lint, test on PR
│       └── deploy.yml               # future: terraform apply + deploy cloud functions
│
├── cloud_functions/
│   └── ingest_api/                  # one folder per function
│       ├── main.py                  # entry point (functions-framework)
│       ├── requirements.txt         # pinned deps for this function only
│       └── tests/
│           └── test_main.py
│
├── dagster/
│   ├── __init__.py
│   ├── definitions.py               # Definitions entry point
│   ├── assets/
│   │   ├── __init__.py
│   │   ├── ingestion.py             # asset that triggers cloud function
│   │   └── dbt.py                   # dbt assets via dagster-dbt
│   ├── resources/
│   │   ├── __init__.py
│   │   └── gcp.py                   # GCS / BigQuery resource configs
│   ├── schedules/
│   │   ├── __init__.py
│   │   └── daily.py
│   └── sensors/
│       └── __init__.py
│
├── dbt/
│   ├── dbt_project.yml
│   ├── packages.yml
│   ├── profiles.yml                 # local dev profiles; CI uses env vars
│   ├── models/
│   │   ├── staging/
│   │   │   ├── _staging__models.yml
│   │   │   └── stg_<source>.sql
│   │   ├── intermediate/
│   │   │   ├── _intermediate__models.yml
│   │   │   └── int_<model>.sql
│   │   └── marts/
│   │       ├── _marts__models.yml
│   │       └── fct_<model>.sql
│   ├── macros/
│   ├── seeds/
│   ├── snapshots/
│   └── tests/
│
├── terraform/
│   ├── main.tf                      # calls all modules, passes vars
│   ├── variables.tf                 # top-level variable declarations
│   ├── outputs.tf
│   ├── providers.tf                 # google provider config
│   ├── versions.tf                  # required_providers + terraform version
│   │
│   ├── backends/
│   │   ├── dev.tfbackend            # bucket = "wl-health-dev-tfstate"
│   │   └── prod.tfbackend           # bucket = "wl-health-prod-tfstate"
│   │
│   ├── environments/
│   │   ├── dev.tfvars
│   │   └── prod.tfvars
│   │
│   └── modules/
│       ├── cloud_storage/
│       │   ├── main.tf              # raw landing bucket, processed bucket
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       ├── bigquery/
│       │   ├── main.tf              # datasets: raw, staging, intermediate, marts
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       ├── cloud_functions/
│       │   ├── main.tf              # function deployment, trigger config
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       ├── iam/
│       │   ├── main.tf              # orchestrates sub-modules
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   ├── service_accounts/
│       │   │   ├── main.tf          # SA for cloud function, dagster, dbt
│       │   │   ├── variables.tf
│       │   │   └── outputs.tf
│       │   └── bindings/
│       │       ├── main.tf          # IAM bindings: SA -> roles on resources
│       │       ├── variables.tf
│       │       └── outputs.tf
│       │
│       └── state_bucket/
│           ├── main.tf              # the tfstate bucket itself
│           ├── variables.tf
│           └── outputs.tf
│
├── rill/
│   ├── rill.yaml                    # Rill project config
│   ├── sources/                     # connector definitions (BigQuery, etc.)
│   ├── models/                      # metrics layer / OLAP models
│   └── dashboards/                  # dashboard YAML definitions
│
└── scripts/                         # utility scripts (future)
```

## Terraform

### Remote State

State is stored in a GCS bucket per environment. The state bucket must be created before running `terraform init` (either manually or via the `state_bucket` module applied separately).

```bash
# Initialize for dev
cd terraform
terraform init -backend-config=backends/dev.tfbackend

# Plan / apply for dev
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

### Service Accounts

Defined in `terraform/modules/iam/service_accounts/`. Expected SAs:

| Service Account        | Purpose                                        |
|------------------------|------------------------------------------------|
| `sa-cloud-function`    | Used by Cloud Function to call API + write GCS |
| `sa-dbt`               | Used by dbt to read/write BigQuery             |
| `sa-dagster`           | Used by Dagster to trigger functions + run dbt |

IAM bindings (which SA gets which roles on which resources) live in `terraform/modules/iam/bindings/`.

### Module Call Pattern

`terraform/main.tf` calls each module and wires outputs between them:

```hcl
module "cloud_storage" {
  source     = "./modules/cloud_storage"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  region     = var.region
  env        = var.env
}

module "iam" {
  source       = "./modules/iam"
  project_id   = var.project_id
  bucket_names = module.cloud_storage.bucket_names
  dataset_ids  = module.bigquery.dataset_ids
}

module "cloud_functions" {
  source                = "./modules/cloud_functions"
  project_id            = var.project_id
  region                = var.region
  service_account_email = module.iam.cloud_function_sa_email
  raw_bucket_name       = module.cloud_storage.raw_bucket_name
}
```

## Dagster

### Running Locally

```bash
# From project root
uv run dagster dev -m dagster.definitions
```

This starts the Dagster webserver (UI) at `http://localhost:3000`. Run metadata is stored locally in SQLite (default, no config needed).

### Asset Graph

```
[ingest_api]  →  [raw GCS file]  →  [BQ external/loaded table]  →  [dbt staging]  →  [dbt intermediate]  →  [dbt marts]
```

- `ingestion.py`: triggers the Cloud Function or calls the API directly, writes to GCS
- `dbt.py`: uses `dagster-dbt` to load dbt models as Dagster assets

### dagster-dbt Integration

dbt models are loaded as Dagster assets via `@dbt_assets`. The dbt project path is `../dbt` relative to the dagster module. Dagster runs `dbt build` using dbt-core — dbt Cloud is not involved.

## dbt

### Target Warehouse

BigQuery. Datasets:
- `raw` — external tables on GCS data
- `staging` — cleaned/renamed models
- `intermediate` — joined/enriched models not exposed to end users
- `marts` — business-ready aggregations

### profiles.yml (local dev)

```yaml
wl_health:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: wl-health-dev
      dataset: staging
      location: EU
    prod:
      type: bigquery
      method: service-account
      project: wl-health-prod
      dataset: staging
      location: EU
```

## Cloud Functions

Each function lives in `cloud_functions/<function_name>/` with its own `requirements.txt` (separate from the main project deps, since Cloud Functions deploy independently).

## Dependency Management

- **Project-level** (dagster, dbt-core, dbt-bigquery, dev tools): managed in `pyproject.toml` via `uv`
- **Cloud Functions**: each has its own `requirements.txt` (deployed independently)

```bash
# Install all project deps
uv sync

# Add a dependency
uv add <package>

# Add a dev dependency
uv add --dev <package>
```

## Key Conventions

- All GCP resource names include the environment suffix: `<name>-dev`, `<name>-prod`
- Terraform state buckets: `wl-health-<env>-tfstate`
- Raw GCS bucket: `wl-health-<env>-raw`
- BigQuery datasets: `raw`, `staging`, `intermediate`, `marts` (separate projects per env, no env suffix needed)
- Service account naming: `sa-<purpose>@<project>.iam.gserviceaccount.com`
- dbt model naming: `stg_<source>__<entity>.sql`, `int_<entity>.sql`, `fct_<entity>.sql`, `dim_<entity>.sql`