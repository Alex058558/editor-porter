[![繁體中文](https://img.shields.io/badge/lang-繁體中文-blue.svg)](README.md)
[![English](https://img.shields.io/badge/lang-English-red.svg)](README.en.md)
[![日本語](https://img.shields.io/badge/lang-日本語-ff69b4.svg)](README.ja.md)

# Editor Porter

A cross-platform CLI tool to export and import extensions & settings for VS Code-based editors.

## Quick Start (No Install Required)

Use the following command to run directly without manual download.

### macOS / Linux
```bash
# Download and Run (Interactive Menu)
curl -sO https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.sh && chmod +x porter-ghost.sh && ./porter-ghost.sh
```

### Windows (PowerShell)
```powershell
# Download and Run (Interactive Menu, bypass execution policy)
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.ps1 | iex"
```

> **Note**: These scripts include automatic environment refresh, so no restart is needed after installing new editors.

## Features

- Support for multiple VS Code-based editors
- Cross-platform (macOS / Linux / Windows)
- Automatic keybinding conversion (cmd ↔ ctrl)
- Default backup path for easier usage

## Supported Editors

| Editor      | CLI Command   |
|-------------|---------------|
| VS Code     | `code`        |
| Cursor      | `cursor`      |
| Windsurf    | `windsurf`    |
| Antigravity | `antigravity` |

## Script for Each Platform

| Platform | Script              |
|----------|---------------------|
| macOS    | `editor-porter.sh`  |
| Linux    | `editor-porter.sh`  |
| Windows  | `editor-porter.ps1` |

## Installation

### macOS / Linux

**Option 1: Direct Download**

```bash
curl -O https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.sh
chmod +x editor-porter.sh
```

**Option 2: Clone Repository**

```bash
git clone https://github.com/Alex058558/editor-porter.git
cd editor-porter
chmod +x editor-porter.sh
```

### Windows (PowerShell)

**Option 1: Direct Download**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.ps1" -OutFile "editor-porter.ps1"
```

**Option 2: Clone Repository**

```powershell
git clone https://github.com/Alex058558/editor-porter.git
cd editor-porter
```

## Usage

### macOS / Linux

```bash
# Export single editor (uses default path ~/.editor-backup)
./editor-porter.sh -e --code

# Export all editors
./editor-porter.sh -e --all

# Import to single editor
./editor-porter.sh -i --cursor

# Custom backup path
./editor-porter.sh -e --antigravity ~/my-backup
```

### Windows (PowerShell)

```powershell
# Export single editor
.\editor-porter.ps1 -e -Code

# Export all editors
.\editor-porter.ps1 -e -All

# Import to single editor
.\editor-porter.ps1 -i -Cursor
```

## Options

| Option           | Description                                    |
|------------------|------------------------------------------------|
| `-e`, `--export` | Export extensions and settings                 |
| `-i`, `--import` | Import extensions and settings                 |
| `--code`         | VS Code                                        |
| `--cursor`       | Cursor                                         |
| `--windsurf`     | Windsurf                                       |
| `--antigravity`  | Antigravity                                    |
| `--all`          | All editors                                    |
| `[path]`         | Backup directory (default: `~/.editor-backup`) |

## What Gets Exported

| File               | Description                           |
|--------------------|---------------------------------------|
| `extensions.txt`   | List of installed extensions          |
| `settings.json`    | User settings                         |
| `keybindings.json` | Keyboard shortcuts                    |
| `.source_os`       | Source OS (for keybinding conversion) |

## Automatic Keybinding Conversion

When importing from macOS to Windows/Linux, keybindings are automatically converted:

| macOS         | Windows/Linux  |
|---------------|----------------|
| `cmd+s`       | `ctrl+s`       |
| `alt+cmd+h`   | `ctrl+alt+h`   |
| `shift+cmd+l` | `ctrl+shift+l` |

## License

MIT
