resource "google_compute_url_map" "this" {
  name            = "http-${local.resource_name}"
  description     = "HTTP Routing for ${local.resource_name}"
  default_service = local.gcs_bucket_id

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name = "all"

    route_rules {
      priority = 1

      url_redirect {
        https_redirect = true
      }
    }
  }
}

resource "google_compute_target_http_proxy" "this" {
  name    = local.resource_name
  url_map = google_compute_url_map.this.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "https-${local.resource_name}"
  target     = google_compute_target_http_proxy.this.id
  port_range = "80"
  ip_address = local.public_ip
}
