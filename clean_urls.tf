locals {
  storage_location = local.region_prefix == "us" ? "US" : (local.region_prefix == "eu" ? "EU" : "ASIA")
}

resource "google_storage_bucket" "clean_urls_source" {
  count                       = var.clean_urls ? 1 : 0
  name                        = "${local.resource_name}-clean-urls-src"
  location                    = local.storage_location
  labels                      = local.labels
  uniform_bucket_level_access = true
  force_destroy               = true
}

data "archive_file" "clean_urls_proxy" {
  count       = var.clean_urls ? 1 : 0
  type        = "zip"
  source_dir  = "${path.module}/proxy"
  output_path = "${path.module}/.terraform/clean_urls_proxy.zip"
}

resource "google_storage_bucket_object" "clean_urls_source" {
  count  = var.clean_urls ? 1 : 0
  name   = "clean_urls_proxy-${data.archive_file.clean_urls_proxy[0].output_md5}.zip"
  bucket = google_storage_bucket.clean_urls_source[0].name
  source = data.archive_file.clean_urls_proxy[0].output_path
}

resource "google_cloudfunctions2_function" "clean_urls_proxy" {
  count    = var.clean_urls ? 1 : 0
  name     = "${local.resource_name}-clean-urls"
  location = local.region
  labels   = local.labels

  build_config {
    runtime         = "go124"
    entry_point     = "CleanURLsProxy"
    service_account = google_service_account.clean_urls_build[0].id

    source {
      storage_source {
        bucket = google_storage_bucket.clean_urls_source[0].name
        object = google_storage_bucket_object.clean_urls_source[0].name
      }
    }
  }

  service_config {
    available_memory = "128Mi"
    timeout_seconds  = 60
    ingress_settings = "ALLOW_INTERNAL_AND_GCLB"
    environment_variables = {
      GCS_BUCKET_NAME = local.gcs_bucket_name
    }
  }

  depends_on = [
    google_project_iam_member.clean_urls_build_artifactregistry,
    google_project_iam_member.clean_urls_build_cloudbuild,
    google_storage_bucket_iam_member.clean_urls_build_source_reader,
  ]
}

resource "google_service_account" "clean_urls_build" {
  count        = var.clean_urls ? 1 : 0
  account_id   = "${local.resource_name}-cu-build"
  display_name = "Clean URLs function build SA"
}

resource "google_project_iam_member" "clean_urls_build_artifactregistry" {
  count   = var.clean_urls ? 1 : 0
  project = local.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.clean_urls_build[0].email}"
}

resource "google_project_iam_member" "clean_urls_build_cloudbuild" {
  count   = var.clean_urls ? 1 : 0
  project = local.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${google_service_account.clean_urls_build[0].email}"
}

resource "google_storage_bucket_iam_member" "clean_urls_build_source_reader" {
  count  = var.clean_urls ? 1 : 0
  bucket = google_storage_bucket.clean_urls_source[0].name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.clean_urls_build[0].email}"
}

resource "google_cloud_run_v2_service_iam_member" "clean_urls_proxy" {
  count    = var.clean_urls ? 1 : 0
  project  = google_cloudfunctions2_function.clean_urls_proxy[0].project
  location = google_cloudfunctions2_function.clean_urls_proxy[0].location
  name     = google_cloudfunctions2_function.clean_urls_proxy[0].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_compute_region_network_endpoint_group" "clean_urls_proxy" {
  count                 = var.clean_urls ? 1 : 0
  name                  = "${local.resource_name}-clean-urls"
  network_endpoint_type = "SERVERLESS"
  region                = local.region

  cloud_run {
    service = google_cloudfunctions2_function.clean_urls_proxy[0].name
  }
}

resource "google_compute_backend_service" "clean_urls_proxy" {
  count                 = var.clean_urls ? 1 : 0
  name                  = "${local.resource_name}-clean-urls"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  protocol              = "HTTPS"

  backend {
    group = google_compute_region_network_endpoint_group.clean_urls_proxy[0].id
  }
}

# Grant permission to the app deployer service account to use the backend service
resource "google_compute_backend_service_iam_member" "clean_urls_proxy" {
  count   = var.clean_urls ? 1 : 0
  project = local.project_id
  name    = google_compute_backend_service.clean_urls_proxy[0].name
  role    = "roles/compute.loadBalancerServiceUser"
  member  = "serviceAccount:${local.deployer_email}"
}
