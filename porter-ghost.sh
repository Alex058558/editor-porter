#!/bin/bash
# Porter Ephemeral Runner (Memory Mode)
# Downloads script into memory and runs it. No temp files.

URL="https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.sh"

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ⚡ Auto-Refresh Environment (Mac/Linux)
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="/usr/local/bin:$PATH"
fi
hash -r 2>/dev/null

while true; do
    clear
    echo -e "${MAGENTA}👻 Ghost Porter - One-time Migration Tool (In-Memory)${NC}"
    echo "========================================"
    echo "1. 📤 Export (Backup Settings)"
    echo "2. 📥 Import (Restore Settings)"
    echo "q. 🚪 Quit"
    echo "========================================"
    
    read -p "Select Action: " action
    if [ "$action" == "q" ]; then break; fi
    
    mode=""
    if [ "$action" == "1" ]; then mode="-e"; fi
    if [ "$action" == "2" ]; then mode="-i"; fi
    
    if [ -z "$mode" ]; then continue; fi

    echo -e "\n${YELLOW}🎯 Select Target Editor:${NC}"
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
    
    echo -e "\n${GREEN}🚀 Running from Memory...${NC}"
    
    # Process Substitution: <(curl ...) creates a file descriptor that bash treats as a file
    bash <(curl -s "$URL") $mode $flag
    
    echo -e "\n✅ Done! Press Enter to continue..."
    read
done

echo -e "\n${GREEN}✨ Bye! (No cleanup needed)${NC}"
