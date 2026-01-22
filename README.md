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
irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.ps1 | iex
```

> **注意**：指令已包含自動環境刷新，安裝新編輯器後不需重開機即可抓到。

### 環境變數刷新指南 (Troubleshooting PATH)

如果安裝軟體後（如 VS Code）還是找不到指令，請根據需求選擇解決方案：

| 方案                | 適用情境                      | 指令                                                                                                         |
|---------------------|-------------------------------|--------------------------------------------------------------------------------------------------------------|
| **當前視窗 (最快)** | 只想讓現在這個視窗能用        | `irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Update-SessionPath.ps1 \| iex`  |
| **重啟 Explorer**   | 讓之後從桌面/選單開的視窗生效 | `irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/refresh-env.ps1 \| iex`         |
| **永久自動刷新**    | 寫入設定檔，以後永遠免煩惱     | `irm https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Install-AutoRefresh.ps1 \| iex` |

## 支援編輯器

- **VS Code** (`code`)
- **Cursor** (`cursor`)
- **Windsurf** (`windsurf`)
- **Antigravity** (`antigravity`)

## 功能特色 (Features)

- **互動式選單**：簡單直覺，免記指令。
- **跨編輯器遷移**：支援從 A 編輯器備份，還原到 B 編輯器（例如：Antigravity -> Cursor）。
- **智慧路徑偵測**：自動偵測「當前目錄」與「預設目錄」的備份，隨身碟一插即用。
- **混合式偵測**：同時支援 **System Install** (Program Files) 與 **User Install** (AppData) 路徑，自動修復環境變數。
- **自動環境刷新**：提供三種刷新方案，解決 Windows 環境變數不即時生效的痛點。
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
