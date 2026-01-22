# Get-SmartPath.ps1
# Returns a clean, optimized PATH string including all supported editors
# Usage: $newPath = . .\Get-SmartPath.ps1

$machinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
$allPaths = $machinePath + $userPath

# Potential install locations for editors
$editors = @(
    @{ Name="VS Code";     Path="Microsoft VS Code\bin" },
    @{ Name="Cursor";      Path="cursor\Cursor.exe"; DirOnly=$true },
    @{ Name="Windsurf";    Path="Windsurf\bin" },
    @{ Name="Antigravity"; Path="Antigravity\bin" }
)

$prefixes = @($env:ProgramFiles, $env:LOCALAPPDATA)
$knownPaths = @()

foreach ($editor in $editors) {
    foreach ($prefix in $prefixes) {
        $fullPath = Join-Path $prefix ("Programs\" + $editor.Path) # Try AppData structure
        if (-not (Test-Path $fullPath)) {
            $fullPath = Join-Path $prefix $editor.Path # Try ProgramFiles structure
        }
        $knownPaths += $fullPath
    }
}

$validPaths = @()
foreach ($p in ($allPaths + $knownPaths)) {
    if ($p -and (Test-Path $p)) {
        # Handle Cursor specific case (file -> dir)
        if ($p -match "Cursor.exe") {
            $p = [System.IO.Path]::GetDirectoryName($p)
        }
        
        if ($validPaths -notcontains $p) {
            $validPaths += $p
        }
    }
}

return $validPaths -join ';'
