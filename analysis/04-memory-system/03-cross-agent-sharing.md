# Cross-Agent Memory Sharing in Claude-Flow

## Overview

Cross-agent memory sharing is a core feature of Claude-Flow that enables multiple AI agents to collaborate effectively by sharing knowledge, state, and results. This system ensures data consistency, access control, and efficient information flow between agents.

## Sharing Mechanisms

### 1. Direct Memory Sharing

Direct sharing allows one agent to share specific memory entries with another agent:

```typescript
// Agent A shares analysis results with Agent B
await memoryManager.shareMemory(
  'analysis:result:123',
  { id: 'agent-b', swarmId: 'swarm-1', type: 'analyzer', instance: 2 },
  {
    partition: 'analysis',
    sharer: { id: 'agent-a', swarmId: 'swarm-1', type: 'scanner', instance: 1 },
    accessLevel: 'team',
    expiresAt: new Date(Date.now() + 3600000) // 1 hour
  }
);
```

#### Features:
- **Selective Sharing**: Share specific entries, not entire namespaces
- **Access Control**: Define read/write permissions for shared data
- **Expiration**: Set time limits on shared access
- **Audit Trail**: Track who shared what with whom

### 2. Broadcast Memory

Broadcasting enables sharing memory with multiple agents simultaneously:

```typescript
// Coordinator broadcasts task assignments to all workers
const targetAgents = [
  { id: 'worker-1', swarmId: 'swarm-1', type: 'worker', instance: 1 },
  { id: 'worker-2', swarmId: 'swarm-1', type: 'worker', instance: 2 },
  { id: 'worker-3', swarmId: 'swarm-1', type: 'worker', instance: 3 }
];

await memoryManager.broadcastMemory(
  'task:assignment:batch-1',
  targetAgents,
  {
    broadcaster: { id: 'coordinator', swarmId: 'swarm-1', type: 'coordinator', instance: 0 },
    accessLevel: 'team'
  }
);
```

### 3. Knowledge Base Sharing

Swarm-wide knowledge bases that all agents can access:

```typescript
// Create shared knowledge base
const kbId = await swarmMemory.createKnowledgeBase(
  'Antitrust Patterns',
  'Common patterns and indicators for antitrust detection',
  'legal-compliance',
  ['antitrust', 'price-fixing', 'market-manipulation']
);

// Agents contribute to knowledge base
await swarmMemory.remember(
  'agent-researcher-1',
  'knowledge',
  {
    pattern: 'price-coordination',
    indicators: ['synchronized pricing', 'communication patterns'],
    confidence: 0.85
  },
  {
    taskId: 'research-001',
    tags: ['price-fixing', 'pattern'],
    shareLevel: 'public'
  }
);
```

## Access Control Models

### 1. Access Levels

```typescript
type AccessLevel = 
  | 'private'   // Only owner can access
  | 'team'      // Agents in same team/swarm
  | 'swarm'     // All agents in swarm
  | 'public'    // Any agent
  | 'system';   // System-level access only
```

### 2. Permission Matrix

| Operation | Private | Team | Swarm | Public | System |
|-----------|---------|------|-------|--------|--------|
| Read      | Owner   | Team | All   | All    | System |
| Write     | Owner   | Owner| Owner | Owner  | System |
| Delete    | Owner   | Owner| Owner | Owner  | System |
| Share     | Owner   | Team | All   | All    | System |

### 3. Dynamic Permissions

```typescript
interface MemoryPermissions {
  read: AccessLevel;
  write: AccessLevel;
  delete: AccessLevel;
  share: AccessLevel;
}

// Example: Read-heavy, write-restricted sharing
const analysisMemory: SwarmMemory = {
  namespace: 'analysis',
  partitions: [],
  permissions: {
    read: 'swarm',    // All agents can read
    write: 'team',    // Only team can write
    delete: 'private', // Only owner can delete
    share: 'team'     // Team members can share
  },
  // ... other fields
};
```

## Sharing Patterns

### 1. Producer-Consumer Pattern

One agent produces data, multiple agents consume:

```typescript
// Producer: Data Scanner Agent
await memory.store('scan:raw-data:batch-1', scanResults, {
  namespace: 'scanning',
  type: 'results',
  tags: ['raw-data', 'batch-1'],
  owner: scannerAgent,
  accessLevel: 'team'
});

// Consumers: Analysis Agents
const rawData = await memory.retrieve('scan:raw-data:batch-1', {
  requester: analyzerAgent
});
```

### 2. Collaborative Processing

Multiple agents work on shared data:

```typescript
// Agent 1: Initial processing
let data = await memory.retrieve('task:data:123');
data.stage1 = processStage1(data);
await memory.update('task:data:123', data, {
  updater: agent1,
  incrementVersion: true
});

// Agent 2: Second stage
data = await memory.retrieve('task:data:123');
data.stage2 = processStage2(data);
await memory.update('task:data:123', data, {
  updater: agent2,
  incrementVersion: true
});
```

### 3. Hierarchical Sharing

Coordinator shares with teams, teams share within members:

```typescript
// Coordinator creates master plan
await memory.store('plan:master', masterPlan, {
  namespace: 'coordination',
  owner: coordinator,
  accessLevel: 'team'
});

// Team leaders create sub-plans
await memory.store('plan:team-a', teamAPlan, {
  namespace: 'coordination',
  owner: teamALeader,
  accessLevel: 'team',
  metadata: { parentPlan: 'plan:master' }
});

// Team members access their team's plan
const myTeamPlan = await memory.retrieve('plan:team-a', {
  requester: teamAMember
});
```

## Synchronization Strategies

### 1. Event-Driven Synchronization

```typescript
// Agent subscribes to memory events
memoryManager.on('memory:shared', (event) => {
  if (event.target === myAgentId) {
    // New memory shared with this agent
    handleSharedMemory(event.sharedId);
  }
});

memoryManager.on('memory:updated', (event) => {
  if (subscribedKeys.includes(event.key)) {
    // Subscribed memory was updated
    handleMemoryUpdate(event.key);
  }
});
```

### 2. Polling-Based Synchronization

```typescript
// Agent polls for updates
setInterval(async () => {
  const updates = await memory.query({
    owner: { id: 'team', swarmId: 'swarm-1', type: 'coordinator', instance: 0 },
    updatedAfter: lastCheckTime,
    accessLevel: 'team'
  });
  
  for (const update of updates) {
    processUpdate(update);
  }
  
  lastCheckTime = new Date();
}, 5000); // Check every 5 seconds
```

### 3. Push-Pull Hybrid

```typescript
// Distributed memory synchronization
await memoryManager.synchronizeWith('node-2', {
  direction: 'bidirectional',
  filter: {
    namespace: 'shared',
    type: 'knowledge',
    updatedAfter: lastSyncTime
  }
});
```

## Conflict Resolution

### 1. Version-Based Resolution

```typescript
// Optimistic concurrency control
try {
  const entry = await memory.retrieve('shared:data', { includeMetadata: true });
  const updatedData = processData(entry.value);
  
  await memory.update('shared:data', updatedData, {
    version: entry.version, // Specify expected version
    updater: myAgent
  });
} catch (error) {
  if (error.message.includes('Version conflict')) {
    // Handle conflict - retry with latest version
    handleVersionConflict();
  }
}
```

### 2. Last-Write-Wins

Default strategy for simple updates:

```typescript
// Simple update - last write wins
await memory.update('status:current', newStatus, {
  updater: myAgent,
  incrementVersion: false // Don't check version
});
```

### 3. Merge Strategies

For complex data structures:

```typescript
// Merge concurrent updates
await memory.update('collaborative:doc', updates, {
  updater: myAgent,
  merge: true, // Merge with existing data
  metadata: {
    mergeStrategy: 'deep',
    conflictResolution: 'union'
  }
});
```

## Performance Optimization

### 1. Batch Sharing

Share multiple entries efficiently:

```typescript
// Batch share analysis results
const results = ['result:1', 'result:2', 'result:3'];
const sharedIds = await Promise.all(
  results.map(key => 
    memoryManager.shareMemory(key, targetAgent, { 
      accessLevel: 'team' 
    })
  )
);
```

### 2. Selective Replication

Only replicate necessary data:

```typescript
// Configure selective replication
const replicationConfig = {
  enableDistribution: true,
  replicationFactor: 3,
  replicationFilter: {
    type: ['knowledge', 'configuration'],
    accessLevel: ['team', 'swarm', 'public']
  }
};
```

### 3. Caching Strategies

Optimize repeated access:

```typescript
// Enable caching for frequently accessed shared data
const config: MemoryConfig = {
  enableCaching: true,
  cacheSize: 10000,
  cacheTtl: 300000, // 5 minutes
  cacheStrategy: 'lru',
  cacheWarmup: ['shared:config', 'shared:patterns']
};
```

## Security Considerations

### 1. Encryption

```typescript
// Enable encryption for sensitive shared data
await memory.store('sensitive:data', data, {
  namespace: 'secure',
  accessLevel: 'team',
  metadata: {
    encrypted: true,
    encryptionKey: 'team-key-id'
  }
});
```

### 2. Audit Logging

```typescript
// Track all sharing operations
memoryManager.on('memory:shared', (event) => {
  auditLog.record({
    action: 'memory-shared',
    sharer: event.sharer,
    target: event.target,
    key: event.key,
    timestamp: new Date(),
    accessLevel: event.accessLevel
  });
});
```

### 3. Access Revocation

```typescript
// Revoke shared access
await memory.update('shared:data', data, {
  metadata: {
    revokedAccess: ['agent-x', 'agent-y']
  }
});

// Or set expiration
await memory.update('shared:data', data, {
  metadata: {
    expiresAt: new Date(Date.now() + 3600000) // 1 hour
  }
});
```

## Best Practices

### 1. Namespace Organization
- Use clear namespace hierarchies: `project:module:type`
- Separate shared and private namespaces
- Use consistent naming conventions

### 2. Access Control
- Start with restrictive permissions, expand as needed
- Use team-level sharing for collaborative data
- Reserve public access for truly global knowledge

### 3. Performance
- Cache frequently accessed shared data
- Use batch operations for multiple shares
- Implement pagination for large result sets

### 4. Reliability
- Handle sharing failures gracefully
- Implement retry logic for critical shares
- Monitor sharing performance and failures

### 5. Security
- Encrypt sensitive shared data
- Audit all sharing operations
- Regularly review and revoke unnecessary access

## Example: Multi-Agent Collaboration

```typescript
// Coordinator initializes shared workspace
await memory.store('workspace:project-x', {
  id: 'project-x',
  status: 'active',
  teams: ['scanning', 'analysis', 'reporting'],
  sharedData: {}
}, {
  namespace: 'coordination',
  owner: coordinator,
  accessLevel: 'swarm'
});

// Scanner agent stores findings
await memory.store('findings:batch-1', scanResults, {
  namespace: 'scanning',
  owner: scanner,
  accessLevel: 'team',
  tags: ['batch-1', 'raw-findings']
});

// Share with analysis team
await memory.broadcastMemory(
  'findings:batch-1',
  analysisTeam,
  {
    broadcaster: scanner,
    accessLevel: 'team'
  }
);

// Analysis agents process shared data
const findings = await memory.retrieve('findings:batch-1', {
  requester: analyzer1
});
const analysis = performAnalysis(findings);

// Store and share analysis results
await memory.store('analysis:batch-1', analysis, {
  namespace: 'analysis',
  owner: analyzer1,
  accessLevel: 'team'
});

// Coordinator aggregates results
const allAnalyses = await memory.query({
  namespace: 'analysis',
  tags: ['batch-1'],
  type: 'results'
});

const report = generateReport(allAnalyses);
await memory.store('report:batch-1', report, {
  namespace: 'reporting',
  owner: coordinator,
  accessLevel: 'public'
});
```

This comprehensive sharing system enables sophisticated multi-agent collaboration while maintaining security, performance, and data integrity.