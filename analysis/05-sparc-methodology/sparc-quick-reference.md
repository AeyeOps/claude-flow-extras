# SPARC Quick Reference Guide

## SPARC = Specification → Pseudocode → Architecture → Refinement → Completion

## The 17 Development Modes

| Mode | Purpose | Best Use Case |
|------|---------|---------------|
| **orchestrator** | Multi-agent coordination | Complex projects needing multiple specialists |
| **coder** | Code implementation | Direct coding tasks |
| **researcher** | Information gathering | Technology research, best practices |
| **tdd** | Test-driven development | High-quality, tested features |
| **architect** | System design | Architecture planning |
| **reviewer** | Code review & QA | Quality assurance |
| **debugger** | Bug fixing | Troubleshooting issues |
| **tester** | Testing | Test suite creation |
| **analyzer** | Code analysis | Performance metrics |
| **optimizer** | Performance tuning | Speed improvements |
| **documenter** | Documentation | API docs, guides |
| **designer** | UI/UX design | Frontend design |
| **innovator** | Creative solutions | New approaches |
| **swarm-coordinator** | Swarm management | Large-scale coordination |
| **memory-manager** | Knowledge persistence | Project memory |
| **batch-executor** | Batch operations | Bulk processing |
| **workflow-manager** | Automation | CI/CD pipelines |

## Quick Commands

```bash
# List all modes
claude-flow sparc modes

# Run specific mode
claude-flow sparc run <mode> "<task>"

# Examples
claude-flow sparc run researcher "OAuth 2.0 best practices"
claude-flow sparc run tdd "user authentication"
claude-flow sparc run architect "microservices design"

# Default orchestrator mode
claude-flow sparc "Build shopping cart feature"
```

## Mode Selection Flowchart

```
New Feature? → orchestrator → researcher → architect → tdd/coder
Bug Fix? → debugger → coder → tester
Performance Issue? → analyzer → optimizer
Documentation? → documenter
Research Task? → researcher → memory-manager
Complex Project? → orchestrator (spawns multiple modes)
```

## Key Principles

1. **Start with Research**: Use researcher mode for unknowns
2. **Design First**: Use architect before coder
3. **Test Everything**: TDD or tester modes ensure quality
4. **Document Always**: Use documenter throughout
5. **Store Knowledge**: Use memory-manager for persistence