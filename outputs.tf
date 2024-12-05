output "cdns" {
  value = [
    {
      url_map_id = google_compute_target_https_proxy.this.id
    }
  ]
}

locals {
  public_fqdns = [local.subdomain_fqdn]
}

output "public_urls" {
  value = [for pu in local.public_fqdns : { url = "https://${trimsuffix(pu, ".")}" }]
}
