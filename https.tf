resource "google_compute_url_map" "this" {
  name            = "https-${local.resource_name}"
  description     = "HTTPS Routing for ${local.resource_name}"
  default_service = local.gcs_bucket_id
}

resource "google_compute_target_https_proxy" "this" {
  name             = local.resource_name
  url_map          = google_compute_url_map.this.id
  ssl_certificates = [local.certificate_id]
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "https-${local.resource_name}"
  target     = google_compute_target_https_proxy.this.id
  port_range = "443"
  ip_address = local.public_ip
}
