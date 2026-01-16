---
description: Create a complete project structure with phases from a technical design document
argument-hint: <path-to-design-doc>
---

# Project Scaffolding Skill

Create a complete project structure with phases from a technical design document.

## Usage
```
/project <path-to-design-doc>
```

## Arguments
- `$ARGUMENTS` - Path to a markdown file containing technical design, requirements, or desired outcomes

---

## INSTRUCTIONS

You are creating a new project from the design document: `$ARGUMENTS`

---

## PHASE 1: ANALYSIS

### Step 1.1: Read Design Document

Read the file at `$ARGUMENTS` and extract:
- **Project Name**: Infer from title, filename, or content (use PascalCase_v1 format)
- **Project Description**: 1-2 sentence summary
- **Problem Statement**: What problem does this solve?
- **Solution Overview**: High-level approach
- **Key Features/Requirements**: List of deliverables
- **Technical Constraints**: Languages, frameworks, dependencies
- **Success Criteria**: How do we know it's done?

### Step 1.2: Determine Phase Breakdown

Analyze the requirements and break into logical phases:

**Phase Sizing Guidelines:**
- Each phase should be 20-40 hours of estimated work
- Each phase should have 8-12 tasks
- Phases should have clear dependencies (Phase N depends on Phase N-1)
- Each phase should deliver testable/demonstrable value

**Typical Phase Pattern:**
| Phase | Name | Purpose |
|-------|------|---------|
| 1 | Foundation | Core infrastructure, data models, basic wiring |
| 2 | Core Features | Primary functionality implementation |
| 3 | Integration | Connect components, external services |
| 4 | Enhancement | Secondary features, optimizations |
| 5 | Polish | Error handling, edge cases, testing |

**Adjust phases based on project complexity:**
- Simple project (1 feature): 2-3 phases
- Medium project (multiple features): 3-5 phases
- Complex project (system redesign): 5-7 phases

### Step 1.3: Generate Task Breakdown

For each phase, generate tasks following this pattern:

**Task Structure:**
```
P{phase}-{number}: {Action Verb} {Component/Feature}
Effort: {hours}h
Priority: CRITICAL | HIGH | MEDIUM | LOW
Depends On: P{X}-{Y} (if applicable)
```

**Task Sizing:**
- 2-4 hours: Simple implementation, single file
- 4-6 hours: Moderate complexity, multiple files
- 6-8 hours: Complex feature, integration work

**Task Naming Convention:**
- Use action verbs: Create, Implement, Add, Build, Update, Integrate, Write
- Be specific: "Create ThreadManager service" not "Do threading stuff"

---

## PHASE 2: PROJECT CREATION

### Step 2.1: Create Project Folder

```
projects/{ProjectName}/
```

### Step 2.2: Create PROJECT_PLAN.md

Create `{project_root}/PROJECT_PLAN.md` with this structure:

```markdown
# PROJECT_PLAN.md - {ProjectName}

## Comprehensive Project Plan

**Project:** {ProjectName}
**Version:** 1.0
**Date:** {TODAY}
**Status:** Ready for Implementation
**Location:** `projects/{ProjectName}/`

---

## 1. Project Overview

### 1.1 Problem Statement
{Extracted from design doc}

### 1.2 Solution Summary
{Extracted from design doc}

### 1.3 Key Features
{List of features/requirements}

---

## 2. Architecture Decisions
{Technical decisions, frameworks, patterns}

---

## 3. Work Breakdown Structure

### Phase 1: {Phase1Name}
| Task ID | Task | Effort |
|---------|------|--------|
| P1-01 | {task} | {hours}h |
...

### Phase 2: {Phase2Name}
...

---

## 4. Success Criteria
{Extracted success criteria}

---

## 5. Dependencies
{External dependencies, APIs, services}

---

## 6. Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
...

---

## 7. Phase Order
{Phase order and dependencies}

---

**Document Status:** Ready for Implementation
**Next Step:** Phase 1 - {Phase1Name}
```

### Step 2.3: Create README.md

Create `{project_root}/README.md` with:

```markdown
# {ProjectName}

{Short description}

## Status

| Phase | Name | Status | Progress |
|-------|------|--------|----------|
| 1 | {name} | NOT_STARTED | 0% |
| 2 | {name} | NOT_STARTED | 0% |
...

## Quick Start

```
/ralph projects/{ProjectName}/phase1/phase1.md
```

## Documentation

- [Project Plan](./PROJECT_PLAN.md)
- [Phase 1](./phase1/phase1.md)
...

## Created

- **Date:** {TODAY}
- **Source:** {original design doc filename}
```

---

## PHASE 3: PHASE FILE CREATION

For each phase identified, create the folder and files:

### Step 3.1: Create Phase Folder

```
{project_root}/phase{N}/
```

### Step 3.2: Create Phase Document (phase{N}.md)

```markdown
# Phase {N}: {PhaseName}

**Project:** {ProjectName}
**Phase:** {N} of {Total}
**Estimated Effort:** {sum of task hours} hours
**Status:** NOT_STARTED

---

## Objective

{2-3 sentences describing what this phase accomplishes}

---

## Deliverables

### P{N}-01: {TaskName}
**Effort:** {hours} hours
**Priority:** {CRITICAL|HIGH|MEDIUM|LOW}
**Depends On:** {P{X}-{Y} or "None"}

**Description:**
{Detailed description of what needs to be built}

**File to Create/Modify:**
```
{file path}
```

**Acceptance Criteria:**
- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

---

### P{N}-02: {TaskName}
... (repeat for all tasks)

---

## Success Criteria (Phase {N} Complete When All Pass)

| Criteria | Target | Verification Method |
|----------|--------|---------------------|
| {criterion} | {target} | {method} |
...

---

## Dependencies

| Dependency | Status | Notes |
|------------|--------|-------|
| Phase {N-1} Complete | {status} | {notes} |
...

---

## Execution Order

```
P{N}-01 ({name})
    |
    v
P{N}-02 ({name})
    |
... (ASCII art dependency graph)
```

---

**Document Status:** READY FOR IMPLEMENTATION
**Created:** {TODAY}
**Depends On:** Phase {N-1} ({PhaseName})
```

### Step 3.3: Create Phase Status File (phase{N}status.md)

```markdown
# Phase {N} Status Tracker

**Project:** {ProjectName}
**Phase:** {N} - {PhaseName}
**Estimated Effort:** {hours} hours

---

## Overall Progress

| Field | Value |
|-------|-------|
| Started | - |
| Completed | - |
| Status | NOT_STARTED |
| Progress | 0% (0/{task_count} tasks) |

---

## Task Status

| ID | Task | Status | Assignee | Started | Completed | Notes |
|----|------|--------|----------|---------|-----------|-------|
| P{N}-01 | {task} | NOT_STARTED | - | - | - | |
| P{N}-02 | {task} | NOT_STARTED | - | - | - | |
...

---

## Status Legend

| Status | Description |
|--------|-------------|
| NOT_STARTED | Work has not begun |
| IN_PROGRESS | Actively being worked on |
| BLOCKED | Cannot proceed (see blockers) |
| REVIEW | Code complete, awaiting review |
| COMPLETE | Done and verified |

---

## Success Criteria Tracking

| Criteria | Target | Current | Status |
|----------|--------|---------|--------|
| {criterion} | {target} | - | NOT_TESTED |
...

---

## Blockers

*None currently*

---

## Daily Log

*No entries yet*

---

## Files Created/Modified

| File | Status | Task |
|------|--------|------|
| `{path}` | PENDING | P{N}-01 |
...

---

**Last Updated:** {TODAY}
**Updated By:** Claude Code
```

---

## PHASE 4: COMPLETION

### Step 4.1: Copy Original Design Doc

Copy `$ARGUMENTS` to `{project_root}/ORIGINAL_DESIGN.md` for reference.

### Step 4.2: Output Summary

Display to user:

```
## Project Created: {ProjectName}

**Location:** projects/{ProjectName}/

### Structure
projects/{ProjectName}/
├── PROJECT_PLAN.md
├── README.md
├── ORIGINAL_DESIGN.md
├── phase1/
│   ├── phase1.md ({task_count} tasks, {hours}h)
│   └── phase1status.md
├── phase2/
│   ├── phase2.md ({task_count} tasks, {hours}h)
│   └── phase2status.md
... (all phases)

### Summary
| Phase | Name | Tasks | Hours |
|-------|------|-------|-------|
| 1 | {name} | {n} | {h} |
| 2 | {name} | {n} | {h} |
...
| **Total** | | **{total}** | **{total}** |

### Next Step
```
/ralph projects/{ProjectName}/phase1/phase1.md
```
```

---

## RULES

1. **Phases must be sequential** - Phase N depends on Phase N-1
2. **Tasks must be actionable** - Clear deliverables, not vague goals
3. **Use consistent naming** - PascalCase_v1 for projects, phase{N} for folders
4. **Include acceptance criteria** - Every task needs testable criteria
5. **Preserve original design** - Copy source doc for reference

---

## QUALITY CHECKLIST

Before completing, verify:
- [ ] PROJECT_PLAN.md has all sections filled
- [ ] Each phase has clear objective
- [ ] Each task has description, effort, acceptance criteria
- [ ] Dependencies are correctly mapped
- [ ] Status files match task lists
- [ ] File paths are realistic for the codebase

---

## Example

Input: `designs/chat-bot-redesign.md`

Output:
```
projects/ChatBotRedesign_v1/
├── PROJECT_PLAN.md
├── README.md
├── ORIGINAL_DESIGN.md
├── phase1/
│   ├── phase1.md
│   └── phase1status.md
├── phase2/
│   ├── phase2.md
│   └── phase2status.md
└── phase3/
    ├── phase3.md
    └── phase3status.md
```
