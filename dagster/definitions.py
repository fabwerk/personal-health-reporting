"""Dagster Definitions entry point."""

from dagster import Definitions

from dagster.assets.dbt import dbt_assets
from dagster.assets.ingestion import ingestion_assets

defs = Definitions(
    assets=[*ingestion_assets, *dbt_assets],
)
