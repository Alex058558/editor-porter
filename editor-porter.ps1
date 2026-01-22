# Editor Migration Script (Windows PowerShell)
# Supports: code (VSCode), cursor, windsurf, antigravity

param(
    [Alias("e")]
    [switch]$Export,

    [Alias("i")]
    [switch]$Import,

    [switch]$Code,
    [switch]$Cursor,
    [switch]$Windsurf,
    [switch]$Antigravity,
    [switch]$All,

    [string]$Source,  # For Import: which editor's backup to use

    [Parameter(Position=0)]
    [string]$BackupDir
)

$CurrentOS = "windows"
$DefaultBackupDir = [System.IO.Path]::Combine($env:USERPROFILE, ".editor-backup")

$ConfigPaths = @{
    "code" = "$env:APPDATA\Code\User"
    "cursor" = "$env:APPDATA\Cursor\User"
    "windsurf" = "$env:APPDATA\Windsurf\User"
    "antigravity" = "$env:APPDATA\Antigravity\User"
}

$FallbackPaths = @{
    "code" = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"
    "cursor" = "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe"
    "windsurf" = "$env:LOCALAPPDATA\Programs\Windsurf\bin\windsurf.cmd"
    "antigravity" = "$env:LOCALAPPDATA\Programs\Antigravity\bin\antigravity.cmd"
}

function Show-Usage {
    Write-Host "Usage: .\editor-porter.ps1 [options] [backup-dir]"
    Write-Host ""
    Write-Host "Actions (required, pick one):"
    Write-Host "  -e, -Export     Export extensions and settings"
    Write-Host "  -i, -Import     Import extensions and settings"
    Write-Host ""
    Write-Host "Editors (required, pick one):"
    Write-Host "  -Code           VS Code"
    Write-Host "  -Cursor         Cursor"
    Write-Host "  -Windsurf       Windsurf"
    Write-Host "  -Antigravity    Antigravity"
    Write-Host "  -All            All editors"
    Write-Host ""
    Write-Host "Backup directory: (optional, default: current directory)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\editor-porter.ps1 -e -Antigravity       # Export to current dir"
    Write-Host "  .\editor-porter.ps1 -i -Antigravity       # Import from current dir"
    Write-Host "  .\editor-porter.ps1 -e -All ~\my-backup   # Export to custom path"
    exit 1
}

function Update-SessionPath {
    $machinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"
}

function Get-EditorCommand {
    param([string]$EditorName)
    
    # Try PATH first
    $cmd = Get-Command $EditorName -ErrorAction SilentlyContinue
    if ($cmd) {
        return $EditorName
    }
    
    # Try fallback path
    $fallback = $FallbackPaths[$EditorName]
    if ($fallback -and (Test-Path $fallback)) {
        Write-Host "  (Using fallback path: $fallback)" -ForegroundColor DarkGray
        return $fallback
    }
    
    Write-Host "Warning: '$EditorName' not found in PATH or default install location, skipping..." -ForegroundColor Yellow
    return $null
}

function Convert-Keybindings {
    param(
        [string]$SourceFile,
        [string]$TargetFile,
        [string]$SourceOS,
        [string]$TargetOS
    )

    if ($SourceOS -eq $TargetOS) {
        Copy-Item $SourceFile -Destination $TargetFile -Force
        return
    }

    Write-Host "  -> Converting keybindings from $SourceOS to $TargetOS..."

    $content = Get-Content $SourceFile -Raw

    if ($SourceOS -eq "macos" -and $TargetOS -ne "macos") {
        # macOS -> Windows/Linux: cmd -> ctrl (order matters)
        $content = $content -replace '"alt\+cmd\+', '"ctrl+alt+'
        $content = $content -replace '"shift\+cmd\+', '"ctrl+shift+'
        $content = $content -replace '"cmd\+', '"ctrl+'
        $content = $content -replace '\+cmd"', '+ctrl"'
        $content = $content -replace '\+cmd\+', '+ctrl+'
    }
    elseif ($SourceOS -ne "macos" -and $TargetOS -eq "macos") {
        # Windows/Linux -> macOS: ctrl -> cmd
        $content = $content -replace '"ctrl\+alt\+', '"alt+cmd+'
        $content = $content -replace '"ctrl\+shift\+', '"shift+cmd+'
        $content = $content -replace '"ctrl\+', '"cmd+'
        $content = $content -replace '\+ctrl"', '+cmd"'
        $content = $content -replace '\+ctrl\+', '+cmd+'
    }

    $content | Out-File -FilePath $TargetFile -Encoding UTF8 -Force
}

function Export-Editor {
    param([string]$EditorName, [string]$BackupPath)

    $editorCmd = Get-EditorCommand $EditorName
    if (-not $editorCmd) { return $false }

    $targetDir = Join-Path $BackupPath $EditorName
    $configPath = $ConfigPaths[$EditorName]

    Write-Host "=== Exporting $EditorName ===" -ForegroundColor Cyan

    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Save source OS metadata
    $CurrentOS | Out-File -FilePath (Join-Path $targetDir ".source_os") -Encoding UTF8 -Force

    Write-Host "  -> Exporting extensions..."
    $extFile = Join-Path $targetDir "extensions.txt"
    & $editorCmd --list-extensions | Out-File -FilePath $extFile -Encoding UTF8
    $extCount = (Get-Content $extFile | Measure-Object -Line).Lines
    Write-Host "     Found $extCount extensions"

    $settingsFile = Join-Path $configPath "settings.json"
    if (Test-Path $settingsFile) {
        Write-Host "  -> Copying settings.json..."
        Copy-Item $settingsFile -Destination $targetDir
    } else {
        Write-Host "  -> settings.json not found, skipping..."
    }

    $keybindingsFile = Join-Path $configPath "keybindings.json"
    if (Test-Path $keybindingsFile) {
        Write-Host "  -> Copying keybindings.json..."
        Copy-Item $keybindingsFile -Destination $targetDir
    } else {
        Write-Host "  -> keybindings.json not found, skipping..."
    }

    Write-Host "  Done! Exported to: $targetDir" -ForegroundColor Green
    Write-Host ""
    return $true
}

function Import-Editor {
    param([string]$EditorName, [string]$BackupPath, [string]$SourceEditor)

    $editorCmd = Get-EditorCommand $EditorName
    if (-not $editorCmd) { return $false }

    # Use SourceEditor if provided, otherwise use EditorName
    $sourceName = if ($SourceEditor) { $SourceEditor } else { $EditorName }
    $sourceDir = Join-Path $BackupPath $sourceName
    $configPath = $ConfigPaths[$EditorName]

    # Check if subdirectory exists, if not check if files are directly in BackupPath
    if (-not (Test-Path $sourceDir)) {
        # Try flat structure (files directly in backup dir)
        $extFile = Join-Path $BackupPath "extensions.txt"
        $settingsFile = Join-Path $BackupPath "settings.json"
        if ((Test-Path $extFile) -or (Test-Path $settingsFile)) {
            $sourceDir = $BackupPath
            Write-Host "  (Using flat directory structure)"
        } else {
            Write-Host "" 
            Write-Host "[ERROR] No backup found for '$EditorName'." -ForegroundColor Red
            Write-Host "        Looked in: $BackupPath" -ForegroundColor Red
            Write-Host ""
            Write-Host "[TIP] Did you run Export first? If transferring from another machine," -ForegroundColor Yellow
            Write-Host "      make sure to copy the backup folder to this location." -ForegroundColor Yellow
            return $false
        }
    }

    Write-Host "=== Importing to $EditorName ===" -ForegroundColor Cyan

    # Read source OS from metadata
    $sourceOS = "unknown"
    $sourceOSFile = Join-Path $sourceDir ".source_os"
    if (Test-Path $sourceOSFile) {
        $sourceOS = (Get-Content $sourceOSFile -Raw).Trim()
    }

    $extFile = Join-Path $sourceDir "extensions.txt"
    if (Test-Path $extFile) {
        Write-Host "  -> Installing extensions..."
        $extensions = Get-Content $extFile
        $total = $extensions.Count
        $count = 0
        foreach ($ext in $extensions) {
            if ($ext.Trim()) {
                $count++
                Write-Host "     [$count/$total] $ext " -NoNewline
                & $editorCmd --install-extension $ext --force 2>$null | Out-Null
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "[OK]" -ForegroundColor Green
                } else {
                    Write-Host "[FAILED]" -ForegroundColor Red
                }
            }
        }
    } else {
        Write-Host "  -> extensions.txt not found, skipping..."
    }

    if (-not (Test-Path $configPath)) {
        New-Item -ItemType Directory -Path $configPath -Force | Out-Null
    }

    $settingsFile = Join-Path $sourceDir "settings.json"
    if (Test-Path $settingsFile) {
        Write-Host "  -> Restoring settings.json..."
        Copy-Item $settingsFile -Destination $configPath -Force
    }

    $keybindingsFile = Join-Path $sourceDir "keybindings.json"
    if (Test-Path $keybindingsFile) {
        if ($sourceOS -ne "unknown" -and $sourceOS -ne $CurrentOS) {
            Convert-Keybindings -SourceFile $keybindingsFile -TargetFile (Join-Path $configPath "keybindings.json") -SourceOS $sourceOS -TargetOS $CurrentOS
        } else {
            Write-Host "  -> Restoring keybindings.json..."
            Copy-Item $keybindingsFile -Destination $configPath -Force
        }
    }

    Write-Host "  Done!" -ForegroundColor Green
    Write-Host ""
    return $true
}

# Determine action
$Action = ""
if ($Export) { $Action = "export" }
if ($Import) { $Action = "import" }

# Determine editor
$Editor = ""
if ($Code) { $Editor = "code" }
if ($Cursor) { $Editor = "cursor" }
if ($Windsurf) { $Editor = "windsurf" }
if ($Antigravity) { $Editor = "antigravity" }
if ($All) { $Editor = "all" }

# Validate
if (-not $Action -or -not $Editor) {
    Show-Usage
}

# Use default backup dir if not specified
if (-not $BackupDir) {
    $BackupDir = $DefaultBackupDir
} else {
    $BackupDir = [System.IO.Path]::GetFullPath($BackupDir.Replace("~", $env:USERPROFILE))
}

Write-Host "Detected OS: $CurrentOS"
Write-Host "Backup directory: $BackupDir"
Write-Host ""

# Process
$editorsToProcess = if ($Editor -eq "all") {
    @("code", "cursor", "windsurf", "antigravity")
} else {
    @($Editor)
}

switch ($Action) {
    "export" {
        $successCount = 0
        foreach ($e in $editorsToProcess) {
            if (Export-Editor -EditorName $e -BackupPath $BackupDir) {
                $successCount++
            }
        }
        if ($successCount -gt 0) {
            Write-Host "Export complete! Backup saved to: $BackupDir" -ForegroundColor Green
        } else {
            Write-Host "No editors were exported. Please check if the editor is installed." -ForegroundColor Yellow
        }
    }
    "import" {
        $successCount = 0
        foreach ($e in $editorsToProcess) {
            if (Import-Editor -EditorName $e -BackupPath $BackupDir -SourceEditor $Source) {
                $successCount++
            }
        }
        if ($successCount -gt 0) {
            Update-SessionPath
            Write-Host "Import complete! (PATH refreshed for this session)" -ForegroundColor Green
        } else {
            Write-Host "No editors were imported. Please check if the editor is installed and backup exists." -ForegroundColor Yellow
        }
    }
}
