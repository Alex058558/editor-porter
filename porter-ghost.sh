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
    
    mode=""
    if [ "$action" == "1" ]; then mode="-e"; fi
    if [ "$action" == "2" ]; then mode="-i"; fi
    
    if [ -z "$mode" ]; then continue; fi

    echo ""
    echo -e "${YELLOW}Select Target Editor:${NC}"
    echo "1. VS Code (code)"
    echo "2. Cursor"
    echo "3. Windsurf"
    echo "4. Antigravity"
    echo "5. All Editors"
    
    read -p "Select Editor: " target
    flag=""
    case $target in
        1) flag="--code" ;;
        2) flag="--cursor" ;;
        3) flag="--windsurf" ;;
        4) flag="--antigravity" ;;
        5) flag="--all" ;;
        *) continue ;;
    esac
    
    echo ""
    echo -e "${GREEN}Running...${NC}"
    
    # Process Substitution: <(curl ...) creates a file descriptor
    bash <(curl -s "$URL") $mode $flag
    
    echo ""
    echo -e "${GRAY}[Done] Press Enter to continue...${NC}"
    read
done

echo ""
echo -e "${GREEN}Bye!${NC}"
