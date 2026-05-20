# 0.1.11 (May 20, 2026)
* Added `var.post_app_metadata`.

# 0.1.10 (Mar 06, 2026)
* Fixed clean URLs proxy with various request paths.

# 0.1.9 (Mar 05, 2026)
* Added `X-Nullstone-Version` request header to primary path matcher.

# 0.1.8 (Mar 02, 2026)
* Granted necessary permissions to the build service account to access the staging bucket.

# 0.1.7 (Feb 23, 2026)
* Use `notfound_document` in versioned directory.

# 0.1.6 (Feb 23, 2026)
* Fixed configuration by using consistent rules in URL map.

# 0.1.5 (Feb 23, 2026)
* Added support for `default_document` and `notfound_document` in routing.

# 0.1.4 (Feb 23, 2026)
* Used google-beta provider to configure backend services permissions for deployer.

# 0.1.3 (Feb 23, 2026)
* Fixed deployer permissions to allow using the backend service in a Load Balancer.

# 0.1.2 (Feb 23, 2026)
* Added `var.clean_urls` toggle to add `.html` to the request path if no file extension is specified.

# 0.1.1 (Dec 13, 2024)
* Adding missing DNS records to connect subdomain to CDN.

# 0.1.0 (Dec 13, 2024)
* Initial draft
