# Common Error Patterns Reference

Quick reference for diagnosing common error patterns by category. Use alongside the debugging skill.

## Database Errors

| Error Pattern | Likely Cause | Investigation |
|--------------|-------------|---------------|
| Connection refused | DB not running, wrong port/host, firewall | Check connection string, verify DB is up |
| Timeout | Slow query, connection pool exhausted, deadlock | Check query performance, pool size, locks |
| Unique constraint violation | Duplicate insert, race condition | Check for upsert pattern, add proper locking |
| Foreign key violation | Referenced record doesn't exist or was deleted | Check cascade rules, verify parent exists |
| Migration failed | Schema conflict, data incompatibility | Check migration order, rollback and fix |
| N+1 queries | Loading related data in a loop | Use eager loading / joins / batch queries |

## API Errors

| Error Pattern | Likely Cause | Investigation |
|--------------|-------------|---------------|
| CORS error | Missing headers, wrong origin, preflight failing | Check CORS config, verify allowed origins |
| 401 after working | Token expired, session invalidated | Check token lifetime, refresh logic |
| 403 on valid user | Missing permission, wrong role check | Trace authorization logic, check role |
| 500 with no details | Unhandled exception, missing error handler | Check server logs, add error middleware |
| Request body empty | Missing Content-Type header, body parser issue | Check headers, middleware order |
| Stale data after mutation | Cache not invalidated | Invalidate relevant cache keys after write |

## Frontend Errors

| Error Pattern | Likely Cause | Investigation |
|--------------|-------------|---------------|
| Hydration mismatch | Server/client render different output | Check for browser-only APIs, date/random |
| Infinite re-render | State update in render path, missing deps | Check useEffect deps, component hierarchy |
| Stale closure | Callback captures old state value | Use refs for values in callbacks |
| "Cannot read property of undefined" | Async data not loaded yet, optional chaining missing | Add loading states, null checks |
| Memory leak warning | Unmounted component state update | Cancel async ops on unmount |
| Blank page | JS error in root component, missing error boundary | Add error boundary, check console |

## Authentication Errors

| Error Pattern | Likely Cause | Investigation |
|--------------|-------------|---------------|
| Login works, redirect fails | Missing callback URL, wrong redirect config | Check auth callback configuration |
| Session lost on refresh | Cookie settings wrong, not httpOnly/secure | Check cookie config, domain/path |
| OAuth callback error | Wrong redirect URI, expired state parameter | Verify OAuth app config matches |
| "Invalid token" intermittent | Clock skew, token near expiry | Check token lifetime, add buffer |

## Build/Deploy Errors

| Error Pattern | Likely Cause | Investigation |
|--------------|-------------|---------------|
| Works locally, fails in CI | Env var missing, different Node version | Compare environments, check CI config |
| Type error only in build | Strict mode differences, import order | Run build locally with same config |
| Module not found | Missing dependency, wrong import path | Check package.json, import aliases |
| Out of memory | Large build, no swap, too many parallel tasks | Increase memory limit, reduce parallelism |

## Debugging Decision Tree

```
Error occurs
├── Can you reproduce it?
│   ├── Yes → Isolate: remove code until it stops, then add back
│   └── No → Check: is it timing-dependent? Data-dependent? Environment-dependent?
│
├── Do you know WHERE it occurs?
│   ├── Yes → Read the code at that location, trace inputs
│   └── No → Add logging/breakpoints to narrow down
│
├── Do you know WHEN it started?
│   ├── Yes → git bisect to find the causing commit
│   └── No → Check memory/recent_deltas.md for recent changes
│
└── Is it intermittent?
    ├── Yes → Likely: race condition, timing issue, resource exhaustion
    └── No → Likely: logic error, configuration issue, missing dependency
```
