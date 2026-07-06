# build-search.ps1 — regenerate search.html (offline full-text search over all repo markdown)
# Run from anywhere:  powershell C:\Repos\personal-lab\_build\build-search.ps1
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot

$docs = @()
Get-ChildItem -Path $repo -Recurse -Filter *.md -File |
  Where-Object { $_.FullName -notmatch '\\\.git\\' -and $_.FullName -notmatch '\\\.obsidian\\' } |
  Sort-Object FullName |
  ForEach-Object {
    $raw = Get-Content -Path $_.FullName -Raw -Encoding UTF8
    $rel = $_.FullName.Substring($repo.Length + 1) -replace '\\', '/'
    $text = $raw -replace '(?s)^---.*?---\s*', ''                 # strip frontmatter
    $m = [regex]::Match($text, '(?m)^#\s+(.+)$')
    if ($m.Success) { $title = $m.Groups[1].Value.Trim() } else { $title = $_.BaseName }
    $plain = $text -replace '```[\s\S]*?```', ' '                 # code fences
    $plain = $plain -replace '\[\[([^\]|]+)(\|[^\]]+)?\]\]', '$1' # wikilinks
    $plain = $plain -replace '\[([^\]]*)\]\([^)]*\)', '$1'        # md links
    $plain = $plain -replace '[#*`>|]', ' ' -replace '\s+', ' '
    $docs += [pscustomobject]@{ p = $rel; t = $title; x = $plain.Trim() }
  }

$json = ConvertTo-Json -InputObject @($docs) -Compress -Depth 3
$template = Get-Content -Path (Join-Path $PSScriptRoot 'search-template.html') -Raw -Encoding UTF8
$out = $template.Replace('/*__DOCS__*/[]', $json)
$outPath = Join-Path $repo 'search.html'
[System.IO.File]::WriteAllText($outPath, $out, (New-Object System.Text.UTF8Encoding($false)))
Write-Output ("Indexed {0} documents -> {1}" -f $docs.Count, $outPath)
