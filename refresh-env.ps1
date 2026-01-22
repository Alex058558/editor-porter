# Refresh Environment Variables by Restarting Explorer
# Usage: iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/refresh-env.ps1 | iex

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
Write-Host ""
Write-Host "Done! All apps launched from now on will have the updated PATH." -ForegroundColor Green
Write-Host ""
