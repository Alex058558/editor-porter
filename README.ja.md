[![繁體中文](https://img.shields.io/badge/lang-繁體中文-blue.svg)](README.md)
[![English](https://img.shields.io/badge/lang-English-red.svg)](README.en.md)
[![日本語](https://img.shields.io/badge/lang-日本語-ff69b4.svg)](README.ja.md)

# Editor Porter

VS Code系エディタの拡張機能と設定をエクスポート・インポートするためのクロスプラットフォームCLIツールです。

## 機能

- 複数のVS Code系エディタをサポート
- クロスプラットフォーム対応（macOS / Linux / Windows）
- キーバインドの自動変換（cmd ↔ ctrl）
- デフォルトバックアップパスで簡単操作

## 対応エディタ

| エディタ        | CLIコマンド       |
|-------------|---------------|
| VS Code     | `code`        |
| Cursor      | `cursor`      |
| Windsurf    | `windsurf`    |
| Antigravity | `antigravity` |

## プラットフォーム別スクリプト

| プラットフォーム | スクリプト               |
|----------|---------------------|
| macOS    | `editor-porter.sh`  |
| Linux    | `editor-porter.sh`  |
| Windows  | `editor-porter.ps1` |

## インストール

### macOS / Linux

**方法1：直接ダウンロード**

```bash
curl -O https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.sh
chmod +x editor-porter.sh
```

**方法2：リポジトリをクローン**

```bash
git clone https://github.com/Alex058558/editor-porter.git
cd editor-porter
chmod +x editor-porter.sh
```

### Windows (PowerShell)

**方法1：直接ダウンロード**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.ps1" -OutFile "editor-porter.ps1"
```

**方法2：リポジトリをクローン**

```powershell
git clone https://github.com/Alex058558/editor-porter.git
cd editor-porter
```

## 使い方

### macOS / Linux

```bash
# 単一エディタをエクスポート（デフォルトパス ~/.editor-backup を使用）
./editor-porter.sh -e --code

# 全エディタをエクスポート
./editor-porter.sh -e --all

# 単一エディタにインポート
./editor-porter.sh -i --cursor

# カスタムバックアップパス
./editor-porter.sh -e --antigravity ~/my-backup
```

### Windows (PowerShell)

```powershell
# 単一エディタをエクスポート
.\editor-porter.ps1 -e -Code

# 全エディタをエクスポート
.\editor-porter.ps1 -e -All

# 単一エディタにインポート
.\editor-porter.ps1 -i -Cursor
```

## オプション

| オプション            | 説明                                   |
|------------------|----------------------------------------|
| `-e`, `--export` | 拡張機能と設定をエクスポート                   |
| `-i`, `--import` | 拡張機能と設定をインポート                    |
| `--code`         | VS Code                                |
| `--cursor`       | Cursor                                 |
| `--windsurf`     | Windsurf                               |
| `--antigravity`  | Antigravity                            |
| `--all`          | 全エディタ                                 |
| `[パス]`           | バックアップディレクトリ（デフォルト：`~/.editor-backup`） |

## エクスポートされる内容

| ファイル               | 説明                  |
|--------------------|-----------------------|
| `extensions.txt`   | インストール済み拡張機能のリスト |
| `settings.json`    | ユーザー設定              |
| `keybindings.json` | キーボードショートカット          |
| `.source_os`       | ソースOS（キーバインド変換用）   |

## キーバインドの自動変換

macOSからWindows/Linuxにインポートする際、自動的に変換されます：

| macOS         | Windows/Linux  |
|---------------|----------------|
| `cmd+s`       | `ctrl+s`       |
| `alt+cmd+h`   | `ctrl+alt+h`   |
| `shift+cmd+l` | `ctrl+shift+l` |

## ライセンス

MIT
