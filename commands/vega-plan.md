---
description: Transform a feature request into a ralph-project-compatible project structure with phases, tasks, and Claude instructions
argument-hint: <feature-request.md> [--mode=static|hybrid] [--project-type=auto|agent|ui|api]
---

# Vega Plan - Feature Request to Executable Project

Transform a feature request document into a fully scaffolded project ready for `/ralph-project` execution.

## Usage
```
/vega-plan <feature-request.md>
/vega-plan <feature-request.md> --mode=hybrid
/vega-plan <feature-request.md> --project-type=agent
```

## Arguments
- `$ARGUMENTS` - Path to feature request markdown file (required)

---

## EXECUTION PROTOCOL

### STAGE 1: READ AND ANALYZE FEATURE REQUEST

#### Step 1.1: Load Feature Request

Read the file at `$ARGUMENTS` and extract:

```
EXTRACT FROM DOCUMENT:
- Project Name: (infer from title/filename, use PascalCase_v1 format)
- Description: (1-2 sentence summary)
- Core Requirements: (numbered list of must-haves)
- Technical Domain: (agent, UI, API, database, etc.)
- Success Criteria: (how do we know it's done?)
- Design Decisions: (any decisions already made)
- Constraints: (technology, time, dependencies)
```

#### Step 1.2: Determine Project Type

Analyze content to determine project type:

| If Document Contains | Project Type | Phase Template |
|---------------------|--------------|----------------|
| "agent", "service", "backend" | `agent` | Agent Development |
| "console", "dashboard", "page", "component" | `ui` | Console UI |
| "API", "endpoint", "routes" | `api` | API Development |
| "database", "schema", "query" | `data` | Data Layer |
| "integration", "external service" | `integration` | Integration |
| Mixed/unclear | `hybrid` | General Development |

#### Step 1.3: Assess Complexity

| Indicators | Complexity | Phases |
|------------|------------|--------|
| Single feature, few files | Simple | 2-3 |
| Multiple components, moderate scope | Medium | 3-5 |
| System-wide, many integrations | Complex | 5-7 |

---

### STAGE 2: GENERATE PHASE BREAKDOWN

#### Phase Templates by Project Type

**Agent Development Template:**
```
Phase 1: Foundation & Scaffolding
  - Create module structure
  - Define types and interfaces
  - Register with system
  - Basic API routes

Phase 2: Core Logic
  - Implement primary capabilities
  - Business logic
  - Error handling

Phase 3: Integration
  - Connect to other services
  - External API connections
  - UI hooks

Phase 4: Testing & Polish
  - Unit tests
  - Integration tests
  - Documentation
  - Performance optimization
```

**Console UI Template:**
```
Phase 1: Component Design
  - Page structure
  - Component hierarchy
  - State management design
  - API contracts

Phase 2: Core Implementation
  - Main page component
  - Sub-components
  - API integration
  - Basic styling

Phase 3: Features & Polish
  - Additional features
  - Error states
  - Loading states
  - Responsive design
  - Accessibility

Phase 4: Testing & Documentation
  - Component testing
  - E2E testing
  - Usage documentation
```

**API Development Template:**
```
Phase 1: Schema & Routes
  - Request/Response types
  - Route definitions
  - OpenAPI documentation

Phase 2: Implementation
  - Handler logic
  - Database queries
  - Validation
  - Error handling

Phase 3: Integration & Testing
  - Integration with services
  - Unit tests
  - Integration tests
  - Load testing
```

#### Task Generation Rules

For each phase, generate 6-12 tasks following:

```
P{phase}-{number}: {Action Verb} {Component}
Effort: {S|M|L|XL}
Priority: {CRITICAL|HIGH|MEDIUM|LOW}
Depends On: {P{X}-{Y} or "None"}
```

**Action Verbs:**
- CREATE: New file/module/component
- IMPLEMENT: Core logic/functionality
- ADD: Feature/capability to existing
- INTEGRATE: Connect systems
- WRITE: Tests/documentation
- UPDATE: Modify existing
- CONFIGURE: Settings/config

**Effort Sizing:**
- S (Small): 1-2 hours, single file, simple logic
- M (Medium): 2-4 hours, multiple files, moderate complexity
- L (Large): 4-8 hours, significant feature, integration
- XL (Extra Large): 8+ hours, complex system, multiple integrations

---

### STAGE 3: CREATE PROJECT FOLDER

#### Step 3.1: Determine Project Location

```
projects/{ProjectName}/
```

Where `{ProjectName}` is derived from feature request title in PascalCase_v1 format.

**Examples:**
- "Social Media Post Optimizer" -> `SocialMediaOptimizer_v1`
- "Add Image Support" -> `ImageSupport_v1`

#### Step 3.2: Create Directory Structure

```bash
mkdir -p projects/{ProjectName}/phases
```

#### Step 3.3: Generate PROJECT_STATUS.md

Create `projects/{ProjectName}/PROJECT_STATUS.md`:

```markdown
# PROJECT_STATUS.md - {ProjectName}

**Project:** {ProjectName}
**Created:** {TODAY}
**Status:** NOT_STARTED
**Source:** {original filename}

---

## Overall Progress

| Field | Value |
|-------|-------|
| Status | NOT_STARTED |
| Progress | 0% |
| Current Phase | - |
| Phases Complete | 0/{total_phases} |
| Total Tasks | {total_tasks} |

---

## Phase Status

| Phase | Name | Status | Progress | Tasks |
|-------|------|--------|----------|-------|
{for each phase}
| {N} | {name} | NOT_STARTED | 0% | {task_count} |
{end for}

---

## Defects

*None*

---

## Recent Activity

| Date | Activity |
|------|----------|
| {TODAY} | Project created via /vega-plan |

---

## Quick Commands

\`\`\`bash
# Execute all phases
/ralph-project projects/{ProjectName}

# Execute single phase
/ralph projects/{ProjectName}/phases/phase_01_{name}/PHASE.md
\`\`\`

---

**Last Updated:** {TODAY}
```

#### Step 3.4: Generate PROJECT_PLAN.md

Create `projects/{ProjectName}/PROJECT_PLAN.md` with full work breakdown structure.

#### Step 3.5: Copy Feature Request

Copy `$ARGUMENTS` to `projects/{ProjectName}/FEATURE_REQUEST.md`

---

### STAGE 4: GENERATE PHASE FILES

For EACH phase:

#### Step 4.1: Create Phase Directory

```
projects/{ProjectName}/phases/phase_{NN}_{name}/
```

Where `{NN}` is zero-padded phase number (01, 02, ...) and `{name}` is lowercase with underscores.

#### Step 4.2: Generate PHASE.md

Create `PHASE.md` in each phase directory with:
- Frontmatter (status_file, completion_promise, project, phase, title)
- Objective
- Prerequisites
- Architecture Overview
- Detailed Tasks with acceptance criteria
- Success Criteria
- Execution Order

#### Step 4.3: Generate PHASE_STATUS.md

Create `PHASE_STATUS.md` in each phase directory with:
- Overall Progress table
- Task Status table
- Blockers section
- Files Modified section
- Daily Log section

---

### STAGE 5: GENERATE CLAUDE INSTRUCTIONS

Create `projects/{ProjectName}/CLAUDE_INSTRUCTIONS.md`:

This file provides project-specific guidance including:
- Technical decisions
- Code patterns to follow
- Reference implementations
- Files to create
- Testing requirements
- Success criteria

---

### STAGE 6: GENERATE RALPH LOOP PROMPT

Create `projects/{ProjectName}/RALPH_LOOP_PROMPT.md`:

This file provides the execution template for autonomous work sessions.

---

### STAGE 7: VALIDATION AND OUTPUT

#### Step 7.1: Validate Structure

Verify all required files exist:
- [ ] PROJECT_STATUS.md
- [ ] PROJECT_PLAN.md
- [ ] FEATURE_REQUEST.md
- [ ] CLAUDE_INSTRUCTIONS.md
- [ ] RALPH_LOOP_PROMPT.md
- [ ] phases/ directory with all phase folders
- [ ] Each phase has PHASE.md and PHASE_STATUS.md

#### Step 7.2: Output Summary

```
## Project Created: {ProjectName}

**Location:** projects/{ProjectName}/

### Structure
projects/{ProjectName}/
├── PROJECT_STATUS.md
├── PROJECT_PLAN.md
├── FEATURE_REQUEST.md
├── CLAUDE_INSTRUCTIONS.md
├── RALPH_LOOP_PROMPT.md
└── phases/
    ├── phase_01_{name}/
    │   ├── PHASE.md ({task_count} tasks)
    │   └── PHASE_STATUS.md
    ... (all phases)

### Summary
| Phase | Name | Tasks | Effort |
|-------|------|-------|--------|
{summary table}
| **Total** | | **{total}** | |

### Next Steps

1. Review CLAUDE_INSTRUCTIONS.md for project guidance
2. Review phase documents for task details
3. Execute with: `/ralph-project projects/{ProjectName}`

---
Project ready for autonomous execution.
```

---

## RULES (NON-NEGOTIABLE)

1. **Always create all files** - No partial scaffolding
2. **Follow naming conventions** - PascalCase_v1 for project, lowercase_underscore for phases
3. **Include acceptance criteria** - Every task must have testable criteria
4. **Maintain ralph-project compatibility** - Structure must work with `/ralph-project`
5. **Copy original feature request** - Preserve source document

---

## ERROR HANDLING

If feature request is incomplete:
1. List missing information
2. Ask user to provide missing details
3. Do NOT scaffold partial project

If structure validation fails:
1. Report which files are missing
2. Attempt to generate missing files
3. Re-validate before completion

---

## BEGIN EXECUTION

Read `$ARGUMENTS` and begin project scaffolding NOW.

Follow all stages in order. Do not skip any stage.
