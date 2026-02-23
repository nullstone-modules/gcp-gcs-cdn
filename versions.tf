terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
    google = {
      source = "hashicorp/google"
    }
    google-beta= {
      source = "hashicorp/google-beta"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}
