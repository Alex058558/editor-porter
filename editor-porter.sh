#!/bin/zsh

# Editor Migration Script (macOS / Linux)
# Supports: code (VSCode), cursor, windsurf, antigravity

set -e

# Detect OS and set config paths
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux) echo "linux" ;;
        *) echo "unknown" ;;
    esac
}

OS=$(detect_os)

# Editor config paths
typeset -A CONFIG_PATHS
if [ "$OS" = "macos" ]; then
    CONFIG_PATHS=(
        code "$HOME/Library/Application Support/Code/User"
        cursor "$HOME/Library/Application Support/Cursor/User"
        windsurf "$HOME/Library/Application Support/Windsurf/User"
        antigravity "$HOME/Library/Application Support/Antigravity/User"
    )
elif [ "$OS" = "linux" ]; then
    CONFIG_PATHS=(
        code "$HOME/.config/Code/User"
        cursor "$HOME/.config/Cursor/User"
        windsurf "$HOME/.config/Windsurf/User"
        antigravity "$HOME/.config/Antigravity/User"
    )
else
    echo "Error: Unsupported OS. Use the PowerShell script for Windows."
    exit 1
fi

SUPPORTED_EDITORS=(code cursor windsurf antigravity)
DEFAULT_BACKUP_DIR="$HOME/.editor-backup"

usage() {
    echo "Usage: $0 [options] [backup-dir]"
    echo ""
    echo "Actions (required, pick one):"
    echo "  -e, --export    Export extensions and settings"
    echo "  -i, --import    Import extensions and settings"
    echo ""
    echo "Editors (required, pick one):"
    echo "  --code          VS Code"
    echo "  --cursor        Cursor"
    echo "  --windsurf      Windsurf"
    echo "  --antigravity   Antigravity"
    echo "  --all           All editors"
    echo ""
    echo "Backup directory: (optional, default: $DEFAULT_BACKUP_DIR)"
    echo ""
    echo "Examples:"
    echo "  $0 -e --antigravity           # Uses default path"
    echo "  $0 -e --all ~/my-backup       # Custom path"
    echo "  $0 -i --cursor"
    exit 1
}

check_editor_available() {
    local editor=$1
    if ! command -v "$editor" &> /dev/null; then
        echo "Warning: '$editor' command not found, skipping..."
        return 1
    fi
    return 0
}

# Convert keybindings between macOS and Windows/Linux
convert_keybindings() {
    local source_file=$1
    local target_file=$2
    local source_os=$3
    local target_os=$4

    if [ "$source_os" = "$target_os" ]; then
        cp "$source_file" "$target_file"
        return
    fi

    echo "  -> Converting keybindings from $source_os to $target_os..."

    if [ "$source_os" = "macos" ] && [ "$target_os" != "macos" ]; then
        # macOS -> Windows/Linux: cmd -> ctrl (order matters: specific patterns first)
        sed -e 's/"alt+cmd+/"ctrl+alt+/g' \
            -e 's/"shift+cmd+/"ctrl+shift+/g' \
            -e 's/"cmd+/"ctrl+/g' \
            -e 's/+cmd"/+ctrl"/g' \
            -e 's/+cmd+/+ctrl+/g' \
            "$source_file" > "$target_file"
    elif [ "$source_os" != "macos" ] && [ "$target_os" = "macos" ]; then
        # Windows/Linux -> macOS: ctrl -> cmd (but keep ctrl+alt as alt+cmd)
        sed -e 's/"ctrl+alt+/"alt+cmd+/g' \
            -e 's/"ctrl+shift+/"shift+cmd+/g' \
            -e 's/"ctrl+/"cmd+/g' \
            -e 's/+ctrl"/+cmd"/g' \
            -e 's/+ctrl+/+cmd+/g' \
            "$source_file" > "$target_file"
    else
        cp "$source_file" "$target_file"
    fi
}

export_editor() {
    local editor=$1
    local backup_dir=$2
    local target_dir="$backup_dir/$editor"
    local config_path="${CONFIG_PATHS[$editor]}"

    if ! check_editor_available "$editor"; then
        return
    fi

    echo "=== Exporting $editor ==="
    mkdir -p "$target_dir"

    # Save source OS metadata
    echo "$OS" > "$target_dir/.source_os"

    echo "  -> Exporting extensions..."
    "$editor" --list-extensions > "$target_dir/extensions.txt"
    local ext_count=$(wc -l < "$target_dir/extensions.txt" | tr -d ' ')
    echo "     Found $ext_count extensions"

    if [ -f "$config_path/settings.json" ]; then
        echo "  -> Copying settings.json..."
        cp "$config_path/settings.json" "$target_dir/"
    else
        echo "  -> settings.json not found, skipping..."
    fi

    if [ -f "$config_path/keybindings.json" ]; then
        echo "  -> Copying keybindings.json..."
        cp "$config_path/keybindings.json" "$target_dir/"
    else
        echo "  -> keybindings.json not found, skipping..."
    fi

    echo "  Done! Exported to: $target_dir"
    echo ""
}

import_editor() {
    local editor=$1
    local backup_dir=$2
    local source_dir="$backup_dir/$editor"
    local config_path="${CONFIG_PATHS[$editor]}"

    if ! check_editor_available "$editor"; then
        return
    fi

    if [ ! -d "$source_dir" ]; then
        echo "Error: Backup directory not found: $source_dir"
        return
    fi

    echo "=== Importing to $editor ==="

    # Read source OS from metadata
    local source_os="unknown"
    if [ -f "$source_dir/.source_os" ]; then
        source_os=$(cat "$source_dir/.source_os")
    fi

    if [ -f "$source_dir/extensions.txt" ]; then
        echo "  -> Installing extensions..."
        local total=$(wc -l < "$source_dir/extensions.txt" | tr -d ' ')
        local count=0
        while IFS= read -r ext || [ -n "$ext" ]; do
            if [ -n "$ext" ]; then
                count=$((count + 1))
                echo "     [$count/$total] $ext"
                "$editor" --install-extension "$ext" --force 2>/dev/null || echo "     Failed to install: $ext"
            fi
        done < "$source_dir/extensions.txt"
    else
        echo "  -> extensions.txt not found, skipping..."
    fi

    mkdir -p "$config_path"
    if [ -f "$source_dir/settings.json" ]; then
        echo "  -> Restoring settings.json..."
        cp "$source_dir/settings.json" "$config_path/"
    fi

    if [ -f "$source_dir/keybindings.json" ]; then
        if [ "$source_os" != "unknown" ] && [ "$source_os" != "$OS" ]; then
            convert_keybindings "$source_dir/keybindings.json" "$config_path/keybindings.json" "$source_os" "$OS"
        else
            echo "  -> Restoring keybindings.json..."
            cp "$source_dir/keybindings.json" "$config_path/"
        fi
    fi

    echo "  Done!"
    echo ""
}

# Parse arguments
ACTION=""
EDITOR=""
BACKUP_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--export) ACTION="export"; shift ;;
        -i|--import) ACTION="import"; shift ;;
        --code) EDITOR="code"; shift ;;
        --cursor) EDITOR="cursor"; shift ;;
        --windsurf) EDITOR="windsurf"; shift ;;
        --antigravity) EDITOR="antigravity"; shift ;;
        --all) EDITOR="all"; shift ;;
        -h|--help) usage ;;
        *)
            if [ -z "$BACKUP_DIR" ]; then
                BACKUP_DIR="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$ACTION" ] || [ -z "$EDITOR" ]; then
    usage
fi

# Use default backup dir if not specified
if [ -z "$BACKUP_DIR" ]; then
    BACKUP_DIR="$DEFAULT_BACKUP_DIR"
fi

echo "Detected OS: $OS"
echo "Backup directory: $BACKUP_DIR"
echo ""

case $ACTION in
    export)
        if [ "$EDITOR" = "all" ]; then
            for e in "${SUPPORTED_EDITORS[@]}"; do
                export_editor "$e" "$BACKUP_DIR"
            done
        else
            export_editor "$EDITOR" "$BACKUP_DIR"
        fi
        echo "Export complete! Backup saved to: $BACKUP_DIR"
        ;;
    import)
        if [ "$EDITOR" = "all" ]; then
            for e in "${SUPPORTED_EDITORS[@]}"; do
                import_editor "$e" "$BACKUP_DIR"
            done
        else
            import_editor "$EDITOR" "$BACKUP_DIR"
        fi
        echo "Import complete!"
        ;;
esac
