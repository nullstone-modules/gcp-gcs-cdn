# gcp-gcs-cdn

Creates a Content Distribution Network (CDN) for a Nullstone static site that is hosted using Google Cloud Storage.
This adds a security layer and caching for serving static assets.

## Subdomain connection

This module requires connection a subdomain.
The subdomain address is automatically connected to the created Cloud CDN.

## HTTPS

This connection is also used to create an HTTPS connection.
The CDN is configured to redirect HTTP:80 traffic to HTTPS:443 by serving HTTP traffic with `HTTP 301 (Moved Permanently)`.

## Versioned Assets

For a static site that has versioned assets enabled, the assets for each code version are stored in a directory within Google Cloud Storage.
This module automatically configures the routing of requests to the assets directory for the live code version.
Let's look at an example where a user requests `<path>/<to>/<image>`.
If the code version of the app is `9ff6494`, the CDN will serve `9ff6494/<path>/<to>/<image>` from the Google Cloud Storage (GCS) bucket.

## Environment File

This module also configures the CDN to serve an environment file (`env.json`) in json format containing environment variables from the application.
As opposed to versioned assets, this env file is stored in the root of the Google Cloud Storage (GCS) bucket.
