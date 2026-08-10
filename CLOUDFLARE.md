# Cloudflare Pages deployment

The deployable static site is stored in `cloudflare-dist`.

## Cloudflare dashboard settings

- Production branch: `cloudflare-pages` initially, then `main` after merging
- Framework preset: None
- Build command: leave blank
- Build output directory: `cloudflare-dist`
- Root directory: leave blank

The expected Pages project name is `keepon-portfolio`, producing the default URL
`https://keepon.pages.dev`. If a different project name is used, regenerate
the export with the final URL so canonical and social metadata remain accurate:

```powershell
.\scripts\export-cloudflare.ps1 -SiteUrl "https://your-project.pages.dev"
```

The export script expects the ASP.NET source application to be running locally at
`http://127.0.0.1:5225`. It copies all static assets, renders every public route, updates
the deployment URL in SEO files, and adds Cloudflare redirects and security headers.
