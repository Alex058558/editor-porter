# Install-AutoRefresh.ps1
# Adds Offline-Capable environment variables auto-refresh to your PowerShell Profile
# Usage: irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Install-AutoRefresh.ps1 | iex

$profilePath = $PROFILE

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
    Write-Host "Created new profile at: $profilePath"
}

$content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
$marker = "# [EditorPorter] Auto-refresh Environment Variables"

if ($content -match "\[EditorPorter\]") {
    Write-Host "Auto-refresh is already configured in your profile!" -ForegroundColor Yellow
    Write-Host "To update, remove the [EditorPorter] block from your profile and run again." -ForegroundColor Gray
} else {
    # We embed the logic directly to ensure fast startup (no network required)
    $scriptBlock = "
$marker
# Refresh ALL environment variables (except PATH)
foreach (`$level in 'Machine', 'User') {
    `$vars = [Environment]::GetEnvironmentVariables(`$level)
    foreach (`$key in `$vars.Keys) {
        if (`$key -ne 'Path') {
            [Environment]::SetEnvironmentVariable(`$key, `$vars[`$key], 'Process')
        }
    }
}

# Smart PATH refresh with editor detection
`$machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
`$userPath = [Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
`$allPaths = `$machinePath + `$userPath

`$editors = @(
    @{ Name='VS Code';     Path='Microsoft VS Code\bin' },
    @{ Name='Cursor';      Path='cursor\Cursor.exe' },
    @{ Name='Windsurf';    Path='Windsurf\bin' },
    @{ Name='Antigravity'; Path='Antigravity\bin' }
)
`$prefixes = @(`$env:ProgramFiles, `$env:LOCALAPPDATA)
`$knownPaths = @()

foreach (`$editor in `$editors) {
    foreach (`$prefix in `$prefixes) {
        `$fullPath = Join-Path `$prefix ('Programs\' + `$editor.Path)
        if (-not (Test-Path `$fullPath)) {
            `$fullPath = Join-Path `$prefix `$editor.Path
        }
        `$knownPaths += `$fullPath
    }
}

`$validPaths = @()
foreach (`$p in (`$allPaths + `$knownPaths)) {
    if (`$p -and (Test-Path `$p)) {
        if (`$p -match 'Cursor.exe') { `$p = [System.IO.Path]::GetDirectoryName(`$p) }
        if (`$validPaths -notcontains `$p) { `$validPaths += `$p }
    }
}
`$env:Path = `$validPaths -join ';'
# [EditorPorter] End
"
    Add-Content $profilePath $scriptBlock
    Write-Host "Success! Added smart auto-refresh to your profile." -ForegroundColor Green
    Write-Host "Every new terminal will auto-refresh ALL environment variables." -ForegroundColor Cyan
    Write-Host "Changes will take effect in your NEXT terminal session." -ForegroundColor Gray
}
