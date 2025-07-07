# Claude-Flow Code Examples and Anti-Patterns

## Complete Working Examples

### 1. Full TodoWrite Orchestration Example

```javascript
// Complete task orchestration with all features
async function orchestrateProjectDevelopment() {
  // Define all tasks with dependencies
  const tasks = [
    {
      id: "research_phase",
      content: "Research best practices and gather requirements",
      status: "pending",
      priority: "high",
      mode: "researcher",
      batchOptimized: true,
      estimatedTime: "30min",
      outputs: ["requirements.md", "research_findings.json"]
    },
    {
      id: "architecture_design",
      content: "Design system architecture based on research",
      status: "pending",
      priority: "high",
      mode: "architect",
      dependencies: ["research_phase"],
      estimatedTime: "45min",
      outputs: ["architecture.md", "system_design.json"]
    },
    {
      id: "database_schema",
      content: "Design database schema and relationships",
      status: "pending",
      priority: "high",
      mode: "architect",
      dependencies: ["architecture_design"],
      estimatedTime: "30min",
      outputs: ["schema.sql", "migrations/"]
    },
    {
      id: "api_development",
      content: "Implement REST API endpoints",
      status: "pending",
      priority: "medium",
      mode: "coder",
      dependencies: ["database_schema"],
      parallel: true,
      estimatedTime: "120min",
      outputs: ["src/api/", "tests/api/"]
    },
    {
      id: "frontend_development",
      content: "Build React frontend components",
      status: "pending",
      priority: "medium",
      mode: "coder",
      dependencies: ["architecture_design"],
      parallel: true,
      estimatedTime: "120min",
      outputs: ["src/frontend/", "tests/frontend/"]
    },
    {
      id: "integration_testing",
      content: "Integration tests for API and frontend",
      status: "pending",
      priority: "high",
      mode: "tester",
      dependencies: ["api_development", "frontend_development"],
      estimatedTime: "60min",
      outputs: ["tests/integration/", "test-reports/"]
    },
    {
      id: "performance_optimization",
      content: "Optimize performance bottlenecks",
      status: "pending",
      priority: "medium",
      mode: "optimizer",
      dependencies: ["integration_testing"],
      estimatedTime: "45min",
      outputs: ["performance-report.md"]
    },
    {
      id: "documentation",
      content: "Generate comprehensive documentation",
      status: "pending",
      priority: "low",
      mode: "documenter",
      dependencies: ["integration_testing"],
      parallel: true,
      estimatedTime: "30min",
      outputs: ["docs/", "README.md", "API.md"]
    },
    {
      id: "deployment_preparation",
      content: "Prepare deployment configurations",
      status: "pending",
      priority: "high",
      mode: "workflow-manager",
      dependencies: ["performance_optimization", "documentation"],
      estimatedTime: "30min",
      outputs: ["docker-compose.yml", "k8s/", ".github/workflows/"]
    }
  ];

  // Write all tasks at once
  TodoWrite(tasks);

  // Monitor progress
  const interval = setInterval(async () => {
    const status = await TodoRead();
    const completed = status.filter(t => t.status === 'completed').length;
    const total = status.length;
    
    console.log(`Progress: ${completed}/${total} tasks completed`);
    
    if (completed === total) {
      clearInterval(interval);
      console.log('All tasks completed!');
    }
  }, 5000);
}
```

### 2. Advanced Task Spawning with Memory Integration

```javascript
// Spawn specialized agents with shared memory context
async function spawnSpecializedTeam(projectName) {
  // Store project context in memory
  Memory.store(`${projectName}/context`, {
    type: "e-commerce",
    stack: "MERN",
    requirements: ["auth", "payments", "inventory", "shipping"],
    constraints: ["PCI compliance", "GDPR", "high availability"]
  });

  // Spawn architect to design system
  Task("System Architect", 
    `Design ${projectName} architecture considering requirements in memory`, 
    {
      mode: "architect",
      memoryNamespace: `${projectName}/context`,
      outputs: [`${projectName}/architecture`],
      priority: "critical"
    }
  );

  // Spawn security expert
  Task("Security Expert", 
    `Review architecture for compliance requirements in memory`, 
    {
      mode: "security-review",
      memoryNamespace: `${projectName}/context`,
      dependencies: [`${projectName}/architecture`],
      outputs: [`${projectName}/security-review`]
    }
  );

  // Spawn development teams
  const services = ["auth", "payments", "inventory", "shipping"];
  
  services.forEach(service => {
    Task(`${service.toUpperCase()} Team`, 
      `Implement ${service} service based on architecture in memory`, 
      {
        mode: "coder",
        memoryNamespace: `${projectName}/context`,
        dependencies: [`${projectName}/architecture`, `${projectName}/security-review`],
        outputs: [`${projectName}/services/${service}`],
        parallel: true,
        estimatedTime: "90min"
      }
    );
  });

  // Spawn integration team
  Task("Integration Team", 
    `Integrate all services and create API gateway`, 
    {
      mode: "integration",
      memoryNamespace: `${projectName}/context`,
      dependencies: services.map(s => `${projectName}/services/${s}`),
      outputs: [`${projectName}/integration`],
      priority: "high"
    }
  );

  // Spawn QA team
  Task("QA Team", 
    `Comprehensive testing of integrated system`, 
    {
      mode: "tester",
      memoryNamespace: `${projectName}/context`,
      dependencies: [`${projectName}/integration`],
      outputs: [`${projectName}/test-results`],
      parallel: true,
      subtasks: [
        "Unit tests for all services",
        "Integration tests for API gateway",
        "End-to-end user journey tests",
        "Performance and load testing",
        "Security penetration testing"
      ]
    }
  );
}
```

### 3. Complex Swarm Orchestration Script

```bash
#!/bin/bash

# Full application development using swarm orchestration
PROJECT_NAME="advanced-ecommerce"
OUTPUT_DIR="./output/${PROJECT_NAME}"

# Phase 1: Research and Requirements Gathering
echo "Phase 1: Research and Requirements Analysis"
claude-flow swarm "Research e-commerce best practices, payment gateways, and shipping integrations" \
  --strategy research \
  --mode distributed \
  --max-agents 6 \
  --parallel \
  --output "${OUTPUT_DIR}/research" \
  --monitor &

RESEARCH_PID=$!

# Wait for research to complete
wait $RESEARCH_PID

# Store research findings in memory
claude-flow memory store "${PROJECT_NAME}/research" "$(cat ${OUTPUT_DIR}/research/summary.json)"

# Phase 2: Architecture and Design
echo "Phase 2: System Architecture Design"
claude-flow sparc run architect "Design scalable e-commerce architecture using research from memory" \
  --memory-namespace "${PROJECT_NAME}/research" \
  --output "${OUTPUT_DIR}/architecture"

# Phase 3: Parallel Development
echo "Phase 3: Parallel Service Development"

# Backend services
claude-flow swarm "Develop backend microservices for ${PROJECT_NAME}" \
  --strategy development \
  --mode hierarchical \
  --max-agents 8 \
  --parallel \
  --monitor \
  --output "${OUTPUT_DIR}/backend" &

BACKEND_PID=$!

# Frontend application
claude-flow swarm "Develop React frontend for ${PROJECT_NAME}" \
  --strategy development \
  --mode distributed \
  --max-agents 4 \
  --parallel \
  --monitor \
  --output "${OUTPUT_DIR}/frontend" &

FRONTEND_PID=$!

# Mobile application
claude-flow swarm "Develop React Native mobile app for ${PROJECT_NAME}" \
  --strategy development \
  --mode distributed \
  --max-agents 4 \
  --parallel \
  --monitor \
  --output "${OUTPUT_DIR}/mobile" &

MOBILE_PID=$!

# Wait for all development to complete
wait $BACKEND_PID $FRONTEND_PID $MOBILE_PID

# Phase 4: Integration and Testing
echo "Phase 4: Integration and Testing"
claude-flow sparc run integration "Integrate all components and services" \
  --input-dir "${OUTPUT_DIR}" \
  --output "${OUTPUT_DIR}/integration"

# Comprehensive testing
claude-flow swarm "Comprehensive testing of ${PROJECT_NAME}" \
  --strategy testing \
  --mode mesh \
  --max-agents 6 \
  --parallel \
  --monitor \
  --output "${OUTPUT_DIR}/tests"

# Phase 5: Optimization and Deployment
echo "Phase 5: Optimization and Deployment"
claude-flow sparc run optimizer "Optimize performance across all services" \
  --input-dir "${OUTPUT_DIR}" \
  --metrics "response-time,throughput,resource-usage" \
  --output "${OUTPUT_DIR}/optimization"

# Deployment preparation
claude-flow sparc run workflow-manager "Create deployment pipeline and configurations" \
  --deployment-targets "staging,production" \
  --orchestration "kubernetes" \
  --output "${OUTPUT_DIR}/deployment"

# Generate final report
claude-flow memory export "${PROJECT_NAME}-final-report.json"

echo "Project ${PROJECT_NAME} completed successfully!"
echo "Results available in: ${OUTPUT_DIR}"
```

### 4. Memory-Driven Workflow Coordination

```javascript
// Advanced memory coordination pattern
class MemoryCoordinatedWorkflow {
  constructor(projectId) {
    this.projectId = projectId;
    this.namespace = `projects/${projectId}`;
  }

  async initializeProject(config) {
    // Store project configuration
    await Memory.store(`${this.namespace}/config`, config);
    
    // Store workflow state
    await Memory.store(`${this.namespace}/state`, {
      phase: 'initialization',
      startTime: new Date().toISOString(),
      status: 'active'
    });

    // Initialize task tracking
    await Memory.store(`${this.namespace}/tasks`, {
      total: 0,
      completed: 0,
      failed: 0,
      active: []
    });
  }

  async addPhase(phaseName, tasks) {
    // Get current state
    const state = await Memory.get(`${this.namespace}/state`);
    
    // Store phase information
    await Memory.store(`${this.namespace}/phases/${phaseName}`, {
      tasks: tasks,
      startTime: new Date().toISOString(),
      status: 'pending'
    });

    // Update workflow state
    state.currentPhase = phaseName;
    await Memory.store(`${this.namespace}/state`, state);

    // Execute phase tasks
    return this.executePhase(phaseName, tasks);
  }

  async executePhase(phaseName, tasks) {
    const results = [];
    
    for (const task of tasks) {
      // Store task context
      await Memory.store(`${this.namespace}/tasks/${task.id}/context`, {
        phase: phaseName,
        dependencies: task.dependencies || [],
        config: task.config || {}
      });

      // Spawn agent with memory access
      const result = await Task(
        task.agentName,
        task.description,
        {
          mode: task.mode,
          memoryNamespace: this.namespace,
          taskId: task.id,
          onComplete: async (output) => {
            // Store task output
            await Memory.store(`${this.namespace}/tasks/${task.id}/output`, output);
            
            // Update task tracking
            const tracking = await Memory.get(`${this.namespace}/tasks`);
            tracking.completed++;
            await Memory.store(`${this.namespace}/tasks`, tracking);
          }
        }
      );

      results.push(result);
    }

    return results;
  }

  async getProjectStatus() {
    const state = await Memory.get(`${this.namespace}/state`);
    const tasks = await Memory.get(`${this.namespace}/tasks`);
    const phases = await Memory.list(`${this.namespace}/phases`);
    
    return {
      projectId: this.projectId,
      state: state,
      tasks: tasks,
      phases: phases,
      progress: tasks.total > 0 ? (tasks.completed / tasks.total * 100).toFixed(2) + '%' : '0%'
    };
  }

  async exportProject() {
    // Export all project data
    return await Memory.export(`${this.namespace}/*`);
  }
}

// Usage example
async function runCoordinatedProject() {
  const workflow = new MemoryCoordinatedWorkflow('ecommerce-v2');
  
  // Initialize project
  await workflow.initializeProject({
    name: 'E-commerce Platform v2',
    stack: 'MERN',
    features: ['multi-vendor', 'real-time-chat', 'ai-recommendations']
  });

  // Phase 1: Research
  await workflow.addPhase('research', [
    {
      id: 'market-research',
      agentName: 'Market Researcher',
      description: 'Research market trends and competitor analysis',
      mode: 'researcher'
    },
    {
      id: 'tech-research',
      agentName: 'Tech Researcher',
      description: 'Research technology stack options and best practices',
      mode: 'researcher'
    }
  ]);

  // Phase 2: Design
  await workflow.addPhase('design', [
    {
      id: 'system-architecture',
      agentName: 'System Architect',
      description: 'Design system architecture based on research findings',
      mode: 'architect',
      dependencies: ['market-research', 'tech-research']
    }
  ]);

  // Get status
  const status = await workflow.getProjectStatus();
  console.log('Project Status:', status);
}
```

## Anti-Patterns to Avoid

### 1. Sequential Task Execution

```javascript
// ❌ BAD: Sequential execution
async function badSequentialApproach() {
  // This takes 6x longer than necessary
  await Task("Agent1", "Research task 1");
  await Task("Agent2", "Research task 2");
  await Task("Agent3", "Research task 3");
  await Task("Agent4", "Code task 1");
  await Task("Agent5", "Code task 2");
  await Task("Agent6", "Test task 1");
}

// ✅ GOOD: Parallel execution with dependencies
async function goodParallelApproach() {
  // Research tasks in parallel
  const researchTasks = [
    Task("Agent1", "Research task 1"),
    Task("Agent2", "Research task 2"),
    Task("Agent3", "Research task 3")
  ];
  await Promise.all(researchTasks);

  // Code tasks in parallel after research
  const codeTasks = [
    Task("Agent4", "Code task 1"),
    Task("Agent5", "Code task 2")
  ];
  await Promise.all(codeTasks);

  // Testing after coding
  await Task("Agent6", "Test all components");
}
```

### 2. Memory Leaks in Long-Running Processes

```javascript
// ❌ BAD: Unbounded memory growth
class BadEventCollector {
  constructor() {
    this.events = []; // Grows forever!
  }

  addEvent(event) {
    this.events.push(event);
    // No cleanup, memory leak!
  }
}

// ✅ GOOD: Bounded memory with cleanup
class GoodEventCollector {
  constructor(maxEvents = 1000) {
    this.events = [];
    this.maxEvents = maxEvents;
  }

  addEvent(event) {
    this.events.push(event);
    
    // Cleanup old events
    if (this.events.length > this.maxEvents) {
      // Keep only recent events
      this.events = this.events.slice(-this.maxEvents);
    }
  }

  // Periodic cleanup method
  cleanup(maxAge = 3600000) { // 1 hour
    const cutoff = Date.now() - maxAge;
    this.events = this.events.filter(e => e.timestamp > cutoff);
  }
}
```

### 3. Poor Error Handling in Workflows

```javascript
// ❌ BAD: No error handling
async function badWorkflow() {
  const task1 = await Task("Agent1", "Task 1");
  const task2 = await Task("Agent2", "Task 2"); // If this fails, everything stops
  const task3 = await Task("Agent3", "Task 3");
}

// ✅ GOOD: Robust error handling
async function goodWorkflow() {
  const results = {
    successful: [],
    failed: []
  };

  // Define tasks with error handling
  const tasks = [
    { id: 'task1', agent: 'Agent1', description: 'Task 1' },
    { id: 'task2', agent: 'Agent2', description: 'Task 2' },
    { id: 'task3', agent: 'Agent3', description: 'Task 3' }
  ];

  // Execute with error handling
  for (const task of tasks) {
    try {
      const result = await Task(task.agent, task.description);
      results.successful.push({ ...task, result });
    } catch (error) {
      console.error(`Task ${task.id} failed:`, error);
      results.failed.push({ ...task, error: error.message });
      
      // Decide whether to continue or abort
      if (task.critical) {
        throw new Error(`Critical task ${task.id} failed`);
      }
    }
  }

  // Retry failed non-critical tasks
  for (const failed of results.failed) {
    try {
      console.log(`Retrying ${failed.id}...`);
      const result = await Task(failed.agent, failed.description);
      results.successful.push({ ...failed, result, retried: true });
    } catch (error) {
      console.error(`Retry failed for ${failed.id}`);
    }
  }

  return results;
}
```

### 4. Inefficient Agent Selection

```javascript
// ❌ BAD: O(n²) agent selection
function badAgentSelection(tasks, agents) {
  const assignments = [];
  
  for (const task of tasks) {
    for (const agent of agents) {
      // Inefficient nested loop
      if (agent.skills.some(skill => task.requirements.includes(skill))) {
        assignments.push({ task, agent });
        break;
      }
    }
  }
  
  return assignments;
}

// ✅ GOOD: Indexed agent selection
function goodAgentSelection(tasks, agents) {
  // Build skill index
  const skillIndex = {};
  agents.forEach(agent => {
    agent.skills.forEach(skill => {
      if (!skillIndex[skill]) skillIndex[skill] = [];
      skillIndex[skill].push(agent);
    });
  });

  // Fast lookup
  const assignments = [];
  for (const task of tasks) {
    for (const requirement of task.requirements) {
      const availableAgents = skillIndex[requirement] || [];
      if (availableAgents.length > 0) {
        // Select least busy agent
        const agent = availableAgents.reduce((a, b) => 
          a.currentLoad < b.currentLoad ? a : b
        );
        assignments.push({ task, agent });
        agent.currentLoad++;
        break;
      }
    }
  }

  return assignments;
}
```

### 5. Not Using TodoWrite for Complex Workflows

```javascript
// ❌ BAD: Managing tasks individually
async function badTaskManagement() {
  // Manually tracking state
  const task1 = { id: '1', status: 'pending' };
  const task2 = { id: '2', status: 'pending' };
  const task3 = { id: '3', status: 'pending' };
  
  // Manual updates
  task1.status = 'in_progress';
  await doWork(task1);
  task1.status = 'completed';
  
  task2.status = 'in_progress';
  await doWork(task2);
  task2.status = 'completed';
  
  // No coordination or visibility
}

// ✅ GOOD: Using TodoWrite for coordination
async function goodTaskManagement() {
  // Define all tasks with metadata
  const tasks = [
    {
      id: 'data-processing',
      content: 'Process user data for analytics',
      status: 'pending',
      priority: 'high',
      dependencies: [],
      estimatedTime: '30min',
      tags: ['analytics', 'backend']
    },
    {
      id: 'report-generation',
      content: 'Generate analytics reports',
      status: 'pending',
      priority: 'medium',
      dependencies: ['data-processing'],
      estimatedTime: '15min',
      tags: ['analytics', 'reporting']
    },
    {
      id: 'dashboard-update',
      content: 'Update analytics dashboard',
      status: 'pending',
      priority: 'medium',
      dependencies: ['report-generation'],
      estimatedTime: '20min',
      tags: ['frontend', 'analytics']
    }
  ];

  // Single coordinated write
  await TodoWrite(tasks);

  // Monitor and update
  const monitor = setInterval(async () => {
    const todos = await TodoRead();
    const pending = todos.filter(t => t.status === 'pending');
    
    if (pending.length === 0) {
      clearInterval(monitor);
      console.log('All tasks completed!');
    }
  }, 5000);
}
```

## Performance Optimization Examples

### 1. Connection Pooling for Claude API

```javascript
// Optimized API client with connection pooling
class OptimizedClaudeClient {
  constructor(config) {
    this.pool = {
      connections: [],
      maxConnections: config.maxConnections || 10,
      idleTimeout: config.idleTimeout || 30000
    };
    
    // Pre-warm connections
    this.warmPool();
  }

  async warmPool() {
    const promises = [];
    for (let i = 0; i < this.pool.maxConnections / 2; i++) {
      promises.push(this.createConnection());
    }
    await Promise.all(promises);
  }

  async getConnection() {
    // Reuse idle connection
    const idle = this.pool.connections.find(c => !c.busy);
    if (idle) {
      idle.busy = true;
      idle.lastUsed = Date.now();
      return idle;
    }

    // Create new if under limit
    if (this.pool.connections.length < this.pool.maxConnections) {
      return await this.createConnection();
    }

    // Wait for available connection
    return new Promise(resolve => {
      const check = setInterval(() => {
        const available = this.pool.connections.find(c => !c.busy);
        if (available) {
          clearInterval(check);
          available.busy = true;
          available.lastUsed = Date.now();
          resolve(available);
        }
      }, 100);
    });
  }

  async releaseConnection(connection) {
    connection.busy = false;
    
    // Clean up idle connections
    this.cleanupIdleConnections();
  }

  cleanupIdleConnections() {
    const now = Date.now();
    this.pool.connections = this.pool.connections.filter(c => {
      if (!c.busy && (now - c.lastUsed) > this.pool.idleTimeout) {
        c.close();
        return false;
      }
      return true;
    });
  }
}
```

### 2. Intelligent Task Batching

```javascript
// Smart task batcher for optimal performance
class TaskBatcher {
  constructor(options = {}) {
    this.batchSize = options.batchSize || 10;
    this.batchTimeout = options.batchTimeout || 1000;
    this.queue = [];
    this.processing = false;
  }

  async addTask(task) {
    this.queue.push(task);
    
    // Process immediately if batch is full
    if (this.queue.length >= this.batchSize) {
      return this.processBatch();
    }

    // Otherwise, wait for timeout
    if (!this.batchTimer) {
      this.batchTimer = setTimeout(() => {
        this.processBatch();
      }, this.batchTimeout);
    }
  }

  async processBatch() {
    if (this.processing || this.queue.length === 0) return;
    
    this.processing = true;
    clearTimeout(this.batchTimer);
    this.batchTimer = null;

    // Take batch from queue
    const batch = this.queue.splice(0, this.batchSize);
    
    // Group by task type for efficiency
    const grouped = this.groupTasksByType(batch);
    
    // Process each group in parallel
    const results = await Promise.all(
      Object.entries(grouped).map(([type, tasks]) => 
        this.processTaskGroup(type, tasks)
      )
    );

    this.processing = false;
    
    // Process remaining tasks
    if (this.queue.length > 0) {
      setImmediate(() => this.processBatch());
    }

    return results.flat();
  }

  groupTasksByType(tasks) {
    return tasks.reduce((groups, task) => {
      const type = task.mode || 'default';
      if (!groups[type]) groups[type] = [];
      groups[type].push(task);
      return groups;
    }, {});
  }

  async processTaskGroup(type, tasks) {
    // Process similar tasks together for efficiency
    console.log(`Processing ${tasks.length} ${type} tasks`);
    
    // Use TodoWrite for batch coordination
    if (tasks.length > 1) {
      return TodoWrite(tasks);
    }
    
    // Single task
    return Task(tasks[0].agent, tasks[0].description, tasks[0].options);
  }
}
```

### 3. Caching Strategy for Expensive Operations

```javascript
// Multi-level caching system
class SmartCache {
  constructor() {
    this.l1Cache = new Map(); // Memory cache
    this.l2Cache = null; // File cache (optional)
    this.stats = {
      hits: 0,
      misses: 0,
      evictions: 0
    };
  }

  async get(key, computeFn, options = {}) {
    // Check L1 cache
    if (this.l1Cache.has(key)) {
      this.stats.hits++;
      const cached = this.l1Cache.get(key);
      
      // Check if expired
      if (!this.isExpired(cached, options.ttl)) {
        return cached.value;
      }
    }

    // Check L2 cache if available
    if (this.l2Cache) {
      const l2Value = await this.l2Cache.get(key);
      if (l2Value && !this.isExpired(l2Value, options.ttl)) {
        this.stats.hits++;
        // Promote to L1
        this.l1Cache.set(key, l2Value);
        return l2Value.value;
      }
    }

    // Cache miss - compute value
    this.stats.misses++;
    const value = await computeFn();
    
    // Store in cache
    const cached = {
      value,
      timestamp: Date.now(),
      size: this.estimateSize(value)
    };

    // Add to L1 with eviction if needed
    this.addToL1(key, cached);
    
    // Add to L2 if available
    if (this.l2Cache) {
      await this.l2Cache.set(key, cached);
    }

    return value;
  }

  addToL1(key, value) {
    // Simple LRU eviction
    if (this.l1Cache.size >= 100) {
      const oldest = [...this.l1Cache.entries()]
        .sort((a, b) => a[1].timestamp - b[1].timestamp)[0];
      this.l1Cache.delete(oldest[0]);
      this.stats.evictions++;
    }

    this.l1Cache.set(key, value);
  }

  isExpired(cached, ttl) {
    if (!ttl) return false;
    return Date.now() - cached.timestamp > ttl;
  }

  estimateSize(value) {
    // Rough estimate of object size
    return JSON.stringify(value).length;
  }

  getStats() {
    const hitRate = this.stats.hits / (this.stats.hits + this.stats.misses) || 0;
    return {
      ...this.stats,
      hitRate: `${(hitRate * 100).toFixed(2)}%`,
      l1Size: this.l1Cache.size
    };
  }
}

// Usage with expensive operations
const cache = new SmartCache();

async function getExpensiveData(id) {
  return cache.get(
    `expensive-data-${id}`,
    async () => {
      // Expensive operation
      const result = await Task("Research Agent", `Deep research on topic ${id}`);
      return result;
    },
    { ttl: 3600000 } // 1 hour TTL
  );
}
```

## Summary

These examples demonstrate:

1. **Proper use of batch operations** for maximum efficiency
2. **Memory coordination patterns** for complex workflows
3. **Common anti-patterns** to avoid in production
4. **Performance optimizations** that can achieve 2.5x speedup

Remember: The key to effective Claude-Flow usage is understanding when to parallelize, how to coordinate agents, and avoiding the common pitfalls that lead to poor performance.