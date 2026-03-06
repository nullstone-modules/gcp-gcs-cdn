# clean-urls proxy

This proxy, when enabled via `var.clean_urls = true`, allows a developer to deploy an application with Clean URLs.

Typically done in Next.js apps (see [Linking and Navigating](https://nextjs.org/docs/pages/building-your-application/routing/linking-and-navigating)), 
this makes the urls appear clean in the browser, but serves static files (e.g. `.html`, `.js`, etc.).

## Example Request Mappings

- `` -> `/index.html` (uses `default_document` from app vars)
- `/` -> `/index.html` (handled by explicit route rule in CDN)
- `/about` -> `/about/index.html`
- `/static/chunks/asdfasdfasdf.js` (pass-through, no change happens in this proxy)

## Trailing Slash

To properly use this functionality, all main pages (viewed in the browser URL bar) should be output to static assets as `/<page>/index.html`.
For example, `/about` maps to `/about/index.html`.

To do this for next.js, enable `trailingSlash: true` in `next.config.js`.
