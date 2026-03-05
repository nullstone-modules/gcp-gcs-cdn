locals {
  effective_app_version = coalesce(local.app_version, "no-app-version")
  artifacts_dir         = trimprefix(replace(local.artifacts_key_template, "{{app-version}}", local.effective_app_version), "/")
  path_prefix           = trimsuffix("/${local.artifacts_dir}", "/")
  effective_backend_id  = var.clean_urls ? google_compute_backend_service.clean_urls_proxy[0].id : local.backend_id
}

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
  default_service = local.effective_backend_id

  host_rule {
    hosts        = ["*"]
    path_matcher = "primary"
  }

  path_matcher {
    name            = "primary"
    default_service = local.effective_backend_id

    header_action {
      request_headers_to_add {
        header_name  = "X-Nullstone-Version"
        header_value = local.effective_app_version
        replace      = false
      }
    }

    # Ensure `/` fetches the default document (e.g., `/index.html`)
    route_rules {
      priority = 1
      service  = local.backend_id

      match_rules {
        path_template_match = "/"
      }
      route_action {
        url_rewrite {
          path_template_rewrite = "${local.path_prefix}/${local.default_document}"
        }
      }
    }

    # Route /env.json to the bucket's root object `env.json`
    route_rules {
      priority = 2
      service = local.backend_id

      match_rules {
        full_path_match = "/env.json"
      }
    }

    default_route_action {
      url_rewrite {
        path_prefix_rewrite = local.path_prefix
      }
    }

    # Ensure we serve the notfound_document (e.g., `/404.html`) when we cannot find a document
    default_custom_error_response_policy {
      error_response_rule {
        path                 = "${local.path_prefix}/${trimprefix(local.notfound_document, "/")}"
        match_response_codes = ["404"]
      }

      error_service = local.backend_id
    }
  }
}
