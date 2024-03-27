data "ns_connection" "ingress" {
  name     = "ingress"
  contract = "ingress/gcp/compute"
}

locals {
  public_ip      = data.ns_connection.ingress.outputs.public_ip
  certificate_id = data.ns_connection.ingress.outputs.certificate_id
}
