resource "google_compute_global_address" "static-ip" {
  name = local.resource_name
}

locals {
  public_ip = google_compute_global_address.static-ip.address
}
