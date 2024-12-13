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
}
