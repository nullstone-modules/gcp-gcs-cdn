variable "app_metadata" {
  description = <<EOF
Nullstone automatically injects metadata from the app module into this module through this variable.
This variable is a reserved variable for capabilities.
EOF

  type    = map(string)
  default = {}
}

locals {
  backend_id             = var.app_metadata["backend_id"]
  artifacts_key_template = var.app_metadata["artifacts_key_template"]
  gcs_bucket_name        = var.app_metadata["gcs_bucket_name"]
  deployer_email         = var.app_metadata["deployer_email"]
  default_document       = var.app_metadata["default_document"]
  notfound_document      = var.app_metadata["notfound_document"]
}

variable "clean_urls" {
  type    = bool
  default = false

  description = <<EOF
Enable this to use "clean URLs" in the browser by appending ".html" when serving content from the backend (i.e. GCS Bucket).
This will *NOT* add ".html" to requests that already have a file extension.
EOF
}
