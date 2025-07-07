# Memory Query and Retrieval Patterns in Claude-Flow

## Overview

The Claude-Flow memory system provides sophisticated querying and retrieval capabilities that enable agents to efficiently find and access stored information. This document covers the various patterns, strategies, and best practices for querying the memory system.

## Query Types

### 1. Basic Key-Value Retrieval

The simplest and fastest retrieval method:

```typescript
// Direct key lookup
const value = await memory.retrieve('user:preferences:123');

// With namespace specification
const config = await memory.retrieve('app:config', {
  partition: 'configuration'
});

// With access control
const sensitiveData = await memory.retrieve('secure:api-keys', {
  requester: { id: 'admin-agent', swarmId: 'swarm-1', type: 'coordinator', instance: 0 }
});
```

### 2. Advanced Query API

Complex queries using the QueryOptions interface:

```typescript
// Find all error logs from the last hour
const recentErrors = await memory.query({
  type: 'logs',
  tags: ['error'],
  createdAfter: new Date(Date.now() - 3600000),
  sortBy: 'createdAt',
  sortOrder: 'desc',
  limit: 100
});

// Find large knowledge entries
const largeEntries = await memory.query({
  type: 'knowledge',
  sizeGreaterThan: 1024 * 1024, // 1MB
  sortBy: 'size',
  sortOrder: 'desc'
});
```

### 3. Full-Text Search

Content-based searching across entries:

```typescript
// Search for specific content
const searchResults = await memory.search({
  query: 'antitrust price fixing',
  searchFields: ['value', 'tags', 'metadata'],
  fuzzyMatch: true,
  maxResults: 50,
  threshold: 0.7,
  includeContent: true
});

// Search with field weighting
const weightedSearch = await memory.search({
  query: 'market manipulation',
  searchFields: ['value:3', 'tags:2', 'key:1'], // Weight by importance
  maxResults: 20
});
```

### 4. Pattern-Based Queries

Using regex patterns for flexible matching:

```typescript
// Find all entries matching a pattern
const patternResults = await memory.query({
  keyPattern: '^user:session:.*:active$',
  type: 'state'
});

// Complex pattern with value search
const complexPattern = await memory.query({
  keyPattern: 'log:.*:error',
  valueSearch: 'connection refused',
  createdAfter: new Date(Date.now() - 86400000) // Last 24 hours
});
```

## Query Optimization Strategies

### 1. Index Utilization

The memory system maintains several indexes for fast retrieval:

```typescript
// Queries that use indexes efficiently
const indexed = await memory.query({
  namespace: 'project-x',    // Namespace index
  type: 'results',           // Type index
  tags: ['completed'],       // Tag index
  owner: agentId            // Owner index
});

// Combining indexes for faster results
const combined = await memory.query({
  namespace: 'analysis',
  type: 'results',
  tags: ['high-priority', 'pending'],
  limit: 10
});
```

### 2. Pagination for Large Result Sets

Handle large datasets efficiently:

```typescript
// Paginated retrieval
async function* paginatedQuery(baseQuery: MemoryQuery) {
  const pageSize = 100;
  let offset = 0;
  let hasMore = true;
  
  while (hasMore) {
    const results = await memory.query({
      ...baseQuery,
      limit: pageSize,
      offset: offset
    });
    
    if (results.length < pageSize) {
      hasMore = false;
    }
    
    yield results;
    offset += pageSize;
  }
}

// Usage
for await (const page of paginatedQuery({ type: 'logs' })) {
  processLogBatch(page);
}
```

### 3. Caching Strategies

Optimize repeated queries:

```typescript
// Cache frequent queries
class QueryCache {
  private cache = new Map<string, { results: any[], timestamp: number }>();
  private ttl = 300000; // 5 minutes
  
  async query(query: MemoryQuery): Promise<any[]> {
    const cacheKey = JSON.stringify(query);
    const cached = this.cache.get(cacheKey);
    
    if (cached && Date.now() - cached.timestamp < this.ttl) {
      return cached.results;
    }
    
    const results = await memory.query(query);
    this.cache.set(cacheKey, { results, timestamp: Date.now() });
    
    return results;
  }
}
```

### 4. Parallel Query Execution

Execute multiple queries concurrently:

```typescript
// Parallel queries for different data types
const [knowledge, state, results] = await Promise.all([
  memory.query({ type: 'knowledge', namespace: 'shared' }),
  memory.query({ type: 'state', owner: myAgent }),
  memory.query({ type: 'results', tags: ['latest'] })
]);

// Batch similar queries
async function batchQuery(keys: string[]): Promise<Map<string, any>> {
  const results = await Promise.all(
    keys.map(key => 
      memory.retrieve(key).catch(() => null)
    )
  );
  
  return new Map(
    keys.map((key, i) => [key, results[i]])
  );
}
```

## Aggregation Patterns

### 1. Built-in Aggregations

Use the aggregation features:

```typescript
// Aggregate by namespace
const namespaceStats = await memory.query({
  aggregateBy: 'namespace',
  includeMetadata: true
});

// Returns: { namespace: { count, totalSize } }

// Multiple aggregations
const detailedStats = await memory.query({
  type: 'results',
  createdAfter: new Date(Date.now() - 7 * 86400000), // Last week
  aggregateBy: 'tags'
});
```

### 2. Custom Aggregations

Implement custom aggregation logic:

```typescript
// Time-based aggregation
async function aggregateByHour(query: MemoryQuery) {
  const entries = await memory.query(query);
  const hourly = new Map<string, any[]>();
  
  for (const entry of entries) {
    const hour = new Date(entry.createdAt);
    hour.setMinutes(0, 0, 0);
    const key = hour.toISOString();
    
    if (!hourly.has(key)) {
      hourly.set(key, []);
    }
    hourly.get(key)!.push(entry);
  }
  
  return hourly;
}

// Aggregate by custom field
async function aggregateByMetadata(field: string) {
  const entries = await memory.query({ includeMetadata: true });
  const groups = new Map<any, MemoryEntry[]>();
  
  for (const entry of entries) {
    const value = entry.metadata?.[field];
    if (value !== undefined) {
      if (!groups.has(value)) {
        groups.set(value, []);
      }
      groups.get(value)!.push(entry);
    }
  }
  
  return groups;
}
```

## Retrieval Patterns

### 1. Lazy Loading

Load data only when needed:

```typescript
class LazyMemoryEntry {
  private loaded = false;
  private data: any = null;
  
  constructor(private key: string, private memory: MemoryManager) {}
  
  async getValue(): Promise<any> {
    if (!this.loaded) {
      this.data = await this.memory.retrieve(this.key);
      this.loaded = true;
    }
    return this.data;
  }
}

// Usage
const entries = keys.map(key => new LazyMemoryEntry(key, memory));
// Data loaded only when accessed
const value = await entries[0].getValue();
```

### 2. Prefetching

Anticipate and preload data:

```typescript
class PrefetchingMemory {
  private prefetchQueue = new Set<string>();
  
  async prefetch(keys: string[]): Promise<void> {
    const missing = keys.filter(key => !this.cache.has(key));
    
    await Promise.all(
      missing.map(async key => {
        const value = await memory.retrieve(key);
        this.cache.set(key, value);
      })
    );
  }
  
  async retrieve(key: string): Promise<any> {
    // Check if prefetched
    if (this.cache.has(key)) {
      return this.cache.get(key);
    }
    
    return await memory.retrieve(key);
  }
}
```

### 3. Batch Retrieval

Optimize multiple retrievals:

```typescript
// Batch retrieve with fallback
async function batchRetrieve(
  keys: string[],
  options?: { partition?: string }
): Promise<Map<string, any>> {
  const results = new Map<string, any>();
  const batches = [];
  
  // Split into batches of 100
  for (let i = 0; i < keys.length; i += 100) {
    batches.push(keys.slice(i, i + 100));
  }
  
  // Process batches in parallel
  await Promise.all(
    batches.map(async batch => {
      const batchResults = await Promise.all(
        batch.map(key => 
          memory.retrieve(key, options)
            .then(value => ({ key, value, success: true }))
            .catch(error => ({ key, value: null, success: false, error }))
        )
      );
      
      for (const result of batchResults) {
        results.set(result.key, result);
      }
    })
  );
  
  return results;
}
```

### 4. Stream-Based Retrieval

For large datasets:

```typescript
// Stream entries matching criteria
async function* streamEntries(query: MemoryQuery) {
  const pageSize = 50;
  let offset = 0;
  
  while (true) {
    const batch = await memory.query({
      ...query,
      limit: pageSize,
      offset
    });
    
    if (batch.length === 0) break;
    
    for (const entry of batch) {
      yield entry;
    }
    
    offset += pageSize;
  }
}

// Usage with processing
async function processLargeDataset() {
  for await (const entry of streamEntries({ type: 'logs' })) {
    await processLogEntry(entry);
    
    // Process in batches
    if (processedCount % 100 === 0) {
      await flushProcessedData();
    }
  }
}
```

## Complex Query Patterns

### 1. Hierarchical Queries

Query related data in hierarchy:

```typescript
// Get parent and all children
async function getHierarchy(parentKey: string) {
  const parent = await memory.retrieve(parentKey);
  
  if (!parent) return null;
  
  const children = await memory.query({
    valueSearch: JSON.stringify({ parentId: parent.id }),
    type: parent.type
  });
  
  return {
    parent,
    children,
    descendants: await Promise.all(
      children.map(child => getHierarchy(child.key))
    )
  };
}
```

### 2. Join-like Operations

Combine data from multiple queries:

```typescript
// Join user data with their activities
async function getUserWithActivities(userId: string) {
  const [user, activities] = await Promise.all([
    memory.retrieve(`user:${userId}`),
    memory.query({
      keyPattern: `activity:${userId}:.*`,
      sortBy: 'createdAt',
      sortOrder: 'desc',
      limit: 50
    })
  ]);
  
  return {
    ...user,
    recentActivities: activities
  };
}

// Multi-way join
async function getCompleteProjectData(projectId: string) {
  const project = await memory.retrieve(`project:${projectId}`);
  
  const [tasks, members, documents] = await Promise.all([
    memory.query({ tags: [`project-${projectId}`], type: 'task' }),
    memory.query({ tags: [`project-${projectId}`], type: 'member' }),
    memory.query({ tags: [`project-${projectId}`], type: 'document' })
  ]);
  
  return {
    project,
    tasks,
    members,
    documents,
    statistics: {
      taskCount: tasks.length,
      memberCount: members.length,
      documentCount: documents.length
    }
  };
}
```

### 3. Temporal Queries

Time-based query patterns:

```typescript
// Get data for specific time ranges
async function getTimeRangeData(start: Date, end: Date) {
  return await memory.query({
    createdAfter: start,
    createdBefore: end,
    sortBy: 'createdAt',
    sortOrder: 'asc'
  });
}

// Get latest version of each key
async function getLatestVersions(keyPrefix: string) {
  const allVersions = await memory.query({
    keyPattern: `${keyPrefix}.*`
  });
  
  // Group by base key and get latest
  const latest = new Map<string, MemoryEntry>();
  
  for (const entry of allVersions) {
    const baseKey = entry.key.replace(/:v\d+$/, '');
    const existing = latest.get(baseKey);
    
    if (!existing || entry.version > existing.version) {
      latest.set(baseKey, entry);
    }
  }
  
  return Array.from(latest.values());
}
```

## Performance Best Practices

### 1. Query Planning

```typescript
// Optimize query order for best performance
async function optimizedQuery() {
  // Start with most selective criteria
  const results = await memory.query({
    namespace: 'specific-namespace',    // Most selective
    type: 'rare-type',                  // Reduces set further
    tags: ['specific-tag'],             // Additional filtering
    createdAfter: recentDate,           // Time range
    sortBy: 'createdAt',                // Sort remaining
    limit: 100                          // Limit final results
  });
  
  return results;
}
```

### 2. Query Result Caching

```typescript
class SmartQueryCache {
  private cache = new Map<string, CachedResult>();
  
  async query(query: MemoryQuery): Promise<MemoryEntry[]> {
    const key = this.generateCacheKey(query);
    const cached = this.cache.get(key);
    
    // Check if cache is valid
    if (cached && this.isCacheValid(cached, query)) {
      return cached.results;
    }
    
    // Execute query
    const results = await memory.query(query);
    
    // Cache with metadata
    this.cache.set(key, {
      results,
      timestamp: Date.now(),
      query,
      resultCount: results.length
    });
    
    // Invalidate related caches
    this.invalidateRelated(query);
    
    return results;
  }
  
  private isCacheValid(cached: CachedResult, query: MemoryQuery): boolean {
    // Check if temporal queries are still valid
    if (query.createdAfter || query.updatedAfter) {
      return Date.now() - cached.timestamp < 60000; // 1 minute for temporal
    }
    
    // Longer cache for static queries
    return Date.now() - cached.timestamp < 300000; // 5 minutes
  }
}
```

### 3. Query Monitoring

```typescript
class QueryMonitor {
  private metrics = new Map<string, QueryMetrics>();
  
  async monitoredQuery(query: MemoryQuery): Promise<MemoryEntry[]> {
    const start = Date.now();
    const queryType = this.classifyQuery(query);
    
    try {
      const results = await memory.query(query);
      const duration = Date.now() - start;
      
      this.recordMetrics(queryType, {
        duration,
        resultCount: results.length,
        success: true
      });
      
      // Log slow queries
      if (duration > 1000) {
        console.warn('Slow query detected:', {
          query,
          duration,
          resultCount: results.length
        });
      }
      
      return results;
    } catch (error) {
      this.recordMetrics(queryType, {
        duration: Date.now() - start,
        resultCount: 0,
        success: false,
        error
      });
      
      throw error;
    }
  }
  
  getStatistics(): QueryStatistics {
    // Aggregate metrics by query type
    const stats = new Map<string, AggregatedMetrics>();
    
    for (const [type, metrics] of this.metrics) {
      stats.set(type, {
        totalQueries: metrics.count,
        averageDuration: metrics.totalDuration / metrics.count,
        successRate: metrics.successCount / metrics.count,
        averageResults: metrics.totalResults / metrics.successCount
      });
    }
    
    return stats;
  }
}
```

## Error Handling and Recovery

### 1. Graceful Degradation

```typescript
// Fallback strategies for query failures
async function resilientQuery(query: MemoryQuery) {
  try {
    // Try optimized query first
    return await memory.query(query);
  } catch (error) {
    console.warn('Query failed, trying simplified version', error);
    
    try {
      // Simplify query
      const simplified = {
        type: query.type,
        limit: query.limit || 100
      };
      
      return await memory.query(simplified);
    } catch (fallbackError) {
      console.error('Fallback query also failed', fallbackError);
      
      // Return cached results if available
      return getCachedResults(query) || [];
    }
  }
}
```

### 2. Retry Logic

```typescript
// Exponential backoff for transient failures
async function queryWithRetry(
  query: MemoryQuery,
  maxRetries: number = 3
): Promise<MemoryEntry[]> {
  let lastError: Error;
  
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      return await memory.query(query);
    } catch (error) {
      lastError = error;
      
      if (attempt < maxRetries - 1) {
        const delay = Math.pow(2, attempt) * 100; // 100ms, 200ms, 400ms
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  }
  
  throw lastError!;
}
```

This comprehensive guide covers the essential patterns and best practices for querying and retrieving data from the Claude-Flow memory system, enabling efficient and reliable data access for multi-agent collaboration.