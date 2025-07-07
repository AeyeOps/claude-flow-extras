# Claude-Flow CLI Command Structure Analysis

## Overview
Claude-Flow uses a custom CLI framework built on Node.js (not Deno/Cliffy as some files suggest). The main CLI implementation is in `/src/cli/cli-core.ts` with commands registered in `/src/cli/commands/index.ts`.

## CLI Architecture

### Core Components
1. **CLI Class** (`cli-core.ts`): Main command router and argument parser
2. **Command Interface**: Defines command structure with name, description, aliases, subcommands, and action
3. **CommandContext**: Passes parsed arguments, flags, and config to command handlers
4. **Command Registration**: Commands are registered via `cli.command()` method

### Command Structure
```typescript
interface Command {
  name: string;
  description: string;
  aliases?: string[];
  subcommands?: Command[];
  action?: (ctx: CommandContext) => Promise<void> | void;
  options?: Option[];
}

interface CommandContext {
  args: string[];
  flags: Record<string, unknown>;
  config?: Record<string, unknown>;
}
```

## Complete Command List

### 1. **init** - Initialize Claude Code integration files
- **Options**:
  - `--force`: Force overwrite existing files
  - `--minimal`: Create minimal configuration

### 2. **start** - Start the orchestration system
- **Options**:
  - `--daemon`: Run as daemon
  - `--port <number>`: Specify port (default: 3000)
  - `--ui`: Enable web UI
  - `--host <string>`: Specify host
- **Enhanced version available** with comprehensive service management

### 3. **status** - Show system status
- **Options**:
  - `--watch, -w`: Watch mode - continuously update
  - `--interval, -i <number>`: Update interval in seconds (default: 5)
  - `--component, -c <string>`: Show status for specific component
  - `--json`: Output in JSON format
  - `--detailed`: Show detailed component information
  - `--health-check`: Perform comprehensive health checks
  - `--history`: Show status history from logs
  - `--verbose, -v`: Enable verbose output

### 4. **monitor** - Live monitoring dashboard
- **Options**:
  - `--interval, -i <number>`: Update interval (default: 2)
  - `--compact, -c`: Compact view mode
  - `--focus, -f <string>`: Focus on specific component
  - `--alerts`: Enable alert notifications
  - `--export <string>`: Export monitoring data to file
  - `--threshold <number>`: Alert threshold percentage (default: 80)
  - `--log-level <string>`: Log level filter (default: "info")
  - `--no-graphs`: Disable ASCII graphs

### 5. **task** - Manage tasks
- **Subcommands**:
  - `create <type> [description]`: Create new task
  - `list`: List all tasks
  - `assign <taskId> <agentId>`: Assign task to agent
  - `workflow <file>`: Execute workflow file

### 6. **agent** - Comprehensive agent management
- **Subcommands**:
  - `spawn <type>`: Create new agent (types: researcher, coder, analyst, etc.)
  - `list`: List all active agents
  - `info <agentId>`: Get detailed agent information
  - `terminate <agentId>`: Terminate an agent
  - `start <agentId>`: Start a stopped agent
  - `restart <agentId>`: Restart an agent
  - `pool`: Manage agent pools
  - `health`: Check agent health

### 7. **mcp** - Manage MCP server and tools
- **Subcommands**:
  - `start`: Start MCP server
    - `--port <number>`: Server port (default: 3000)
    - `--host <string>`: Server host
  - `stop`: Stop MCP server
  - `status`: Show MCP server status
  - `tools`: List available MCP tools
  - `config`: Show MCP configuration
  - `restart`: Restart MCP server
  - `logs`: View MCP server logs
    - `--lines <number>`: Number of lines to show

### 8. **memory** - Manage memory bank
- **Subcommands**:
  - `store <key> <value>`: Store data in memory
  - `query <search>`: Search memory entries
  - `export <file>`: Export memory to file
  - `import <file>`: Import memory from file
  - `stats`: Show memory statistics

### 9. **claude** - Spawn Claude instances
- **Options**:
  - `--tools, -t <string>`: Specify allowed tools
  - `--no-permissions`: Skip permission prompts
  - `--config, -c <string>`: Path to MCP config
  - `--mode, -m <string>`: Development mode (full, backend-only, frontend-only, api-only)
  - `--parallel`: Enable BatchTool and parallel execution
  - `--research`: Enable WebFetchTool
  - `--coverage <number>`: Test coverage target (default: 80)
  - `--commit <string>`: Commit frequency (phase, feature, manual)
  - `--verbose, -v`: Enable verbose output
  - `--dry-run, -d`: Preview command without executing

### 10. **swarm** - Create self-orchestrating Claude agent swarms
- **Options**:
  - `--strategy <string>`: Swarm strategy (research, development, analysis, testing, optimization, maintenance)
  - `--max-agents <number>`: Maximum agents (default: 5)
  - `--max-depth <number>`: Maximum task depth
  - `--research`: Enable research mode
  - `--parallel`: Enable parallel execution
  - `--mode <string>`: Coordination mode (centralized, distributed, hierarchical, mesh, hybrid)
  - `--monitor`: Real-time monitoring
  - `--output <string>`: Output format (json, sqlite, csv, html)

### 11. **sparc** - Enhanced SPARC-based TDD development
- **Subcommands**:
  - `modes`: List available SPARC modes
  - `info <mode>`: Show mode information
  - `run <mode> <task>`: Run specific SPARC mode
  - `tdd <feature>`: Test-driven development mode
  - `workflow <file>`: Run SPARC workflow
- **Available modes**: orchestrator, coder, researcher, tdd, architect, reviewer, debugger, tester, analyzer, optimizer, documenter, designer, innovator, swarm-coordinator, memory-manager, batch-executor, workflow-manager

### 12. **config** - Manage configuration (Enhanced)
- **Subcommands**:
  - `show`: Display current configuration
    - `--format <string>`: Output format (json, yaml)
    - `--diff`: Show only differences from defaults
    - `--profile`: Include profile information
  - `get <path>`: Get specific config value
  - `set <path> <value>`: Set config value
    - `--type <string>`: Value type (string, number, boolean, json)
    - `--reason <string>`: Reason for change (audit trail)
    - `--force`: Skip validation warnings
  - `init`: Initialize configuration
    - `--template <string>`: Use template (development, production)
  - `validate`: Validate configuration file
  - `reset`: Reset to defaults
  - `profile save <name>`: Save configuration profile
  - `profile load <name>`: Load configuration profile

### 13. **migrate** - Database migration management
- Created via `createMigrateCommand()` function

### 14. **swarm-ui** - Swarm with blessed UI (wrapper)
- Convenience wrapper for swarm with UI enabled

### 15. **session** - Enhanced session management
- **Subcommands**:
  - `save <name>`: Save current session
  - `list`: List saved sessions
  - `restore <sessionId>`: Restore session
  - `export <sessionId> <file>`: Export session
  - `clean`: Clean up old sessions

### 16. **workflow** - Workflow execution
- Execute workflow automation files

### 17. **help** - Comprehensive help system
- **Options**:
  - `--interactive, -i`: Interactive help mode
  - `--examples, -e`: Show examples
  - `--tutorial`: Show tutorial
  - `--all`: Show all topics

### 18. **repl** - Interactive REPL mode
- Start interactive command-line interface

## Enterprise Commands (Additional)

### 1. **project** - Project management
- **Subcommands**:
  - `create <name>`: Create new project
  - `list`: List all projects
  - `switch <name>`: Switch active project
  - `delete <name>`: Delete project
  - `info <name>`: Project details

### 2. **deploy** - Deployment operations
- **Subcommands**:
  - `create`: Create deployment
  - `list`: List deployments
  - `status <id>`: Deployment status
  - `rollback <id>`: Rollback deployment
  - `promote <id>`: Promote to next environment

### 3. **cloud** - Cloud infrastructure management
- **Subcommands**:
  - `providers`: List cloud providers
  - `resources`: List resources
  - `provision`: Provision resources
  - `terminate`: Terminate resources
  - `cost`: Cost analysis

### 4. **security** - Security and compliance tools
- **Subcommands**:
  - `scan`: Run security scan
  - `audit`: Security audit
  - `compliance`: Compliance check
  - `vulnerabilities`: List vulnerabilities
  - `policies`: Manage security policies

### 5. **analytics** - Analytics and insights
- **Subcommands**:
  - `dashboard`: Analytics dashboard
  - `metrics`: View metrics
  - `reports`: Generate reports
  - `export`: Export analytics data

## Command Implementation Patterns

### 1. **Action Pattern**
Most commands follow this pattern:
```typescript
export async function commandAction(ctx: CommandContext): Promise<void> {
  const subcommand = ctx.args[0];
  
  switch (subcommand) {
    case "subcommand1":
      await handleSubcommand1(ctx);
      break;
    case "subcommand2":
      await handleSubcommand2(ctx);
      break;
    default:
      await showHelp();
      break;
  }
}
```

### 2. **Manager Pattern**
Commands often use singleton managers:
```typescript
let manager: Manager | null = null;

async function getManager(): Promise<Manager> {
  if (!manager) {
    manager = new Manager();
    await manager.initialize();
  }
  return manager;
}
```

### 3. **Error Handling Pattern**
```typescript
try {
  const result = await operation();
  success("Operation completed");
} catch (err) {
  error(`Failed: ${err.message}`);
}
```

## Command Registration Flow

1. **Main Entry**: Commands are registered in `setupCommands()` function
2. **Registration**: Uses `cli.command()` to register each command
3. **Options**: Global options (help, version, config, verbose, log-level) are pre-defined
4. **Execution**: CLI parses args and routes to appropriate command action
5. **Context**: CommandContext provides parsed args, flags, and config to handlers

## Key Features

1. **Batch Operations**: Many commands support batch operations for efficiency
2. **Enhanced Versions**: Some commands (start, status, monitor, session) have enhanced versions
3. **Interactive Modes**: Help and REPL provide interactive experiences
4. **Configuration Profiles**: Support for multiple configuration profiles
5. **Audit Trail**: Configuration changes are tracked with user and reason
6. **Real-time Monitoring**: Live dashboards and continuous status updates
7. **Enterprise Features**: Additional commands for enterprise deployments
8. **SPARC Integration**: Specialized development modes via SPARC system

## Command Execution Flow

1. User runs `claude-flow <command> [args] [options]`
2. CLI parses arguments using custom parser
3. Global flags (help, version) are checked first
4. Command is looked up in registered commands map
5. Command action is executed with CommandContext
6. Results are displayed using color-coded output functions
7. Exit codes indicate success (0) or failure (1)

## Best Practices

1. **Consistent Options**: Use consistent option names across commands
2. **Help Text**: Every command includes comprehensive help
3. **Error Messages**: Clear, actionable error messages
4. **Color Coding**: Success (green), Error (red), Warning (yellow), Info (blue)
5. **Verbose Mode**: Additional details available with --verbose
6. **JSON Output**: Machine-readable output with --json flag
7. **Dry Run**: Preview actions with --dry-run where applicable