[![繁體中文](https://img.shields.io/badge/lang-繁體中文-blue.svg)](README.md)
[![English](https://img.shields.io/badge/lang-English-red.svg)](README.en.md)
[![日本語](https://img.shields.io/badge/lang-日本語-ff69b4.svg)](README.ja.md)

# Editor Porter

跨平台的 CLI 工具，用於匯出和匯入 VS Code 系列編輯器的插件與設定。

## 使用方式 (Usage)

本工具設計為 **免安裝 (One-Liner)**，直接複製以下指令即可執行備份或還原。

### macOS / Linux
```bash
# 下載並執行 (互動式選單)
bash <(curl -sL https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.sh)
```

### Windows (PowerShell)
```powershell
# 下載並執行 (互動式選單)
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.ps1 | iex"
```

> **注意**：指令已包含自動環境刷新，安裝新編輯器後不需重開機即可抓到。



## 支援編輯器

- **VS Code** (`code`)
- **Cursor** (`cursor`)
- **Windsurf** (`windsurf`)
- **Antigravity** (`antigravity`)

## 功能特色 (Features)

- **互動式選單**：簡單直覺，免記指令。
- **自動環境刷新**：裝完編輯器免重開機。
- **智慧路徑**：預設儲存於 `~/.editor-backup`，亦可自訂。
- **跨平台**：一套流程，Windows / macOS / Linux 通吃。

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
