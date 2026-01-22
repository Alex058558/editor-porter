# Update-SessionPath.ps1
# Refresh the current PowerShell session's PATH from Registry
# and automatically fix missing VS Code paths
#
# Usage:
#   irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Update-SessionPath.ps1 | iex

# 1. Use the shared helper to get the smart path
try {
    $helperPath = Join-Path $env:TEMP "Get-SmartPath.ps1"
    
    # Try fetching from remote path
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Get-SmartPath.ps1" -Destination $helperPath
    
    $env:Path = . $helperPath
    Write-Host "PATH refreshed and optimized!" -ForegroundColor Green
} catch {
    Write-Host "Failed to load Get-SmartPath.ps1" -ForegroundColor Red
}

# Quick verification
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] 'code' command found." -ForegroundColor Gray
} else {
    Write-Host "  [!!] 'code' command still not found." -ForegroundColor Yellow
}
