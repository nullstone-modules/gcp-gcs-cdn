data "google_client_config" "this" {}
data "google_project" "this" {}

locals {
  region        = data.google_client_config.this.region
  region_prefix = lower(substr(local.region, 0, 2))
  project_id    = data.google_project.this.project_id
}
