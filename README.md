[![繁體中文](https://img.shields.io/badge/lang-繁體中文-blue.svg)](README.md)
[![English](https://img.shields.io/badge/lang-English-red.svg)](README.en.md)
[![日本語](https://img.shields.io/badge/lang-日本語-ff69b4.svg)](README.ja.md)

# Editor Porter

跨平台的 CLI 工具，用於匯出和匯入 VS Code 系列編輯器的插件與設定。

## 功能特色

- 支援多種 VS Code 系列編輯器
- 跨平台支援（macOS / Linux / Windows）
- 自動轉換快捷鍵（cmd ↔ ctrl）
- 預設備份路徑，使用更簡單

## 支援的編輯器

| 編輯器      | CLI 指令      |
|-------------|---------------|
| VS Code     | `code`        |
| Cursor      | `cursor`      |
| Windsurf    | `windsurf`    |
| Antigravity | `antigravity` |

## 腳本對應平台

| 平台    | 腳本                |
|---------|---------------------|
| macOS   | `editor-porter.sh`  |
| Linux   | `editor-porter.sh`  |
| Windows | `editor-porter.ps1` |

## 安裝

### macOS / Linux

**方法一：直接下載**

```bash
curl -O https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.sh
chmod +x editor-porter.sh
```

**方法二：Clone 專案**

```bash
git clone https://github.com/Alex058558/editor-porter.git
cd editor-porter
chmod +x editor-porter.sh
```

### Windows (PowerShell)

**方法一：直接下載**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.ps1" -OutFile "editor-porter.ps1"
```

**方法二：Clone 專案**

```powershell
git clone https://github.com/Alex058558/editor-porter.git
cd editor-porter
```

## 使用方式

### macOS / Linux

```bash
# 匯出單一編輯器（使用預設路徑 ~/.editor-backup）
./editor-porter.sh -e --code

# 匯出全部編輯器
./editor-porter.sh -e --all

# 匯入單一編輯器
./editor-porter.sh -i --cursor

# 自訂備份路徑
./editor-porter.sh -e --antigravity ~/my-backup
```

### Windows (PowerShell)

```powershell
# 匯出單一編輯器
.\editor-porter.ps1 -e -Code

# 匯出全部編輯器
.\editor-porter.ps1 -e -All

# 匯入單一編輯器
.\editor-porter.ps1 -i -Cursor
```

## 參數說明

| 參數             | 說明                              |
|------------------|-----------------------------------|
| `-e`, `--export` | 匯出插件和設定                    |
| `-i`, `--import` | 匯入插件和設定                    |
| `--code`         | VS Code                           |
| `--cursor`       | Cursor                            |
| `--windsurf`     | Windsurf                          |
| `--antigravity`  | Antigravity                       |
| `--all`          | 全部編輯器                        |
| `[路徑]`         | 備份目錄（預設：`~/.editor-backup`） |

## 匯出內容

| 檔案               | 說明                         |
|--------------------|------------------------------|
| `extensions.txt`   | 已安裝的插件清單             |
| `settings.json`    | 使用者設定                   |
| `keybindings.json` | 快捷鍵設定                   |
| `.source_os`       | 來源作業系統（用於快捷鍵轉換） |

## 快捷鍵自動轉換

從 macOS 匯入到 Windows/Linux 時，會自動轉換：

| macOS         | Windows/Linux  |
|---------------|----------------|
| `cmd+s`       | `ctrl+s`       |
| `alt+cmd+h`   | `ctrl+alt+h`   |
| `shift+cmd+l` | `ctrl+shift+l` |

## 授權

MIT
