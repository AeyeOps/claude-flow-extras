# Claude-Flow Ink Raw Mode Fix

## Problem
When claude-flow spawns Claude instances, it creates a bash wrapper script that doesn't set the required environment variables, causing the "Raw mode is not supported" Ink error.

## Solution Applied
Patched the global claude-flow installation to add environment variables to the wrapper script.

### File Modified
`/home/steve/.nvm/versions/node/v22.14.0/lib/node_modules/claude-flow/dist/cli/commands/swarm.js`

### Change Made (Line 339-343)
```javascript
// Before:
const wrapperScript = `#!/bin/bash
claude ${claudeArgs.map(arg => `"${arg}"`).join(' ')} | tee "${agentDir}/output.txt"
exit \${PIPESTATUS[0]}`;

// After:
const wrapperScript = `#!/bin/bash
export CI=true
export CLAUDE_CODE_NON_INTERACTIVE=true
claude ${claudeArgs.map(arg => `"${arg}"`).join(' ')} | tee "${agentDir}/output.txt"
exit \${PIPESTATUS[0]}`;
```

## Benefits
- Single point fix for all 7 Claude profiles
- No need to modify individual Claude installations
- Works automatically for all claude-flow commands

## To Revert
If needed, remove the two export lines from the wrapper script in swarm.js

## To Reapply After claude-flow Update
If you update claude-flow globally (`npm update -g claude-flow`), you'll need to reapply this patch:

```bash
# Edit the file
nano /home/steve/.nvm/versions/node/v22.14.0/lib/node_modules/claude-flow/dist/cli/commands/swarm.js

# Find line ~339 with wrapperScript and add:
export CI=true
export CLAUDE_CODE_NON_INTERACTIVE=true

# Before the claude command
```

## Testing
Test with any swarm command:
```bash
ccmax.pdi05-flow swarm "test task" --max-agents 1
```

If you see Claude output without the Ink error, the fix is working.