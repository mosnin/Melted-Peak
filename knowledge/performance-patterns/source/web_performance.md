# Web Performance Patterns Reference

## Core Web Vitals Targets

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | ≤ 2.5s | 2.5s – 4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | ≤ 200ms | 200ms – 500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | ≤ 0.1 | 0.1 – 0.25 | > 0.25 |

## Common Bottlenecks and Fixes

### Network Layer

| Bottleneck | Fix | Impact |
|-----------|-----|--------|
| Too many requests | Bundle, combine, sprite, HTTP/2 | High |
| Large payloads | Compress (gzip/brotli), paginate, field selection | High |
| No caching | Cache-Control headers, CDN, service worker | High |
| Slow DNS/TLS | Preconnect, DNS prefetch | Medium |
| Third-party scripts | Async/defer, load after critical content | Medium |

### JavaScript Layer

| Bottleneck | Fix | Impact |
|-----------|-----|--------|
| Large bundle | Code splitting, lazy loading, tree shaking | High |
| Main thread blocking | Web workers, requestIdleCallback, smaller tasks | High |
| Unnecessary re-renders | React.memo, useMemo, useCallback, virtualization | Medium |
| Polyfills for modern browsers | Differential serving, browserslist | Medium |
| Synchronous operations | Async/await, offload to worker | Medium |

### Image & Media Layer

| Bottleneck | Fix | Impact |
|-----------|-----|--------|
| Unoptimized images | WebP/AVIF, responsive sizes, compression | High |
| Images loaded above fold | Eager load LCP image, lazy load below fold | High |
| No image dimensions | Explicit width/height prevents CLS | Medium |
| Large videos | Lazy load, poster image, stream don't embed | Medium |

### Database Layer

| Bottleneck | Fix | Impact |
|-----------|-----|--------|
| N+1 queries | Eager loading, joins, DataLoader pattern | High |
| Missing indexes | Add indexes on filtered/joined columns | High |
| Full table scans | Add WHERE clauses, pagination, LIMIT | High |
| Large result sets | Pagination, cursor-based for large datasets | Medium |
| Expensive aggregations | Materialized views, pre-computed counters | Medium |
| Connection exhaustion | Connection pooling, pool size tuning | Medium |

### Caching Layer

| Pattern | When to Use | Invalidation |
|---------|------------|-------------|
| **HTTP caching** | Static assets, API responses | Cache-Control, ETag |
| **CDN** | Static files, edge-cached pages | TTL, purge on deploy |
| **In-memory** (Redis) | Session data, rate limits, hot data | TTL, event-based invalidation |
| **Application cache** | Computed results, external API responses | TTL, mutation-triggered |
| **Browser cache** | Service worker, IndexedDB | Versioned cache names |

## Performance Budgets

| Metric | Suggested Budget |
|--------|-----------------|
| Initial JS bundle | < 200KB (gzipped) |
| Total page weight | < 1MB |
| Time to Interactive | < 3.5s |
| First Contentful Paint | < 1.8s |
| Server response time (TTFB) | < 200ms |
| API response (p95) | < 500ms |
| Database query (p95) | < 100ms |

## Measurement Tools

| Tool | What It Measures |
|------|-----------------|
| Lighthouse | Overall performance score, CWV, a11y, SEO |
| WebPageTest | Real-world loading, filmstrip, waterfall |
| Chrome DevTools Performance | Runtime performance, flame charts |
| Bundle analyzer | JS bundle composition and size |
| Query logging | Database query performance |
| APM (Sentry, DataDog) | Production performance monitoring |
