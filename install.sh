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
TARGET_CMD='bash "$HOME/.claude/statusline.sh"'

if [ ! -f "$SETTINGS" ]; then
    echo "Creating $SETTINGS..."
    echo "{}" > "$SETTINGS"
fi

set_statusline() {
    tmp=$(mktemp)
    jq '. + {statusLine: {type: "command", command: "bash \"$HOME/.claude/statusline.sh\""}}' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
    echo "  -> statusLine configured"
}

existing_cmd=$(jq -r '.statusLine.command // .statusLine // empty' "$SETTINGS" 2>/dev/null)

if [ -z "$existing_cmd" ]; then
    echo "Adding statusLine to settings.json..."
    set_statusline
elif [ "$existing_cmd" = "$TARGET_CMD" ]; then
    echo "statusLine already configured with ctxstat — nothing to do."
else
    echo ""
    echo "statusLine already set to a different config:"
    echo "  current: $existing_cmd"
    echo "  new:     $TARGET_CMD"
    echo ""
    printf "Replace with ctxstat? [y/N] "
    read -r answer </dev/tty
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        set_statusline
    else
        echo "Skipped. statusLine unchanged."
    fi
fi

echo ""
echo "Done. Start a Claude Code session to see ctxstat."
