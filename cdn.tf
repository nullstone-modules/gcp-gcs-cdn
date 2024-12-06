// This resource is configured to redirect all HTTP requests to HTTPS
// It has no other purpose
resource "google_compute_url_map" "http" {
  name        = "http-${local.resource_name}"
  description = "HTTP Routing for ${local.resource_name}"

  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_url_map" "https" {
  name            = "https-${local.resource_name}"
  description     = "HTTPS Routing for ${local.resource_name}"
  default_service = local.backend_id

  host_rule {
    hosts        = ["*"]
    path_matcher = "primary"
  }

  path_matcher {
    name            = "primary"
    default_service = local.backend_id

    path_rule {
      paths = ["/env.json"]
      service = local.backend_id
    }

    default_route_action {
      url_rewrite {
        path_prefix_rewrite = local.artifacts_key_template
      }
    }
  }
}
