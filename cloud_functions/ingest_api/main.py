"""Cloud Function entry point for API ingestion using dlt."""

import dlt
import functions_framework
from google.cloud import storage


@functions_framework.http
def ingest_api(request):
    """HTTP Cloud Function that calls the external API and loads raw data via dlt."""
    # TODO: configure dlt pipeline source and destination
    # pipeline = dlt.pipeline(
    #     pipeline_name="ingest_api",
    #     destination="bigquery",
    #     dataset_name="raw",
    # )
    # data = ...  # call external API
    # pipeline.run(data)
    return "OK", 200
