# Porter Ephemeral Runner
# Downloads, runs locally, and cleans up. No traces left.

$TempPath = [System.IO.Path]::GetTempFileName() + ".ps1"
$Url = "https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.ps1"

Write-Host "⏳ Fetching magic wand..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $Url -OutFile $TempPath -UseBasicParsing
} catch {
    Write-Host "❌ Failed to download tool." -ForegroundColor Red
    exit
}

# ⚡ Auto-Refresh Environment (In case editor was just installed)
try {
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    Write-Host "⚡ Environment variables refreshed automatically." -ForegroundColor DarkGray
} catch {}

# Run the interactive menu loop
do {
    Clear-Host
    Write-Host "👻 Ghost Porter - One-time Migration Tool" -ForegroundColor Magenta
    Write-Host "========================================"
    Write-Host "1. 📤 Export (Backup Settings)"
    Write-Host "2. 📥 Import (Restore Settings)"
    Write-Host "q. 🚪 Quit & Clean Up"
    Write-Host "========================================"
    
    $action = Read-Host "Select Action"
    if ($action -eq 'q') { break }
    
    $mode = if ($action -eq '1') { '-e' } elseif ($action -eq '2') { '-i' } else { continue }

    Write-Host "`n🎯 Select Target Editor:" -ForegroundColor Yellow
    Write-Host "1. VS Code (code)"
    Write-Host "2. Cursor"
    Write-Host "3. Windsurf"
    Write-Host "4. Antigravity"
    Write-Host "5. All Editors"
    
    $target = Read-Host "Select Editor"
    $flag = switch ($target) {
        '1' { '-Code' }
        '2' { '-Cursor' }
        '3' { '-Windsurf' }
        '4' { '-Antigravity' }
        '5' { '-All' }
        Default { "" }
    }
    
    if ($flag) {
        Write-Host "`n🚀 Running..." -ForegroundColor Green
        # Call the downloaded script
        & $TempPath $mode $flag
        Write-Host "`n✅ Done! Press any key to continue..." -ForegroundColor DarkGray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }

} while ($true)

# Cleanup
Write-Host "`n🧹 Cleaning up traces..." -ForegroundColor Cyan
if (Test-Path $TempPath) { Remove-Item $TempPath -Force }
Write-Host "✨ All gone. Have a nice day!" -ForegroundColor Green
