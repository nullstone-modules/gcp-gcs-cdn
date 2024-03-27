resource "google_compute_backend_bucket" "this" {
  name                 = local.resource_name
  description          = "CDN for GCS Bucket ${local.resource_name}"
  bucket_name          = local.gcs_bucket_name
  enable_cdn           = true
  compression_mode     = "AUTOMATIC"
  edge_security_policy = google_compute_security_policy.this.id

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    default_ttl       = var.default_ttl
    max_ttl           = var.max_ttl
    serve_while_stale = var.serve_while_stale
  }
}

resource "google_compute_security_policy" "this" {
  name        = local.resource_name
  description = "Security policy for ${local.resource_name}"
  type        = "CLOUD_ARMOR_EDGE"
}
