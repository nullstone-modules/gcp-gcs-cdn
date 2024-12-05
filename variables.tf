variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  gcs_bucket_id   = var.app_metadata["gcs_bucket_id"]
  gcs_bucket_name = var.app_metadata["gcs_bucket_name"]
}

variable "client_ttl" {
  type        = number
  default     = 3600
  description = <<EOF
The time-to-live (TTL) for the content in the client's cache (browser cache).
EOF
}

variable "default_ttl" {
  type        = number
  default     = 86400
  description = <<EOF
The default TTL for cached content when the origin doesn't specify a TTL.
EOF
}

variable "max_ttl" {
  type        = number
  default     = 31536000
  description = <<EOF
The maximum amount of time content can be cached, regardless of what the origin specifies.
EOF
}

variable "serve_while_stale" {
  type        = number
  default     = 86400
  description = <<EOF
The number of seconds to serve stale content before expiring.
The default is 86400 seconds (1 day) which means the CDN will serve stale content from the cache for up to 1 day.
After this delay, the CDN will update its cache for the asset.
If the asset no longer exists in the bucket, the CDN will return 502 Bad Gateway.
EOF
}
