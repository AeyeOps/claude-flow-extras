# Claude-Flow Quick Reference Card

## Essential Commands

### Basic Operations
```bash
# Start system with UI
claude-flow start --ui --port 3000

# Check system status
claude-flow status

# Monitor in real-time
claude-flow monitor
```

### Swarm Commands
```bash
# Research swarm
claude-flow swarm "Research topic" --strategy research --mode distributed --parallel

# Development swarm
claude-flow swarm "Build feature" --strategy development --mode hierarchical --max-agents 8

# Testing swarm
claude-flow swarm "Test system" --strategy testing --parallel --monitor
```

### SPARC Modes
```bash
# Orchestrator (complex coordination)
claude-flow sparc orchestrator "Coordinate project"

# TDD (test-driven development)
claude-flow sparc tdd "Feature with tests"

# Code mode
claude-flow sparc run coder "Implement feature"

# Architect mode
claude-flow sparc run architect "Design system"
```

### Memory Operations
```bash
# Store data
claude-flow memory store "key" "value"

# Retrieve data
claude-flow memory get "key"

# Export memory
claude-flow memory export project-state.json

# Import memory
claude-flow memory import project-state.json
```

## Key Patterns

### TodoWrite Pattern
```javascript
TodoWrite([
  {
    id: "task-1",
    content: "Task description",
    status: "pending",
    priority: "high",
    dependencies: [],
    parallel: true
  }
]);
```

### Task Spawning Pattern
```javascript
Task("Agent Name", "Task description", {
  mode: "coder",
  parallel: true,
  memoryNamespace: "project/context"
});
```

### Memory Coordination
```javascript
// Store shared context
Memory.store("project/architecture", architectureDoc);

// Reference in tasks
Task("Developer", "Implement using project/architecture from memory");
```

## Coordination Modes

| Mode | Use Case | Example |
|------|----------|---------|
| centralized | Simple tasks | Basic CRUD app |
| distributed | Independent work | Microservices |
| hierarchical | Structured projects | Enterprise apps |
| mesh | Complex dependencies | Data pipelines |
| hybrid | Mixed patterns | Full-stack apps |

## Strategy Types

| Strategy | Purpose | Best For |
|----------|---------|----------|
| research | Information gathering | Requirements analysis |
| development | Code creation | Feature implementation |
| analysis | Data processing | Performance optimization |
| testing | Quality assurance | Test suites |
| optimization | Performance tuning | Bottleneck resolution |
| maintenance | System upkeep | Updates & patches |

## Common Flags

```bash
--parallel          # Enable parallel execution
--monitor           # Real-time monitoring
--max-agents N      # Limit concurrent agents
--timeout N         # Set timeout (seconds)
--output FORMAT     # json, sqlite, csv, html
--non-interactive   # No prompts (automation)
--dry-run          # Show plan without executing
```

## Best Practices Checklist

- [ ] Use `--parallel` for independent tasks
- [ ] Enable `--monitor` for long operations
- [ ] Store context in Memory for coordination
- [ ] Use TodoWrite for complex workflows
- [ ] Batch similar operations together
- [ ] Set appropriate `--max-agents` limits
- [ ] Choose correct coordination mode
- [ ] Implement error handling with retries
- [ ] Use `--non-interactive` for automation
- [ ] Export Memory state regularly

## Performance Tips

1. **Parallel over Sequential**
   ```bash
   # Good
   claude-flow swarm "Task" --parallel
   
   # Avoid
   claude-flow sparc run coder "Task 1" && \
   claude-flow sparc run coder "Task 2"
   ```

2. **Batch Operations**
   ```javascript
   // Good
   TodoWrite([task1, task2, task3]);
   
   // Avoid
   TodoWrite([task1]);
   TodoWrite([task2]);
   TodoWrite([task3]);
   ```

3. **Memory Namespaces**
   ```javascript
   // Good - organized namespaces
   Memory.store("project/auth/config", authConfig);
   Memory.store("project/api/endpoints", apiDocs);
   
   // Avoid - flat structure
   Memory.store("authConfig", authConfig);
   Memory.store("apiDocs", apiDocs);
   ```

## Common Workflows

### Full Development Cycle
```bash
# 1. Research
claude-flow swarm "Research requirements" --strategy research

# 2. Design
claude-flow sparc run architect "System design"

# 3. Implement
claude-flow swarm "Build system" --strategy development --parallel

# 4. Test
claude-flow sparc tdd "Comprehensive tests"

# 5. Deploy
claude-flow sparc run workflow-manager "Deploy to production"
```

### Quick Feature Addition
```bash
# All in one command
claude-flow swarm "Add user authentication feature" \
  --strategy development \
  --mode hierarchical \
  --max-agents 5 \
  --monitor \
  --output ./features/auth
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Tasks not parallel | Add `--parallel` flag |
| Memory conflicts | Use unique namespaces |
| Resource exhaustion | Set `--max-agents` limit |
| Slow performance | Check coordination mode |
| Tasks failing | Add retry logic |

## Emergency Commands

```bash
# Stop all agents
claude-flow stop --all

# Clear memory
claude-flow memory cleanup

# Reset system
claude-flow reset --force

# Debug mode
claude-flow --debug [command]

# Verbose logging
claude-flow --verbose [command]
```

---
Keep this reference handy for quick Claude-Flow usage!