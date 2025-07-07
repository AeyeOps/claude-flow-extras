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

# Add aliases to .bashrc
cat >> ~/.bashrc << EOF

# === Claude-flow profile aliases ===
# Added by setup-claude-flow-aliases.sh on $(date)

# Claude-flow binary path
CLAUDE_FLOW_BIN="$CLAUDE_FLOW_PATH"

# Profile-specific claude-flow aliases
alias cc_pers-flow='CLAUDE_CONFIG_DIR=/home/steve/claude_code_pers PATH=/home/steve/claude_code_pers/local:\$PATH \$CLAUDE_FLOW_BIN'
alias cc_work-flow='CLAUDE_CONFIG_DIR=/home/steve/claude_code_work PATH=/home/steve/claude_code_work/local:\$PATH \$CLAUDE_FLOW_BIN'
alias ccmax.pdi01-flow='CLAUDE_CONFIG_DIR=/home/steve/ccmax.pdi01 PATH=/home/steve/ccmax.pdi01/local:\$PATH \$CLAUDE_FLOW_BIN'
alias ccmax.pdi02-flow='CLAUDE_CONFIG_DIR=/home/steve/ccmax.pdi02 PATH=/home/steve/ccmax.pdi02/local:\$PATH \$CLAUDE_FLOW_BIN'
alias ccmax.pdi03-flow='CLAUDE_CONFIG_DIR=/home/steve/ccmax.pdi03 PATH=/home/steve/ccmax.pdi03/local:\$PATH \$CLAUDE_FLOW_BIN'
alias ccmax.pdi04-flow='CLAUDE_CONFIG_DIR=/home/steve/ccmax.pdi04 PATH=/home/steve/ccmax.pdi04/local:\$PATH \$CLAUDE_FLOW_BIN'
alias ccmax.pdi05-flow='CLAUDE_CONFIG_DIR=/home/steve/ccmax.pdi05 PATH=/home/steve/ccmax.pdi05/local:\$PATH \$CLAUDE_FLOW_BIN'

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
    echo "  cc_pers-flow      - /home/steve/claude_code_pers"
    echo "  cc_work-flow      - /home/steve/claude_code_work"
    echo "  ccmax.pdi01-flow  - /home/steve/ccmax.pdi01"
    echo "  ccmax.pdi02-flow  - /home/steve/ccmax.pdi02"
    echo "  ccmax.pdi03-flow  - /home/steve/ccmax.pdi03"
    echo "  ccmax.pdi04-flow  - /home/steve/ccmax.pdi04"
    echo "  ccmax.pdi05-flow  - /home/steve/ccmax.pdi05"
    echo ""
    echo "Current profile: \$([ -n "\$CLAUDE_CONFIG_DIR" ] && echo "\$CLAUDE_CONFIG_DIR" || echo "none")"
}

# === End of Claude-flow aliases ===
EOF

echo ""
echo "✅ Successfully added claude-flow aliases to ~/.bashrc"
echo ""
echo "Available aliases:"
echo "  cc_pers-flow      - Use claude_code_pers profile"
echo "  cc_work-flow      - Use claude_code_work profile"
echo "  ccmax.pdi01-flow  - Use ccmax.pdi01 profile"
echo "  ccmax.pdi02-flow  - Use ccmax.pdi02 profile"
echo "  ccmax.pdi03-flow  - Use ccmax.pdi03 profile"
echo "  ccmax.pdi04-flow  - Use ccmax.pdi04 profile"
echo "  ccmax.pdi05-flow  - Use ccmax.pdi05 profile"
echo "  flow              - Short alias for claude-flow"
echo ""
echo "Helper functions:"
echo "  claude-profile       - Show current Claude profile"
echo "  claude-flow-aliases  - List all available aliases"
echo ""
echo "To activate these aliases, run:"
echo "  source ~/.bashrc"
echo ""
echo "Or start a new terminal session."