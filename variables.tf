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
  type = bool
  default = true
  description = <<EOF
Serve existing content from the cache (if available) when revalidating content with the origin, or when an error is encountered when refreshing the cache.
EOF
}
