output "cdns" {
  value = [
    {
      proxy_id   = google_compute_target_https_proxy.this.id
      url_map_id = google_compute_url_map.https.id
    }
  ]
}

locals {
  public_fqdns = [local.subdomain_fqdn]
}

output "public_urls" {
  value = [for pu in local.public_fqdns : { url = "https://${trimsuffix(pu, ".")}" }]
}
