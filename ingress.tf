data "ns_connection" "ingress" {
  name     = "ingress"
  contract = "ingress/gcp/compute"
}

data "ns_connection" "subdomain" {
  name     = "subdomain"
  contract = "subdomain/gcp/cloud-dns"
  via      = data.ns_connection.ingress.name
}

locals {
  public_ip          = data.ns_connection.ingress.outputs.public_ip
  certificate_map_id = data.ns_connection.ingress.outputs.certificate_map_id
  subdomain_fqdn     = data.ns_connection.subdomain.outputs.fqdn
}
