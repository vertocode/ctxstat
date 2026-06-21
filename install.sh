#!/bin/bash
set -e

REPO="https://raw.githubusercontent.com/vertocode/ctxstat/main"
CLAUDE_DIR="$HOME/.claude"
SCRIPT="$CLAUDE_DIR/statusline.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "ctxstat installer"
echo "-----------------"

# 1. Create ~/.claude if missing
mkdir -p "$CLAUDE_DIR"

# 2. Download statusline.sh
echo "Downloading statusline.sh..."
curl -fsSL "$REPO/statusline.sh" -o "$SCRIPT"
chmod +x "$SCRIPT"
echo "  -> $SCRIPT"

# 3. Check for jq
if ! command -v jq &>/dev/null; then
    echo ""
    echo "Warning: jq not found. Install it for full functionality:"
    echo "  macOS:  brew install jq"
    echo "  Ubuntu: sudo apt install jq"
    echo ""
fi

# 4. Patch settings.json
if [ ! -f "$SETTINGS" ]; then
    echo "Creating $SETTINGS..."
    echo "{}" > "$SETTINGS"
fi

existing=$(jq -r '.statusLine // empty' "$SETTINGS" 2>/dev/null)
if [ -n "$existing" ]; then
    echo "statusLine already set in settings.json — skipping."
else
    echo "Adding statusLine to settings.json..."
    tmp=$(mktemp)
    jq '. + {statusLine: {type: "command", command: "bash \"$HOME/.claude/statusline.sh\""}}' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
    echo "  -> statusLine configured"
fi

echo ""
echo "Done. Start a Claude Code session to see ctxstat."
