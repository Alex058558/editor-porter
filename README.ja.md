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

### PATH の問題解決 (Troubleshooting)

インストール後（VS Codeなど）にコマンドが見つからない場合は、以下の解決策を選んでください：

| 解決策              | 用途                    | コマンド                                                                                                               |
|---------------------|-------------------------|--------------------------------------------------------------------------------------------------------------------|
| **現在のウィンドウ**      | 今すぐこの端末で使いたい        | `iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Update-SessionPath.ps1 \| iex`  |
| **Explorer再起動**  | 今後開くウィンドウを修正する     | `iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/refresh-env.ps1 \| iex`         |
| **自動更新 (永続)** | 設定ファイルに追加して永久解決 | `iwr -useb https://raw.githubusercontent.com/Alex058558/editor-porter/main/scripts/Install-AutoRefresh.ps1 \| iex` |

## 対応エディタ

- **VS Code** (`code`)
- **Cursor** (`cursor`)
- **Windsurf** (`windsurf`)
- **Antigravity** (`antigravity`)

## 機能 (Features)

- **インタラクティブメニュー**：コマンドを覚える必要がなく、直感的に操作できます。
- **エディタ間移行 (Cross-Editor Migration)**：エディタAからバックアップし、エディタBに復元できます（例：Antigravity -> Cursor）。
- **スマートパス検出**：「現在のディレクトリ」（ローカル）と「デフォルトディレクトリ」のバックアップを自動検出します。
- **ハイブリッド検出**：PATH環境変数だけでなく、**System Install** (Program Files) と **User Install** (AppData) の両方をサポートし、環境変数を自動修復します。
- **自動環境変数更新**：Windows特有の環境変数が即時反映されない問題を解決する3つの更新プランを提供します。
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
