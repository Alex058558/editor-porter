#!/bin/bash
# Porter Ephemeral Runner (macOS/Linux Version)
# Downloads, runs locally, and cleans up. No traces left.

URL="https://raw.githubusercontent.com/Alex058558/editor-porter/main/editor-porter.sh"
TEMP_FILE=$(mktemp)

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${CYAN}⏳ Fetching magic wand...${NC}"
curl -s -o "$TEMP_FILE" "$URL"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to download tool.${NC}"
    exit 1
fi
chmod +x "$TEMP_FILE"

# ⚡ Auto-Refresh Environment (Mac/Linux)
# Ensure /usr/local/bin is in PATH (standard location for 'code'/'cursor')
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    export PATH="/usr/local/bin:$PATH"
    echo -e "${YELLOW}⚡ Added /usr/local/bin to PATH.${NC}"
fi
# Clear command cache
hash -r 2>/dev/null

while true; do
    clear
    echo -e "${MAGENTA}👻 Ghost Porter - One-time Migration Tool${NC}"
    echo "========================================"
    echo "1. 📤 Export (Backup Settings)"
    echo "2. 📥 Import (Restore Settings)"
    echo "q. 🚪 Quit & Clean Up"
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
    
    echo -e "\n${GREEN}🚀 Running...${NC}"
    "$TEMP_FILE" $mode $flag
    
    echo -e "\n✅ Done! Press Enter to continue..."
    read
done

# Cleanup
echo -e "\n${CYAN}🧹 Cleaning up traces...${NC}"
rm "$TEMP_FILE"
echo -e "${GREEN}✨ All gone. Have a nice day!${NC}"
