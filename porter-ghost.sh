#!/bin/bash
# Porter Ephemeral Runner (Memory Mode)
# Downloads script into memory and runs it. No temp files.

URL="https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.sh"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
GRAY='\033[0;90m'
NC='\033[0m'

echo -e "${CYAN}Fetching script (Memory Mode)...${NC}"

# Auto-Refresh Environment (Mac/Linux)
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="/usr/local/bin:$PATH"
fi
hash -r 2>/dev/null
echo -e "${GRAY}[OK] Environment variables refreshed.${NC}"

# Editor selection helper
get_editor_choice() {
    local prompt=$1
    local show_status=$2
    local backup_root="$HOME/.editor-backup"
    
    get_status() {
        local name=$1
        if [ "$show_status" != "true" ]; then return; fi
        
        # Check current directory first
        if [ -d "./$name" ]; then
            echo " [Local Backup Found]"
        elif [ -d "$backup_root/$name" ] || [ -f "$backup_root/$name" ]; then
            echo " [Default Backup Found]"
        else
            echo " [No Backup]"
        fi
    }

    echo ""
    echo -e "${YELLOW}${prompt}${NC}"
    echo "1. VS Code$(get_status "code")"
    echo "2. Cursor$(get_status "cursor")"
    echo "3. Windsurf$(get_status "windsurf")"
    echo "4. Antigravity$(get_status "antigravity")"
    read -p "Select: " choice
    case $choice in
        1) echo "code" ;;
        2) echo "cursor" ;;
        3) echo "windsurf" ;;
        4) echo "antigravity" ;;
        *) echo "" ;;
    esac
}

while true; do
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${MAGENTA}Ghost Porter - Migration Tool${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo "1. Export (Backup Settings)"
    echo "2. Import (Restore Settings)"
    echo "q. Quit"
    echo -e "${CYAN}========================================${NC}"
    
    read -p "Select Action: " action
    if [ "$action" == "q" ]; then break; fi
    
    if [ "$action" == "1" ]; then
        # Export flow
        editor=$(get_editor_choice "Export FROM which editor?")
        if [ -z "$editor" ]; then continue; fi
        
        echo ""
        echo -e "${GREEN}Running Export...${NC}"
        zsh <(curl -s "$URL") -e --$editor
        
    elif [ "$action" == "2" ]; then
        # Import flow - ask for Source and Target
        source_editor=$(get_editor_choice "Import FROM which editor's backup?" "true")
        if [ -z "$source_editor" ]; then continue; fi
        
        target_editor=$(get_editor_choice "Import TO which editor?")
        if [ -z "$target_editor" ]; then continue; fi
        
        # Determine Backup Directory to use
        backup_dir_arg=""
        if [ -d "./$source_editor" ]; then
             echo -e "${CYAN}Using Local Backup in current directory...${NC}"
             backup_dir_arg="$(pwd)"
        else
             echo -e "${CYAN}Using Default Backup directory...${NC}"
        fi

        echo ""
        echo -e "${GREEN}Running Import ($source_editor -> $target_editor)...${NC}"
        
        if [ -n "$backup_dir_arg" ]; then
             zsh <(curl -s "$URL") -i --$target_editor --source $source_editor "$backup_dir_arg"
        else
             zsh <(curl -s "$URL") -i --$target_editor --source $source_editor
        fi
        
    else
        continue
    fi
    
    echo ""
    echo -e "${GRAY}[Done] Press Enter to continue...${NC}"
    read
done

echo ""
echo -e "${GREEN}Bye!${NC}"
