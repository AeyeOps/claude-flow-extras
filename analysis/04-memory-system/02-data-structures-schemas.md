# Claude-Flow Memory Data Structures and Schemas

## Core Data Structures

### 1. Memory Entry Schema

The fundamental unit of storage in the memory system:

```typescript
interface MemoryEntry {
  // Identification
  id: string;              // Unique identifier (e.g., "entry_abc123")
  key: string;             // User-defined key for retrieval
  
  // Content
  value: any;              // The actual stored data
  type: string;            // Data type classification
  
  // Organization
  namespace: string;       // Logical grouping (e.g., "default", "project-x")
  tags: string[];          // Searchable tags
  
  // Metadata
  metadata: Record<string, any>;  // Custom metadata
  owner: string;                  // Owner identifier
  accessLevel: 'private' | 'shared' | 'public';
  
  // Timestamps
  createdAt: Date;         // Creation timestamp
  updatedAt: Date;         // Last update timestamp
  lastAccessedAt: Date;    // Last access timestamp
  expiresAt?: Date;        // Optional expiration
  
  // Versioning
  version: number;         // Version number
  previousVersions?: MemoryEntry[]; // Version history
  
  // Storage
  size: number;            // Size in bytes
  compressed: boolean;     // Compression status
  checksum: string;        // SHA-256 checksum
  
  // Relationships
  references: string[];    // References to other entries
  dependencies: string[];  // Dependencies on other entries
}
```

### 2. Memory Partition Schema

Logical separation of memory spaces:

```typescript
interface MemoryPartition {
  id: string;              // Partition identifier
  name: string;            // Human-readable name
  type: MemoryType;        // Type of data stored
  entries: MemoryEntry[];  // Entries in this partition
  maxSize: number;         // Maximum size in bytes
  ttl?: number;            // Default TTL for entries
  readOnly: boolean;       // Write protection
  shared: boolean;         // Sharing enabled
  indexed: boolean;        // Search indexing enabled
  compressed: boolean;     // Compression enabled
}
```

### 3. Swarm Memory Types

```typescript
type MemoryType = 
  | 'knowledge'      // Persistent knowledge
  | 'state'          // Agent state
  | 'cache'          // Temporary cache
  | 'logs'           // Log entries
  | 'results'        // Task results
  | 'communication'  // Inter-agent messages
  | 'configuration'  // Config data
  | 'metrics';       // Performance metrics
```

### 4. Query Schema

Advanced querying capabilities:

```typescript
interface QueryOptions {
  // Filtering
  namespace?: string;
  type?: string;
  tags?: string[];
  owner?: string;
  accessLevel?: AccessLevel;
  
  // Pattern matching
  keyPattern?: string;      // Regex pattern
  valueSearch?: string;     // Value content search
  fullTextSearch?: string;  // Full-text search
  
  // Temporal filtering
  createdAfter?: Date;
  createdBefore?: Date;
  updatedAfter?: Date;
  updatedBefore?: Date;
  lastAccessedAfter?: Date;
  lastAccessedBefore?: Date;
  
  // Size filtering
  sizeGreaterThan?: number;
  sizeLessThan?: number;
  
  // Options
  includeExpired?: boolean;
  includeMetadata?: boolean;
  
  // Pagination
  limit?: number;
  offset?: number;
  
  // Sorting
  sortBy?: 'key' | 'createdAt' | 'updatedAt' | 'lastAccessedAt' | 'size' | 'type';
  sortOrder?: 'asc' | 'desc';
  
  // Aggregation
  aggregateBy?: 'namespace' | 'type' | 'owner' | 'tags';
}
```

## Swarm-Specific Structures

### 1. Agent Memory Entry

```typescript
interface SwarmMemoryEntry {
  id: string;
  agentId: string;
  type: 'knowledge' | 'result' | 'state' | 'communication' | 'error';
  content: any;
  timestamp: Date;
  metadata: {
    taskId?: string;
    objectiveId?: string;
    tags?: string[];
    priority?: number;
    shareLevel?: 'private' | 'team' | 'public';
  };
}
```

### 2. Knowledge Base Schema

```typescript
interface SwarmKnowledgeBase {
  id: string;
  name: string;
  description: string;
  entries: SwarmMemoryEntry[];
  metadata: {
    domain: string;
    expertise: string[];
    contributors: string[];
    lastUpdated: Date;
  };
}
```

### 3. Agent Identity

```typescript
interface AgentId {
  id: string;           // Unique agent identifier
  swarmId: string;      // Swarm membership
  type: AgentType;      // Agent type
  instance: number;     // Instance number
}

type AgentType = 
  | 'coordinator'
  | 'worker'
  | 'specialist'
  | 'monitor'
  | 'researcher'
  | 'coder'
  | 'tester'
  | 'analyzer';
```

## Import/Export Schemas

### 1. Export Format

```typescript
interface MemoryExport {
  exported: string;         // ISO timestamp
  namespace: string;        // Source namespace
  entryCount: number;       // Number of entries
  entries: ExportedEntry[]; // Exported entries
}

interface ExportedEntry {
  id: string;
  key: string;
  value: string;  // Serialized value
  type: string;
  namespace: string;
  tags: string[];
  // ... other fields
}
```

### 2. Import Options

```typescript
interface ImportOptions {
  format: 'json' | 'csv' | 'xml' | 'yaml';
  namespace?: string;
  conflictResolution: 'overwrite' | 'skip' | 'merge' | 'rename';
  validation?: boolean;
  transformation?: {
    keyMapping?: Record<string, string>;
    valueTransformation?: (value: any) => any;
    metadataExtraction?: (entry: any) => Record<string, any>;
  };
  dryRun?: boolean;
}
```

## Statistics Schema

### 1. Memory Statistics

```typescript
interface MemoryStatistics {
  overview: {
    totalEntries: number;
    totalSize: number;
    compressedEntries: number;
    compressionRatio: number;
    indexSize: number;
    memoryUsage: number;
    diskUsage: number;
  };
  distribution: {
    byNamespace: Record<string, { count: number; size: number }>;
    byType: Record<string, { count: number; size: number }>;
    byOwner: Record<string, { count: number; size: number }>;
    byAccessLevel: Record<string, { count: number; size: number }>;
  };
  temporal: {
    entriesCreatedLast24h: number;
    entriesUpdatedLast24h: number;
    entriesAccessedLast24h: number;
    oldestEntry?: Date;
    newestEntry?: Date;
  };
  performance: {
    averageQueryTime: number;
    averageWriteTime: number;
    cacheHitRatio: number;
    indexEfficiency: number;
  };
  health: {
    expiredEntries: number;
    orphanedReferences: number;
    duplicateKeys: number;
    corruptedEntries: number;
    recommendedCleanup: boolean;
  };
  optimization: {
    suggestions: string[];
    potentialSavings: {
      compression: number;
      cleanup: number;
      deduplication: number;
    };
    indexOptimization: string[];
  };
}
```

## Cleanup and Retention Schemas

### 1. Cleanup Options

```typescript
interface CleanupOptions {
  dryRun?: boolean;
  removeExpired?: boolean;
  removeOlderThan?: number;  // days
  removeUnaccessed?: number; // days since last access
  removeOrphaned?: boolean;
  removeDuplicates?: boolean;
  compressEligible?: boolean;
  archiveOld?: {
    enabled: boolean;
    olderThan: number; // days
    archivePath: string;
  };
  retentionPolicies?: RetentionPolicy[];
}
```

### 2. Retention Policy

```typescript
interface RetentionPolicy {
  id: string;
  name: string;
  namespace?: string;
  type?: string;
  tags?: string[];
  maxAge?: number;    // days
  maxCount?: number;  // maximum entries
  sizeLimit?: number; // bytes
  priority: number;
  enabled: boolean;
}
```

## Distributed Memory Schemas

### 1. Memory Node

```typescript
interface MemoryNode {
  id: string;
  address: string;
  port: number;
  status: 'online' | 'offline' | 'syncing' | 'failed';
  lastSeen: Date;
  partitions: string[];
  load: number;     // Current load percentage
  capacity: number; // Maximum capacity
}
```

### 2. Sync Operation

```typescript
interface SyncOperation {
  id: string;
  type: 'create' | 'update' | 'delete' | 'batch';
  partition: string;
  entry?: MemoryEntry;
  entries?: MemoryEntry[];
  timestamp: Date;
  version: number;
  origin: string;    // Origin node
  targets: string[]; // Target nodes
  status: 'pending' | 'in_progress' | 'completed' | 'failed';
}
```

### 3. Memory Backup

```typescript
interface MemoryBackup {
  timestamp: Date;
  version: string;
  checksum: string;
  metadata: Record<string, any>;
  entries: MemoryEntry[];
  partitions: MemoryPartition[];
}
```

## Usage Examples

### Storing Complex Data

```typescript
// Store project configuration
await memory.store('project:config', {
  name: 'TrustGuard',
  version: '1.0.0',
  features: ['antitrust-detection', 'risk-analysis'],
  settings: {
    scanDepth: 3,
    alertThreshold: 0.8
  }
}, {
  namespace: 'project',
  type: 'configuration',
  tags: ['config', 'settings'],
  metadata: {
    environment: 'production',
    lastModifiedBy: 'admin'
  }
});

// Store analysis results
await memory.store('analysis:result:123', {
  scanId: '123',
  timestamp: new Date(),
  findings: [
    { type: 'price-fixing', confidence: 0.92 },
    { type: 'market-division', confidence: 0.78 }
  ],
  summary: 'High risk detected'
}, {
  namespace: 'analysis',
  type: 'results',
  tags: ['scan', 'high-risk'],
  ttl: 7 * 24 * 60 * 60 * 1000, // 7 days
  owner: 'scanner-agent-01'
});
```

### Complex Queries

```typescript
// Find all high-risk findings from the last 24 hours
const recentHighRisk = await memory.query({
  namespace: 'analysis',
  type: 'results',
  tags: ['high-risk'],
  createdAfter: new Date(Date.now() - 24 * 60 * 60 * 1000),
  sortBy: 'createdAt',
  sortOrder: 'desc',
  limit: 100
});

// Aggregate findings by type
const findingsByType = await memory.query({
  namespace: 'analysis',
  type: 'results',
  aggregateBy: 'tags',
  includeMetadata: true
});
```