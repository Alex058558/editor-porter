[![繁體中文](https://img.shields.io/badge/lang-繁體中文-blue.svg)](README.md)
[![English](https://img.shields.io/badge/lang-English-red.svg)](README.en.md)
[![日本語](https://img.shields.io/badge/lang-日本語-ff69b4.svg)](README.ja.md)

# Editor Porter

A cross-platform CLI tool to export and import extensions & settings for VS Code-based editors.

## Usage

Designed as a **One-Liner** tool. Run the following command to backup or restore directly.

### macOS / Linux
```bash
# Download and Run (Interactive Menu)
bash <(curl -sL https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.sh)
```

### Windows (PowerShell)
```powershell
# Download and Run (Interactive Menu)
irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.ps1 | iex
```

> **Note**: Includes automatic environment refresh, so new editors are detected immediately without restart.

### Troubleshooting PATH Issues

If commands (like `code`) are not found after installation, choose a solution below:

| Solution             | Best For                                   | Command                                                                                                      |
|----------------------|--------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| **Current Window**   | Fixing just this terminal now              | `irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Update-SessionPath.ps1 \| iex`  |
| **Restart Explorer** | Fixing future windows (Start Menu/Desktop) | `irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/refresh-env.ps1 \| iex`         |
| **Auto-Refresh**     | Permanent fix for all future sessions      | `irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Install-AutoRefresh.ps1 \| iex` |

## Supported Editors

- **VS Code** (`code`)
- **Cursor** (`cursor`)
- **Windsurf** (`windsurf`)
- **Antigravity** (`antigravity`)

## Features

- **Interactive Menu**: Simple and intuitive, no commands to memorize.
- **Cross-Editor Migration**: Backup from Editor A and Restore to Editor B (e.g., Antigravity -> Cursor).
- **Smart Path Detection**: Automatically detects backups in "Current Directory" (priority) and "Default Directory", plug-and-play.
- **Hybrid Detection**: Supports both **System Install** (Program Files) and **User Install** (AppData) paths, automatically fixing environment variables.
- **Auto Environment Refresh**: Provides 3 refresh solutions to solve Windows environment variable latency issues.
- **Cross-Platform**: Unified workflow for Windows / macOS / Linux.

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
