resource "google_compute_target_http_proxy" "this" {
  name    = local.resource_name
  url_map = google_compute_url_map.http.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "http-${local.resource_name}"
  target     = google_compute_target_http_proxy.this.id
  port_range = "80"
  ip_address = local.public_ip
}
