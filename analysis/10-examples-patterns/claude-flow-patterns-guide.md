# Claude-Flow Examples and Usage Patterns Guide

## Table of Contents
1. [Pattern Catalog](#pattern-catalog)
2. [Workflow Templates](#workflow-templates)
3. [Best Practices](#best-practices)
4. [Common Pitfalls](#common-pitfalls)
5. [Real-World Examples](#real-world-examples)

## Pattern Catalog

### 1. Batch Operations Pattern
**Description**: Use parallel operations for maximum efficiency

#### TodoWrite Coordination
```javascript
// Coordinate multiple tasks with dependencies
TodoWrite([
  {
    id: "architecture_design",
    content: "Design system architecture and component interfaces",
    status: "pending",
    priority: "high",
    dependencies: [],
    estimatedTime: "60min",
    assignedAgent: "architect"
  },
  {
    id: "frontend_development", 
    content: "Develop React components and user interface",
    status: "pending",
    priority: "medium",
    dependencies: ["architecture_design"],
    estimatedTime: "120min",
    assignedAgent: "frontend_team"
  },
  {
    id: "backend_development",
    content: "Implement API endpoints and business logic",
    status: "pending",
    priority: "medium",
    dependencies: ["architecture_design"],
    estimatedTime: "120min",
    assignedAgent: "backend_team"
  }
]);
```

#### Task Tool for Parallel Agents
```javascript
// Launch specialized agents in parallel
Task("System Architect", "Design architecture and store specs in Memory");
Task("Frontend Team", "Develop UI using Memory architecture specs");
Task("Backend Team", "Implement APIs according to Memory specifications");
```

### 2. Swarm Coordination Patterns

#### Research Swarm
```bash
# Distributed research with multiple agents
claude-flow swarm "Research modern web frameworks" \
  --strategy research \
  --mode distributed \
  --parallel \
  --max-agents 6 \
  --monitor

# With output persistence
claude-flow swarm "Analyze market trends in AI" \
  --strategy research \
  --output sqlite \
  --output-dir ./research-results
```

#### Development Swarm
```bash
# Hierarchical development for complex projects
claude-flow swarm "Build microservice API" \
  --strategy development \
  --mode hierarchical \
  --max-agents 8 \
  --monitor

# With specific focus areas
claude-flow swarm "Create React dashboard with real-time updates" \
  --strategy development \
  --parallel \
  --monitor
```

#### Analysis Swarm
```bash
# Mesh pattern for complex data analysis
claude-flow swarm "Analyze user behavior patterns from logs" \
  --strategy analysis \
  --mode mesh \
  --parallel \
  --output sqlite
```

### 3. SPARC Mode Patterns

#### Orchestrator Pattern
```bash
# Complex multi-agent coordination
./claude-flow sparc orchestrator "Build e-commerce platform with payment integration"

# With specific configuration
./claude-flow sparc run orchestrator "Coordinate microservices development" \
  --max-agents 10 \
  --coordination centralized
```

#### TDD Pattern
```bash
# Test-driven development workflow
./claude-flow sparc tdd "User authentication system with JWT tokens"

# Feature development with tests
./claude-flow sparc tdd "Shopping cart functionality with persistence"
```

#### Workflow Manager Pattern
```bash
# Automated deployment pipeline
./claude-flow sparc run workflow-manager "CI/CD pipeline with staging and production"

# Complex workflow automation
./claude-flow sparc run workflow-manager "Data migration with validation and rollback"
```

### 4. Memory Integration Patterns

#### Architecture Decision Records
```bash
# Store key decisions
claude-flow memory store "system_architecture" "Microservices with API Gateway pattern"
claude-flow memory store "database_choice" "PostgreSQL with read replicas"

# Reference in subsequent operations
claude-flow sparc run coder "Implement user service based on system_architecture in memory"
```

#### Cross-Session State
```bash
# Save project state
claude-flow memory export project-state.json

# Restore in new session
claude-flow memory import project-state.json
```

## Workflow Templates

### 1. Full Application Development

```bash
# Phase 1: Research and Planning
claude-flow swarm "Research best practices for e-commerce platforms" \
  --strategy research \
  --mode distributed \
  --parallel \
  --output ./research

# Phase 2: Architecture Design
claude-flow sparc run architect "Design scalable e-commerce architecture"
claude-flow memory store "architecture" "Output from architect"

# Phase 3: Parallel Implementation
claude-flow swarm "Implement e-commerce platform components" \
  --strategy development \
  --mode hierarchical \
  --max-agents 8 \
  --monitor

# Phase 4: Testing and Integration
claude-flow sparc tdd "Comprehensive test suite for all components"
claude-flow sparc run integration "Integrate all services and components"

# Phase 5: Deployment
claude-flow sparc run workflow-manager "Deploy to production with monitoring"
```

### 2. Microservices Development

```bash
# Develop services in parallel
claude-flow swarm "Build microservices architecture" \
  --strategy development \
  --mode distributed \
  --parallel \
  --max-agents 10

# Services include:
# - User Service
# - Auth Service
# - Product Service
# - Order Service
# - Notification Service
# - API Gateway

# Integration and testing
claude-flow sparc run integration "Service mesh configuration and testing"
claude-flow sparc run tester "End-to-end microservices testing"
```

### 3. Feature Sprint Workflow

```bash
# Sprint planning
claude-flow sparc run orchestrator "Sprint planning for user dashboard features"

# Parallel feature development
claude-flow swarm "Implement sprint features" \
  --strategy development \
  --mode hierarchical \
  --parallel \
  --monitor

# Quality assurance
claude-flow sparc run reviewer "Code review all features"
claude-flow sparc run security-review "Security audit sprint deliverables"
```

## Best Practices

### 1. Use --non-interactive for Automation
```bash
# Good: Enables smooth batch execution
claude-flow sparc run coder "implement feature" --non-interactive

# Bad: May prompt for input during automation
claude-flow sparc run coder "implement feature"
```

### 2. Enable Monitoring for Long Tasks
```bash
# Monitor progress and catch issues early
claude-flow swarm "Complex task" --monitor --timeout 300
```

### 3. Store Intermediate Results
```javascript
// Store results for cross-agent coordination
Memory.store("phase1_results", analysisData);
Memory.store("api_contracts", apiDefinitions);
```

### 4. Choose Appropriate Coordination Modes

| Mode | Best For | Example |
|------|----------|---------|
| centralized | Simple tasks, clear hierarchy | Basic CRUD app |
| distributed | Independent, parallel work | Microservices |
| hierarchical | Organized, structured projects | Enterprise apps |
| mesh | Dynamic, adaptive tasks | ML pipelines |
| hybrid | Complex workflows | Full-stack apps |

### 5. Batch Related Operations
```javascript
// Good: Single TodoWrite call
TodoWrite([task1, task2, task3, task4]);

// Bad: Multiple individual calls
TodoWrite([task1]);
TodoWrite([task2]);
TodoWrite([task3]);
TodoWrite([task4]);
```

### 6. Set Resource Limits
```bash
# Prevent resource exhaustion
claude-flow swarm "Heavy processing" \
  --max-agents 5 \
  --timeout 600 \
  --memory-limit 2GB
```

## Common Pitfalls

### 1. Synchronous Blocking Operations
**Problem**: Sequential execution kills performance
```javascript
// Bad: Sequential API calls
const result1 = await callAPI1();
const result2 = await callAPI2();
const result3 = await callAPI3();
```

**Solution**: Use parallel execution
```javascript
// Good: Parallel execution
const [result1, result2, result3] = await Promise.all([
  callAPI1(),
  callAPI2(),
  callAPI3()
]);
```

### 2. Unbounded Memory Growth
**Problem**: No cleanup leads to crashes
```javascript
// Bad: Accumulating data without limits
eventHistory.push(newEvent); // Grows forever
```

**Solution**: Implement cleanup strategies
```javascript
// Good: Bounded history
if (eventHistory.length > MAX_HISTORY) {
  eventHistory.shift(); // Remove oldest
}
eventHistory.push(newEvent);
```

### 3. Poor Agent Selection
**Problem**: O(n²) complexity in agent matching
```javascript
// Bad: Nested loops for agent selection
for (const task of tasks) {
  for (const agent of agents) {
    if (agent.capabilities.includes(task.type)) {
      // Assign
    }
  }
}
```

**Solution**: Use indexed lookups
```javascript
// Good: Indexed agent capabilities
const agentIndex = buildCapabilityIndex(agents);
const agent = agentIndex[task.type][0];
```

### 4. No Error Handling
**Problem**: Single failure crashes entire workflow

**Solution**: Implement retry logic and checkpoints
```bash
claude-flow swarm "Critical task" \
  --retry 3 \
  --checkpoint-interval 60 \
  --on-error continue
```

### 5. Not Using Batch Tools
**Problem**: Sequential execution takes 10x longer

**Solution**: Always use batch operations
```javascript
// Use TodoWrite for coordination
TodoWrite(tasks);

// Use Task for parallel agents
tasks.forEach(t => Task(t.agent, t.description));

// Use Memory for state sharing
Memory.store("shared_state", state);
```

## Real-World Examples

### 1. E-commerce Platform Development

Complete implementation using swarm orchestration:

```bash
# Initial research and planning
claude-flow swarm "Research e-commerce best practices and requirements" \
  --strategy research \
  --mode distributed \
  --output ./research \
  --max-agents 4

# Architecture design
claude-flow sparc run architect "Design scalable e-commerce architecture with microservices"
claude-flow memory store "architecture" "Microservices with API gateway, service mesh"

# Parallel service development
claude-flow swarm "Develop e-commerce microservices" \
  --strategy development \
  --mode hierarchical \
  --parallel \
  --max-agents 8 \
  --monitor

# Testing and integration
claude-flow sparc tdd "Comprehensive test suite with integration tests"
claude-flow sparc run integration "Configure service mesh and API gateway"

# Deployment and monitoring
claude-flow sparc run workflow-manager "Deploy to Kubernetes with monitoring"
```

### 2. Real-time Chat Application

```bash
# Design phase
claude-flow sparc run architect "Design real-time chat architecture with WebSockets"

# Implementation
claude-flow swarm "Build real-time chat application" \
  --strategy development \
  --mode distributed \
  --parallel

# Components developed in parallel:
# - WebSocket server
# - Message queue (Redis)
# - User authentication
# - Frontend React app
# - Mobile React Native app

# Testing
claude-flow sparc run tester "Load testing for 10,000 concurrent users"
```

### 3. Data Pipeline Automation

```bash
# Workflow design
claude-flow sparc run workflow-manager "Design ETL pipeline for analytics"

# Implementation
claude-flow swarm "Build data pipeline components" \
  --strategy development \
  --mode mesh \
  --parallel

# Components:
# - Data ingestion service
# - Transformation pipelines
# - Data validation
# - Analytics processing
# - Visualization dashboards

# Optimization
claude-flow sparc run optimizer "Optimize pipeline for throughput"
```

## Advanced Integration Patterns

### 1. CI/CD Integration

```yaml
# GitHub Actions example
name: Claude-Flow Development Pipeline
on: [push]

jobs:
  develop:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install Claude-Flow
        run: npm install -g claude-flow
      
      - name: Run development swarm
        run: |
          claude-flow swarm "Implement features from PR description" \
            --strategy development \
            --mode hierarchical \
            --non-interactive \
            --output ./artifacts
      
      - name: Run tests
        run: |
          claude-flow sparc tdd "Test all new features" \
            --non-interactive
```

### 2. Enterprise Integration

```bash
# Project management
claude-flow project create "enterprise-app"
claude-flow project switch "enterprise-app"

# Security compliance
claude-flow security scan
claude-flow security audit --compliance "SOC2,HIPAA"

# Analytics and monitoring
claude-flow analytics dashboard
claude-flow monitor --metrics --alerts
```

## Performance Optimization Tips

### 1. Connection Pooling
```javascript
// Reuse API connections
const apiPool = new ConnectionPool({
  max: 10,
  idleTimeout: 30000
});
```

### 2. Result Caching
```javascript
// Cache expensive operations
const cache = new Map();
if (cache.has(key)) {
  return cache.get(key);
}
```

### 3. Work Stealing
```javascript
// Balance load across agents
const workQueue = new WorkStealingQueue();
agents.forEach(agent => agent.attachQueue(workQueue));
```

### 4. Predictive Scheduling
```javascript
// Schedule based on historical performance
const estimatedTime = predictTaskDuration(task);
scheduleTask(task, estimatedTime);
```

## Troubleshooting Guide

### Tasks Not Running in Parallel
- Ensure `--parallel` flag is used
- Check `--max-agents` limit
- Verify no dependency conflicts

### Memory Namespace Conflicts
- Use unique namespaces per project
- Clean up old namespaces regularly
- Check memory stats with `claude-flow memory stats`

### Resource Exhaustion
- Set `--max-concurrent` limits
- Use `--memory-limit` for heavy tasks
- Monitor with `claude-flow monitor`

### Agent Communication Issues
- Verify coordination mode matches task
- Check network connectivity for distributed mode
- Review agent logs for errors

## Summary

Claude-Flow provides powerful patterns for AI-assisted development:

1. **Swarm Orchestration** - Coordinate multiple agents for complex tasks
2. **SPARC Modes** - Specialized agents for specific development phases
3. **Batch Operations** - Maximize efficiency with parallel execution
4. **Memory Integration** - Share context across agents and sessions
5. **Workflow Automation** - Build complex development pipelines

By following these patterns and best practices, you can achieve:
- 2.5x faster development cycles
- Higher code quality through specialized agents
- Better resource utilization
- Scalable, maintainable workflows

Remember: The key to success with Claude-Flow is choosing the right pattern for your task and leveraging parallel execution wherever possible.