# Refresh Environment Variables by Restarting Explorer
# Usage: irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/refresh-env.ps1 | iex

Write-Host ""
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host "Refresh Environment Variables" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "This will restart Explorer.exe to refresh PATH for all apps." -ForegroundColor Yellow
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

# Use the shared helper to get the smart path
$scriptUrl = "https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Get-SmartPath.ps1"
$helperPath = Join-Path $env:TEMP "Get-SmartPath.ps1"

try {
    # Always fetch fresh helper
    Start-BitsTransfer -Source $scriptUrl -Destination $helperPath
    $env:Path = . $helperPath
} catch {
    Write-Host "Failed to fetch/run helper script. Using local fallback..." -ForegroundColor Yellow
    # Fallback: simple registry read if internet fails
    $machinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

Write-Host ""
Write-Host "Done! Explorer restarted and current session PATH refreshed & optimized." -ForegroundColor Green
Write-Host ""
