# Porter Ephemeral Runner (RAM-Only Version)
# Downloads script into memory and runs it. No temp files.

$Url = "https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.ps1"

Write-Host "Fetching script (Memory Mode)..." -ForegroundColor Cyan
try {
    $ScriptContent = Invoke-RestMethod -Uri $Url -UseBasicParsing
} catch {
    Write-Host "[ERROR] Failed to download tool." -ForegroundColor Red
    exit
}

# Auto-Refresh Environment
try {
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    Write-Host "[OK] Environment variables refreshed." -ForegroundColor DarkGray
} catch {}

# Run the interactive menu loop
do {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor DarkCyan
    Write-Host "Ghost Porter - Migration Tool" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor DarkCyan
    Write-Host "1. Export (Backup Settings)"
    Write-Host "2. Import (Restore Settings)"
    Write-Host "q. Quit"
    Write-Host "========================================" -ForegroundColor DarkCyan
    
    $action = Read-Host "Select Action"
    if ($action -eq 'q') { break }
    
    $mode = if ($action -eq '1') { '-e' } elseif ($action -eq '2') { '-i' } else { continue }

    Write-Host ""
    Write-Host "Select Target Editor:" -ForegroundColor Yellow
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
        Write-Host ""
        Write-Host "Running..." -ForegroundColor Green
        
        # Use Invoke-Expression to properly pass switch parameters
        $invokeCmd = "& { $ScriptContent } $mode $flag"
        Invoke-Expression $invokeCmd
        
        Write-Host ""
        Write-Host "[Done] Press any key to continue..." -ForegroundColor DarkGray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }

} while ($true)

Write-Host ""
Write-Host "Bye!" -ForegroundColor Green
