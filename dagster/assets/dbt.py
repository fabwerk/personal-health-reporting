"""dbt assets loaded via dagster-dbt."""

from pathlib import Path

from dagster_dbt import DbtCliResource, dbt_assets

DBT_PROJECT_DIR = Path(__file__).resolve().parents[2] / "dbt"

dbt_resource = DbtCliResource(project_dir=str(DBT_PROJECT_DIR))

# Generate the dbt manifest for asset loading
dbt_manifest_path = DBT_PROJECT_DIR / "target" / "manifest.json"


@dbt_assets(manifest=dbt_manifest_path)
def all_dbt_assets(context, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()


dbt_assets = [all_dbt_assets]
