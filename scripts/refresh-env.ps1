# Refresh Environment Variables by Restarting Explorer
# Usage: irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/refresh-env.ps1 | iex

Write-Host ""
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host "Refresh Environment Variables" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "This will restart Explorer.exe to refresh ALL environment variables." -ForegroundColor Yellow
Write-Host "Your taskbar will disappear briefly - that's normal!" -ForegroundColor DarkGray
Write-Host ""

$confirm = Read-Host "Continue? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "Cancelled." -ForegroundColor Gray
    return
}

Write-Host ""
Write-Host "Restarting Explorer..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2

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
$scriptUrl = "https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Get-SmartPath.ps1"
$helperPath = Join-Path $env:TEMP "Get-SmartPath.ps1"

try {
    Start-BitsTransfer -Source $scriptUrl -Destination $helperPath
    $env:Path = . $helperPath
} catch {
    Write-Host "Failed to fetch/run helper script. Using local fallback..." -ForegroundColor Yellow
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

Write-Host ""
Write-Host "Done! Explorer restarted and ALL environment variables refreshed." -ForegroundColor Green
Write-Host ""
Write-Host "Note: If you use a launcher (Raycast, PowerToys Run, etc.)," -ForegroundColor DarkGray
Write-Host "      restart it too - it still has the old environment." -ForegroundColor DarkGray
Write-Host ""