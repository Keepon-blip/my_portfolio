param(
    [string]$BaseUrl = "http://127.0.0.1:5225",
    [string]$SiteUrl = "https://keepon-portfolio.pages.dev",
    [string]$OutputDirectory = "cloudflare-dist"
)

$ErrorActionPreference = "Stop"

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$sourceAssets = Join-Path $repositoryRoot "PersonalProfile\wwwroot"
$outputPath = Join-Path $repositoryRoot $OutputDirectory

if (Test-Path $outputPath) {
    Remove-Item -LiteralPath $outputPath -Recurse -Force
}

New-Item -ItemType Directory -Path $outputPath | Out-Null
Copy-Item -Path (Join-Path $sourceAssets "*") -Destination $outputPath -Recurse -Force

$routes = @(
    @{ Path = "/"; File = "index.html" },
    @{ Path = "/about"; File = "about\index.html" },
    @{ Path = "/projects"; File = "projects\index.html" },
    @{ Path = "/resume"; File = "resume\index.html" },
    @{ Path = "/contact"; File = "contact\index.html" },
    @{ Path = "/privacy"; File = "privacy\index.html" }
)

foreach ($route in $routes) {
    $destination = Join-Path $outputPath $route.File
    $destinationDirectory = Split-Path -Parent $destination
    New-Item -ItemType Directory -Path $destinationDirectory -Force | Out-Null

    $html = (Invoke-WebRequest -UseBasicParsing "$BaseUrl$($route.Path)").Content
    $html = $html.Replace("https://keepon-portfolio.onrender.com", $SiteUrl.TrimEnd('/'))
    [System.IO.File]::WriteAllText($destination, $html, [System.Text.UTF8Encoding]::new($false))
}

$homeHtml = [System.IO.File]::ReadAllText((Join-Path $outputPath "index.html"))
$notFoundMain = @"
<main role="main" class="site-main-shell">
    <section class="container py-5 text-center d-flex flex-column justify-content-center align-items-center" style="min-height: 60vh;">
        <p class="section-kicker mb-3">404</p>
        <h1 class="display-title mb-3">Page not found</h1>
        <p class="lead text-secondary mb-4">The page you requested does not exist or may have moved.</p>
        <a class="btn btn-primary" href="/">Return home</a>
    </section>
</main>
"@
$notFoundHtml = [regex]::Replace(
    $homeHtml,
    '<main\b[^>]*>.*?</main>',
    $notFoundMain.Trim(),
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)
$notFoundHtml = [regex]::Replace($notFoundHtml, '<title>.*?</title>', '<title>Page Not Found | Keepon Mirishoi Ole Supuko</title>')
if ($notFoundHtml -match '<meta name="robots"[^>]*>') {
    $notFoundHtml = [regex]::Replace($notFoundHtml, '<meta name="robots"[^>]*>', '<meta name="robots" content="noindex, follow">')
}
else {
    $notFoundHtml = $notFoundHtml.Replace('</head>', '    <meta name="robots" content="noindex, follow">' + [Environment]::NewLine + '</head>')
}
[System.IO.File]::WriteAllText((Join-Path $outputPath "404.html"), $notFoundHtml, [System.Text.UTF8Encoding]::new($false))

$textAssets = @("robots.txt", "sitemap.xml")
foreach ($asset in $textAssets) {
    $assetPath = Join-Path $outputPath $asset
    if (Test-Path $assetPath) {
        $content = [System.IO.File]::ReadAllText($assetPath)
        $content = $content.Replace("https://keepon-portfolio.onrender.com", $SiteUrl.TrimEnd('/'))
        [System.IO.File]::WriteAllText($assetPath, $content, [System.Text.UTF8Encoding]::new($false))
    }
}

$redirects = @"
/Home/Index / 301
/Home/About /about 301
/Home/Projects /projects 301
/Home/Resume /resume 301
/Home/Contact /contact 301
/Home/Privacy /privacy 301
"@
[System.IO.File]::WriteAllText((Join-Path $outputPath "_redirects"), $redirects.TrimStart(), [System.Text.UTF8Encoding]::new($false))

$headers = @"
/*
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()

/css/*
  Cache-Control: public, max-age=31536000, immutable

/js/*
  Cache-Control: public, max-age=31536000, immutable

/images/*
  Cache-Control: public, max-age=31536000, immutable
"@
[System.IO.File]::WriteAllText((Join-Path $outputPath "_headers"), $headers.TrimStart(), [System.Text.UTF8Encoding]::new($false))

Write-Host "Cloudflare Pages export created at $outputPath"
