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

# Fallback paths for macOS when command is not in PATH
typeset -A FALLBACK_PATHS
if [ "$OS" = "macos" ]; then
    FALLBACK_PATHS=(
        code "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        cursor "/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
        windsurf "/Applications/Windsurf.app/Contents/Resources/app/bin/windsurf"
        antigravity "/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity"
    )
fi

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
    echo "Backup directory: (optional, default: ~/.editor-backup)"
    echo ""
    echo "Examples:"
    echo "  $0 -e --antigravity           # Export to default dir"
    echo "  $0 -i --antigravity           # Import from default dir"
    echo "  $0 -e --all ~/my-backup       # Export to custom path"
    exit 1
}

# Returns resolved command path or empty string if not found
get_editor_command() {
    local editor=$1
    
    # Try PATH first
    if command -v "$editor" &> /dev/null; then
        echo "$editor"
        return 0
    fi
    
    # Try fallback path
    local fallback="${FALLBACK_PATHS[$editor]}"
    if [ -n "$fallback" ] && [ -x "$fallback" ]; then
        echo "  (Using fallback path: $fallback)"
        echo "$fallback"
        return 0
    fi
    
    echo "Warning: '$editor' not found in PATH or default install location, skipping..."
    return 1
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

    local editor_cmd
    editor_cmd=$(get_editor_command "$editor")
    if [ $? -ne 0 ]; then
        return 1
    fi

    echo "=== Exporting $editor ==="
    mkdir -p "$target_dir"

    echo "$OS" > "$target_dir/.source_os"

    echo "  -> Exporting extensions..."
    "$editor_cmd" --list-extensions > "$target_dir/extensions.txt"
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
    return 0
}

import_editor() {
    local editor=$1
    local backup_dir=$2
    local source_editor=$3  # Optional: which editor's backup to use
    
    # Use source_editor if provided, otherwise use editor
    local source_name=${source_editor:-$editor}
    local source_dir="$backup_dir/$source_name"
    local config_path="${CONFIG_PATHS[$editor]}"

    local editor_cmd
    editor_cmd=$(get_editor_command "$editor")
    if [ $? -ne 0 ]; then
        return 1
    fi

    # Check if subdirectory exists, if not check if files are directly in backup_dir
    if [ ! -d "$source_dir" ]; then
        # Try flat structure (files directly in backup_dir)
        if [ -f "$backup_dir/extensions.txt" ] || [ -f "$backup_dir/settings.json" ]; then
            source_dir="$backup_dir"
            echo "  (Using flat directory structure)"
        else
            echo ""
            echo "[ERROR] No backup found for '$editor'."
            echo "        Looked in: $backup_dir"
            echo ""
            echo "[TIP] Did you run Export first? If transferring from another machine,"
            echo "      make sure to copy the backup folder to this location."
            return 1
        fi
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
        local success_count=0
        local failed_count=0
        local failed_list=""
        while IFS= read -r ext || [ -n "$ext" ]; do
            ext="${ext%$'\r'}"  # Handle Windows CRLF line endings
            if [ -n "$ext" ]; then
                count=$((count + 1))
                printf "     [%d/%d] %s " "$count" "$total" "$ext"
                if "$editor_cmd" --install-extension "$ext" --force >/dev/null 2>&1; then
                    printf "\033[32m[OK]\033[0m\n"
                    success_count=$((success_count + 1))
                else
                    printf "\033[31m[FAILED]\033[0m\n"
                    failed_count=$((failed_count + 1))
                    failed_list="$failed_list$ext\n"
                fi
            fi
        done < "$source_dir/extensions.txt"
        echo ""
        echo "  -> Extension Summary:"
        printf "     \033[32mSuccess: %d\033[0m / \033[31mFailed: %d\033[0m / Total: %d\n" "$success_count" "$failed_count" "$total"
        if [ $failed_count -gt 0 ]; then
            echo ""
            echo "     Failed extensions:"
            printf "$failed_list" | while read -r f; do
                [ -n "$f" ] && printf "       \033[31m- %s\033[0m\n" "$f"
            done
        fi
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
    return 0
}

# Parse arguments
ACTION=""
EDITOR=""
BACKUP_DIR=""
SOURCE=""  # For Import: which editor's backup to use

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--export) ACTION="export"; shift ;;
        -i|--import) ACTION="import"; shift ;;
        --code) EDITOR="code"; shift ;;
        --cursor) EDITOR="cursor"; shift ;;
        --windsurf) EDITOR="windsurf"; shift ;;
        --antigravity) EDITOR="antigravity"; shift ;;
        --all) EDITOR="all"; shift ;;
        --source) SOURCE="$2"; shift 2 ;;
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
        success_count=0
        if [ "$EDITOR" = "all" ]; then
            for e in "${SUPPORTED_EDITORS[@]}"; do
                if export_editor "$e" "$BACKUP_DIR"; then
                    success_count=$((success_count + 1))
                fi
            done
        else
            if export_editor "$EDITOR" "$BACKUP_DIR"; then
                success_count=$((success_count + 1))
            fi
        fi
        if [ $success_count -gt 0 ]; then
            echo "Export complete! Backup saved to: $BACKUP_DIR"
        else
            echo "No editors were exported. Please check if the editor is installed."
        fi
        ;;
    import)
        success_count=0
        if [ "$EDITOR" = "all" ]; then
            for e in "${SUPPORTED_EDITORS[@]}"; do
                if import_editor "$e" "$BACKUP_DIR" "$SOURCE"; then
                    success_count=$((success_count + 1))
                fi
            done
        else
            if import_editor "$EDITOR" "$BACKUP_DIR" "$SOURCE"; then
                success_count=$((success_count + 1))
            fi
        fi
        if [ $success_count -gt 0 ]; then
            echo "Import complete!"
        else
            echo "No editors were imported. Please check if the editor is installed and backup exists."
        fi
        ;;
esac
