#!/bin/bash
# Setup script for claude-flow profile aliases
# This script adds convenient aliases to use claude-flow with different Claude profiles

set -e

echo "=== Setting up claude-flow profile aliases ==="

# Check if claude-flow is installed globally
if ! command -v claude-flow &> /dev/null; then
    echo "Error: claude-flow is not installed globally"
    echo "Please run: npm install -g claude-flow"
    exit 1
fi

echo "Found claude-flow at: $(which claude-flow)"
echo "Version: $(claude-flow --version)"

# Create backup of .bashrc
cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)
echo "Created backup of ~/.bashrc"

# Get claude-flow full path
CLAUDE_FLOW_PATH=$(which claude-flow)
echo "Using claude-flow path: $CLAUDE_FLOW_PATH"

# Get user home directory
USER_HOME=$HOME

# Add aliases to .bashrc
cat >> ~/.bashrc << EOF

# === Claude-flow profile aliases ===
# Added by setup-claude-flow-aliases.sh on $(date)

# Claude-flow binary path
CLAUDE_FLOW_BIN="$CLAUDE_FLOW_PATH"

# Example profile-specific claude-flow aliases
# Customize these paths based on your Claude installation locations
alias claude-flow-personal='CLAUDE_CONFIG_DIR=\$HOME/claude-personal PATH=\$HOME/claude-personal/local:\$PATH \$CLAUDE_FLOW_BIN'
alias claude-flow-work='CLAUDE_CONFIG_DIR=\$HOME/claude-work PATH=\$HOME/claude-work/local:\$PATH \$CLAUDE_FLOW_BIN'
alias claude-flow-dev='CLAUDE_CONFIG_DIR=\$HOME/claude-dev PATH=\$HOME/claude-dev/local:\$PATH \$CLAUDE_FLOW_BIN'

# Short alias for claude-flow (uses current CLAUDE_CONFIG_DIR if set)
alias flow='\$CLAUDE_FLOW_BIN'

# Helper function to show current Claude profile
claude-profile() {
    if [ -n "\$CLAUDE_CONFIG_DIR" ]; then
        echo "Current Claude profile: \$CLAUDE_CONFIG_DIR"
    else
        echo "No Claude profile set (CLAUDE_CONFIG_DIR is empty)"
        echo "Use one of the profile aliases or set CLAUDE_CONFIG_DIR"
    fi
}

# Helper function to list available flow aliases
claude-flow-aliases() {
    echo "Available claude-flow profile aliases:"
    echo "  claude-flow-personal  - Personal development profile"
    echo "  claude-flow-work      - Work profile"
    echo "  claude-flow-dev       - Development/testing profile"
    echo "  flow                  - Short alias for claude-flow"
    echo ""
    echo "Current profile: \$([ -n "\$CLAUDE_CONFIG_DIR" ] && echo "\$CLAUDE_CONFIG_DIR" || echo "none")"
    echo ""
    echo "To create custom profiles, add aliases like:"
    echo "  alias my-flow='CLAUDE_CONFIG_DIR=\$HOME/my-claude PATH=\$HOME/my-claude/local:\$PATH \$CLAUDE_FLOW_BIN'"
}

# === End of Claude-flow aliases ===
EOF

echo ""
echo "✅ Successfully added claude-flow aliases to ~/.bashrc"
echo ""
echo "Example aliases added (customize the paths as needed):"
echo "  claude-flow-personal  - Personal development profile"
echo "  claude-flow-work      - Work profile" 
echo "  claude-flow-dev       - Development/testing profile"
echo "  flow                  - Short alias for claude-flow"
echo ""
echo "Helper functions:"
echo "  claude-profile       - Show current Claude profile"
echo "  claude-flow-aliases  - List all available aliases"
echo ""
echo "To customize aliases for your specific Claude installations:"
echo "1. Edit ~/.bashrc"
echo "2. Update the paths in the alias definitions"
echo "3. Add new aliases following the same pattern"
echo ""
echo "To activate these aliases, run:"
echo "  source ~/.bashrc"
echo ""
echo "Or start a new terminal session."