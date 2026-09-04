// Enforces TLS 1.2+ on the HTTPS proxy.
resource "google_compute_ssl_policy" "this" {
  name            = local.resource_name
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}
