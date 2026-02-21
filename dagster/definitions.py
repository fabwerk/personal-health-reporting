"""Dagster Definitions entry point."""

from dagster import Definitions
from dagster_dbt import DbtCliResource

from dagster.assets.dbt import DBT_PROJECT_DIR, dbt_assets
from dagster.assets.ingestion import ingestion_assets
from dagster.resources.gcp import ENVIRONMENT

defs = Definitions(
    assets=[*ingestion_assets, *dbt_assets],
    resources={
        "dbt": DbtCliResource(
            project_dir=str(DBT_PROJECT_DIR),
            target=ENVIRONMENT,
        ),
    },
)
