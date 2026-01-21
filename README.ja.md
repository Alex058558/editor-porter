[![繁體中文](https://img.shields.io/badge/lang-繁體中文-blue.svg)](README.md)
[![English](https://img.shields.io/badge/lang-English-red.svg)](README.en.md)
[![日本語](https://img.shields.io/badge/lang-日本語-ff69b4.svg)](README.ja.md)

# Editor Porter

VS Code系エディタの拡張機能と設定をエクスポート・インポートするためのクロスプラットフォームCLIツールです。

## 使い方 (Usage)

**インストール不要 (One-Liner)** ツールとして設計されています。以下のコマンドをコピーして実行するだけで、バックアップや復元を行えます。

### macOS / Linux
```bash
# ダウンロードして実行（インタラクティブメニュー）
bash <(curl -sL https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.sh)
```

### Windows (PowerShell)
```powershell
# ダウンロードして実行（インタラクティブメニュー）
powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/porter-ghost.ps1 | iex"
```

> **注意**：自動環境変数更新機能が含まれているため、新しいエディタをインストールした後でも再起動なしで即座に検出されます。



## 対応エディタ

- **VS Code** (`code`)
- **Cursor** (`cursor`)
- **Windsurf** (`windsurf`)
- **Antigravity** (`antigravity`)

## 機能 (Features)

- **インタラクティブメニュー**：コマンドを覚える必要がなく、直感的に操作できます。
- **環境変数自動更新**：エディタインストール後、再起動なしで認識されます。
- **スマートパス**：デフォルトで `~/.editor-backup` に保存されます（変更可能）。
- **クロスプラットフォーム**：Windows / macOS / Linux 共通のワークフロー。

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
