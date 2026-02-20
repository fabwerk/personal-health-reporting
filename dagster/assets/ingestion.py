"""Assets for API ingestion via dlt."""

from dagster import asset

ingestion_assets = []


@asset
def raw_api_data():
    """Run the dlt pipeline to ingest data from the external API into BigQuery."""
    # TODO: configure dlt pipeline
    # import dlt
    # pipeline = dlt.pipeline(
    #     pipeline_name="ingest_api",
    #     destination="bigquery",
    #     dataset_name="raw",
    # )
    # data = ...  # call external API
    # pipeline.run(data)
    pass


ingestion_assets.append(raw_api_data)
