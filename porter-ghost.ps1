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

# Editor selection helper
function Get-EditorFlag {
    param([string]$Prompt, [switch]$ShowBackupStatus)
    
    $backupRoot = [System.IO.Path]::Combine($env:USERPROFILE, ".editor-backup")
    $currentDir = Get-Location
    
    function Get-Status {
        param([string]$Name)
        if (-not $ShowBackupStatus) { return "" }
        
        # Check current directory first
        if (Test-Path (Join-Path $currentDir $Name)) {
            return " [Local Backup Found]"
        }
        # Check default directory
        if (Test-Path "$backupRoot\$Name") {
            return " [Default Backup Found]"
        }
        return " [No Backup]"
    }

    Write-Host ""
    Write-Host $Prompt -ForegroundColor Yellow
    Write-Host ("1. VS Code" + (Get-Status "code"))
    Write-Host ("2. Cursor" + (Get-Status "cursor"))
    Write-Host ("3. Windsurf" + (Get-Status "windsurf"))
    Write-Host ("4. Antigravity" + (Get-Status "antigravity"))
    
    $choice = Read-Host "Select"
    $result = $null
    switch ($choice) {
        '1' { $result = 'code' }
        '2' { $result = 'cursor' }
        '3' { $result = 'windsurf' }
        '4' { $result = 'antigravity' }
    }
    return $result
}

# Run the interactive menu loop
do {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor DarkCyan
    Write-Host "Ghost Porter - Migration Tool" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor DarkCyan
    Write-Host "1. Export (Backup Settings)"
    Write-Host "2. Import (Restore Settings)"
    Write-Host "----------------------------------------" -ForegroundColor DarkGray
    Write-Host "r. Refresh PATH (Restart Explorer)"
    Write-Host "q. Quit"
    Write-Host "========================================" -ForegroundColor DarkCyan
    
    $action = Read-Host "Select Action"
    if ($action -eq 'q') { break }
    
    if ($action -eq 'r') {
        Write-Host ""
        Write-Host "This will restart Explorer.exe to refresh PATH for all apps." -ForegroundColor Yellow
        Write-Host "Your taskbar will disappear briefly - that's normal!" -ForegroundColor DarkGray
        Write-Host ""
        $confirm = Read-Host "Continue? (y/N)"
        if ($confirm -eq 'y' -or $confirm -eq 'Y') {
            Write-Host ""
            Write-Host "Restarting Explorer..." -ForegroundColor Cyan
            Stop-Process -Name explorer -Force
            Start-Sleep -Seconds 2
            Write-Host "Done! All apps launched from now on will have the updated PATH." -ForegroundColor Green
        } else {
            Write-Host "Cancelled." -ForegroundColor Gray
        }
        Write-Host ""
        Write-Host "[Done] Press any key to continue..." -ForegroundColor DarkGray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        continue
    }
    
    if ($action -eq '1') {
        # Export flow
        $editor = Get-EditorFlag "Export FROM which editor?"
        if (-not $editor) { continue }
        
        Write-Host ""
        Write-Host "Running Export..." -ForegroundColor Green
        $invokeCmd = "& { $ScriptContent } -e -$editor"
        Invoke-Expression $invokeCmd
    }
    elseif ($action -eq '2') {
        # Import flow - ask for Source and Target
        $source = Get-EditorFlag "Import FROM which editor's backup?" -ShowBackupStatus
        if (-not $source) { continue }
        
        $target = Get-EditorFlag "Import TO which editor?"
        if (-not $target) { continue }
        
        # Determine Backup Directory to use
        $currentDir = Get-Location
        $backupDirArg = ""
        
        if (Test-Path (Join-Path $currentDir $source)) {
            Write-Host "Using Local Backup in current directory..." -ForegroundColor Cyan
            $backupDirArg = "`"$currentDir`""
        } else {
             Write-Host "Using Default Backup directory..." -ForegroundColor Cyan
             # Leave empty to use default, or explicitly pass default
             # $backupDirArg = "" 
        }

        Write-Host ""
        Write-Host "Running Import ($source -> $target)..." -ForegroundColor Green
        
        $invokeCmd = "& { $ScriptContent } -i -$target -Source $source"
        if ($backupDirArg) {
            $invokeCmd += " $backupDirArg"
        }
        
        Invoke-Expression $invokeCmd
    }
    else {
        continue
    }
    
    Write-Host ""
    Write-Host "[Done] Press any key to continue..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} while ($true)

Write-Host ""
Write-Host "Bye!" -ForegroundColor Green
