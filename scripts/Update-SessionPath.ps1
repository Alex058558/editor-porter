# Update-SessionPath.ps1
# Refresh ALL environment variables in the current PowerShell session from Registry
# and automatically fix missing VS Code paths
#
# Usage:
#   irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Update-SessionPath.ps1 | iex

# 1. Refresh ALL environment variables (except PATH which needs special handling)
Write-Host "Refreshing all environment variables..." -ForegroundColor Cyan
$refreshed = @()
foreach ($level in "Machine", "User") {
    $vars = [Environment]::GetEnvironmentVariables($level)
    foreach ($key in $vars.Keys) {
        if ($key -ne "Path") {
            [Environment]::SetEnvironmentVariable($key, $vars[$key], "Process")
            $refreshed += $key
        }
    }
}
Write-Host "  Refreshed $($refreshed.Count) variables" -ForegroundColor Gray

# 2. Use the shared helper to get the smart PATH
try {
    $helperPath = Join-Path $env:TEMP "Get-SmartPath.ps1"
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Get-SmartPath.ps1" -Destination $helperPath
    $env:Path = . $helperPath
    Write-Host "PATH refreshed and optimized!" -ForegroundColor Green
} catch {
    Write-Host "Failed to load Get-SmartPath.ps1, using fallback..." -ForegroundColor Yellow
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

# Quick verification
Write-Host ""
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] 'code' command found." -ForegroundColor Gray
} else {
    Write-Host "  [!!] 'code' command still not found." -ForegroundColor Yellow
}
