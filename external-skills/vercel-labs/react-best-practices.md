---
name: vercel-react-best-practices
description: React and Next.js performance optimization guidelines from Vercel Engineering. Use when working on components, pages, data fetching, bundle optimization, or performance work.
version: 1.0.0
author: vercel
source: https://github.com/vercel-labs/agent-skills
triggers:
  - react optimization
  - next.js performance
  - bundle size
  - re-render
  - waterfall
  - suspense
  - server component
  - client component
  - useMemo
  - useCallback
---

# React Best Practices

**Version 1.0.0**
Vercel Engineering
January 2026

> **Note:**
> This document is mainly for agents and LLMs to follow when maintaining,
> generating, or refactoring React and Next.js codebases at Vercel. Humans
> may also find it useful, but guidance here is optimized for automation
> and consistency by AI-assisted workflows.

---

## Abstract

Comprehensive performance optimization guide for React and Next.js applications, designed for AI agents and LLMs. Contains 40+ rules across 8 categories, prioritized by impact from critical (eliminating waterfalls, reducing bundle size) to incremental (advanced patterns). Each rule includes detailed explanations, real-world examples comparing incorrect vs. correct implementations, and specific impact metrics to guide automated refactoring and code generation.

---

## Table of Contents

1. [Eliminating Waterfalls](#1-eliminating-waterfalls) — **CRITICAL**
2. [Bundle Size Optimization](#2-bundle-size-optimization) — **CRITICAL**
3. [Server-Side Performance](#3-server-side-performance) — **HIGH**
4. [Client-Side Data Fetching](#4-client-side-data-fetching) — **MEDIUM-HIGH**
5. [Re-render Optimization](#5-re-render-optimization) — **MEDIUM**
6. [Rendering Performance](#6-rendering-performance) — **MEDIUM**
7. [JavaScript Performance](#7-javascript-performance) — **LOW-MEDIUM**
8. [Advanced Patterns](#8-advanced-patterns) — **LOW**

---

## 1. Eliminating Waterfalls

**Impact: CRITICAL**

Waterfalls are the #1 performance killer. Each sequential await adds full network latency. Eliminating them yields the largest gains.

### 1.1 Defer Await Until Needed

**Impact: HIGH (avoids blocking unused code paths)**

Move `await` operations into the branches where they're actually used to avoid blocking code paths that don't need them.

**Incorrect: blocks both branches**

```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  const userData = await fetchUserData(userId)

  if (skipProcessing) {
    return { skipped: true }
  }

  return processUserData(userData)
}
```

**Correct: only blocks when needed**

```typescript
async function handleRequest(userId: string, skipProcessing: boolean) {
  if (skipProcessing) {
    return { skipped: true }
  }

  const userData = await fetchUserData(userId)
  return processUserData(userData)
}
```

### 1.2 Dependency-Based Parallelization

**Impact: CRITICAL (2-10x improvement)**

For operations with partial dependencies, use `better-all` to maximize parallelism.

**Incorrect: profile waits for config unnecessarily**

```typescript
const [user, config] = await Promise.all([
  fetchUser(),
  fetchConfig()
])
const profile = await fetchProfile(user.id)
```

**Correct: config and profile run in parallel**

```typescript
import { all } from 'better-all'

const { user, config, profile } = await all({
  async user() { return fetchUser() },
  async config() { return fetchConfig() },
  async profile() {
    return fetchProfile((await this.$.user).id)
  }
})
```

### 1.3 Prevent Waterfall Chains in API Routes

**Impact: CRITICAL (2-10x improvement)**

Start independent operations immediately, even if you don't await them yet.

**Incorrect: config waits for auth, data waits for both**

```typescript
export async function GET(request: Request) {
  const session = await auth()
  const config = await fetchConfig()
  const data = await fetchData(session.user.id)
  return Response.json({ data, config })
}
```

**Correct: auth and config start immediately**

```typescript
export async function GET(request: Request) {
  const sessionPromise = auth()
  const configPromise = fetchConfig()
  const session = await sessionPromise
  const [config, data] = await Promise.all([
    configPromise,
    fetchData(session.user.id)
  ])
  return Response.json({ data, config })
}
```

### 1.4 Promise.all() for Independent Operations

**Impact: CRITICAL (2-10x improvement)**

When async operations have no interdependencies, execute them concurrently.

**Incorrect: sequential execution, 3 round trips**

```typescript
const user = await fetchUser()
const posts = await fetchPosts()
const comments = await fetchComments()
```

**Correct: parallel execution, 1 round trip**

```typescript
const [user, posts, comments] = await Promise.all([
  fetchUser(),
  fetchPosts(),
  fetchComments()
])
```

### 1.5 Strategic Suspense Boundaries

**Impact: HIGH (faster initial paint)**

Use Suspense boundaries to show wrapper UI faster while data loads.

**Incorrect: wrapper blocked by data fetching**

```tsx
async function Page() {
  const data = await fetchData()

  return (
    <div>
      <div>Sidebar</div>
      <DataDisplay data={data} />
      <div>Footer</div>
    </div>
  )
}
```

**Correct: wrapper shows immediately, data streams in**

```tsx
function Page() {
  return (
    <div>
      <div>Sidebar</div>
      <Suspense fallback={<Skeleton />}>
        <DataDisplay />
      </Suspense>
      <div>Footer</div>
    </div>
  )
}

async function DataDisplay() {
  const data = await fetchData()
  return <div>{data.content}</div>
}
```

---

## 2. Bundle Size Optimization

**Impact: CRITICAL**

Reducing initial bundle size improves Time to Interactive and Largest Contentful Paint.

### 2.1 Avoid Barrel File Imports

**Impact: CRITICAL (200-800ms import cost, slow builds)**

Import directly from source files instead of barrel files.

**Incorrect: imports entire library**

```tsx
import { Check, X, Menu } from 'lucide-react'
```

**Correct: imports only what you need**

```tsx
import Check from 'lucide-react/dist/esm/icons/check'
import X from 'lucide-react/dist/esm/icons/x'
import Menu from 'lucide-react/dist/esm/icons/menu'
```

**Alternative: Next.js 13.5+**

```js
// next.config.js
module.exports = {
  experimental: {
    optimizePackageImports: ['lucide-react', '@mui/material']
  }
}
```

### 2.2 Dynamic Imports for Heavy Components

**Impact: CRITICAL (directly affects TTI and LCP)**

Use `next/dynamic` to lazy-load large components not needed on initial render.

**Incorrect: Monaco bundles with main chunk ~300KB**

```tsx
import { MonacoEditor } from './monaco-editor'
```

**Correct: Monaco loads on demand**

```tsx
import dynamic from 'next/dynamic'

const MonacoEditor = dynamic(
  () => import('./monaco-editor').then(m => m.MonacoEditor),
  { ssr: false }
)
```

### 2.3 Defer Non-Critical Third-Party Libraries

**Impact: MEDIUM (loads after hydration)**

Analytics, logging, and error tracking don't block user interaction.

```tsx
import dynamic from 'next/dynamic'

const Analytics = dynamic(
  () => import('@vercel/analytics/react').then(m => m.Analytics),
  { ssr: false }
)
```

### 2.4 Preload Based on User Intent

**Impact: MEDIUM (reduces perceived latency)**

```tsx
function EditorButton({ onClick }: { onClick: () => void }) {
  const preload = () => {
    if (typeof window !== 'undefined') {
      void import('./monaco-editor')
    }
  }

  return (
    <button
      onMouseEnter={preload}
      onFocus={preload}
      onClick={onClick}
    >
      Open Editor
    </button>
  )
}
```

---

## 3. Server-Side Performance

**Impact: HIGH**

### 3.1 Cross-Request LRU Caching

**Impact: HIGH (caches across requests)**

```typescript
import { LRUCache } from 'lru-cache'

const cache = new LRUCache<string, any>({
  max: 1000,
  ttl: 5 * 60 * 1000
})

export async function getUser(id: string) {
  const cached = cache.get(id)
  if (cached) return cached

  const user = await db.user.findUnique({ where: { id } })
  cache.set(id, user)
  return user
}
```

### 3.2 Minimize Serialization at RSC Boundaries

**Impact: HIGH (reduces data transfer size)**

**Incorrect: serializes all 50 fields**

```tsx
async function Page() {
  const user = await fetchUser()
  return <Profile user={user} />
}
```

**Correct: serializes only needed fields**

```tsx
async function Page() {
  const user = await fetchUser()
  return <Profile name={user.name} />
}
```

### 3.3 Parallel Data Fetching with Component Composition

**Impact: CRITICAL (eliminates server-side waterfalls)**

**Incorrect: Sidebar waits for Page's fetch**

```tsx
export default async function Page() {
  const header = await fetchHeader()
  return (
    <div>
      <div>{header}</div>
      <Sidebar />
    </div>
  )
}
```

**Correct: both fetch simultaneously**

```tsx
export default function Page() {
  return (
    <div>
      <Header />
      <Sidebar />
    </div>
  )
}
```

### 3.4 Per-Request Deduplication with React.cache()

**Impact: MEDIUM (deduplicates within request)**

```typescript
import { cache } from 'react'

export const getCurrentUser = cache(async () => {
  const session = await auth()
  if (!session?.user?.id) return null
  return await db.user.findUnique({
    where: { id: session.user.id }
  })
})
```

### 3.5 Use after() for Non-Blocking Operations

**Impact: MEDIUM (faster response times)**

```tsx
import { after } from 'next/server'

export async function POST(request: Request) {
  await updateDatabase(request)

  after(async () => {
    logUserAction({ userAgent: request.headers.get('user-agent') })
  })

  return Response.json({ status: 'success' })
}
```

---

## 4. Client-Side Data Fetching

**Impact: MEDIUM-HIGH**

### 4.1 Use SWR for Automatic Deduplication

**Impact: MEDIUM-HIGH (automatic deduplication)**

**Incorrect: no deduplication**

```tsx
function UserList() {
  const [users, setUsers] = useState([])
  useEffect(() => {
    fetch('/api/users').then(r => r.json()).then(setUsers)
  }, [])
}
```

**Correct: multiple instances share one request**

```tsx
import useSWR from 'swr'

function UserList() {
  const { data: users } = useSWR('/api/users', fetcher)
}
```

---

## 5. Re-render Optimization

**Impact: MEDIUM**

### 5.1 Use Functional setState Updates

**Impact: MEDIUM (prevents stale closures)**

**Incorrect: requires state as dependency**

```tsx
const addItems = useCallback((newItems: Item[]) => {
  setItems([...items, ...newItems])
}, [items])
```

**Correct: stable callbacks**

```tsx
const addItems = useCallback((newItems: Item[]) => {
  setItems(curr => [...curr, ...newItems])
}, [])
```

### 5.2 Use Lazy State Initialization

**Impact: MEDIUM (wasted computation on every render)**

**Incorrect: runs on every render**

```tsx
const [settings, setSettings] = useState(
  JSON.parse(localStorage.getItem('settings') || '{}')
)
```

**Correct: runs only once**

```tsx
const [settings, setSettings] = useState(() => {
  const stored = localStorage.getItem('settings')
  return stored ? JSON.parse(stored) : {}
})
```

### 5.3 Use Transitions for Non-Urgent Updates

**Impact: MEDIUM (maintains UI responsiveness)**

```tsx
import { startTransition } from 'react'

const handler = () => {
  startTransition(() => setScrollY(window.scrollY))
}
```

### 5.4 Narrow Effect Dependencies

**Impact: LOW (minimizes effect re-runs)**

**Incorrect: re-runs on any user field change**

```tsx
useEffect(() => {
  console.log(user.id)
}, [user])
```

**Correct: re-runs only when id changes**

```tsx
useEffect(() => {
  console.log(user.id)
}, [user.id])
```

---

## 6. Rendering Performance

**Impact: MEDIUM**

### 6.1 CSS content-visibility for Long Lists

**Impact: HIGH (faster initial render)**

```css
.message-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```

### 6.2 Hoist Static JSX Elements

**Impact: LOW (avoids re-creation)**

**Incorrect: recreates element every render**

```tsx
function Container() {
  return <div>{loading && <LoadingSkeleton />}</div>
}
```

**Correct: reuses same element**

```tsx
const loadingSkeleton = <div className="animate-pulse h-20 bg-gray-200" />

function Container() {
  return <div>{loading && loadingSkeleton}</div>
}
```

### 6.3 Prevent Hydration Mismatch Without Flickering

**Impact: MEDIUM (avoids visual flicker)**

```tsx
function ThemeWrapper({ children }: { children: ReactNode }) {
  return (
    <>
      <div id="theme-wrapper">{children}</div>
      <script
        dangerouslySetInnerHTML={{
          __html: `
            (function() {
              var theme = localStorage.getItem('theme') || 'light';
              document.getElementById('theme-wrapper').className = theme;
            })();
          `,
        }}
      />
    </>
  )
}
```

---

## 7. JavaScript Performance

**Impact: LOW-MEDIUM**

### 7.1 Build Index Maps for Repeated Lookups

**Impact: LOW-MEDIUM (1M ops to 2K ops)**

**Incorrect (O(n) per lookup):**

```typescript
return orders.map(order => ({
  ...order,
  user: users.find(u => u.id === order.userId)
}))
```

**Correct (O(1) per lookup):**

```typescript
const userById = new Map(users.map(u => [u.id, u]))
return orders.map(order => ({
  ...order,
  user: userById.get(order.userId)
}))
```

### 7.2 Use Set/Map for O(1) Lookups

**Impact: LOW-MEDIUM (O(n) to O(1))**

**Incorrect:**

```typescript
items.filter(item => allowedIds.includes(item.id))
```

**Correct:**

```typescript
const allowedIds = new Set(['a', 'b', 'c'])
items.filter(item => allowedIds.has(item.id))
```

### 7.3 Use toSorted() Instead of sort()

**Impact: MEDIUM-HIGH (prevents mutation bugs)**

**Incorrect: mutates original array**

```typescript
const sorted = users.sort((a, b) => a.name.localeCompare(b.name))
```

**Correct: creates new array**

```typescript
const sorted = users.toSorted((a, b) => a.name.localeCompare(b.name))
```

### 7.4 Early Return from Functions

**Impact: LOW-MEDIUM (avoids unnecessary computation)**

**Incorrect: processes all items**

```typescript
function validateUsers(users: User[]) {
  let hasError = false
  for (const user of users) {
    if (!user.email) hasError = true
  }
  return !hasError
}
```

**Correct: returns immediately**

```typescript
function validateUsers(users: User[]) {
  for (const user of users) {
    if (!user.email) return { valid: false, error: 'Email required' }
  }
  return { valid: true }
}
```

---

## 8. Advanced Patterns

**Impact: LOW**

### 8.1 Store Event Handlers in Refs

**Impact: LOW (stable subscriptions)**

```tsx
import { useEffectEvent } from 'react'

function useWindowEvent(event: string, handler: () => void) {
  const onEvent = useEffectEvent(handler)

  useEffect(() => {
    window.addEventListener(event, onEvent)
    return () => window.removeEventListener(event, onEvent)
  }, [event])
}
```

---

## References

1. [https://react.dev](https://react.dev)
2. [https://nextjs.org](https://nextjs.org)
3. [https://swr.vercel.app](https://swr.vercel.app)
4. [https://github.com/shuding/better-all](https://github.com/shuding/better-all)
5. [https://vercel.com/blog/how-we-optimized-package-imports-in-next-js](https://vercel.com/blog/how-we-optimized-package-imports-in-next-js)

---

**End of document**
