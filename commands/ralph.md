---
description: Execute a Ralph Wiggum iterative loop on a task file with automatic context loading and notifications
argument-hint: <path-to-task-file>
---

# Ralph Loop with Auto-Context & Notifications

Execute a Ralph Wiggum iterative loop on a task file with automatic context loading and notifications.

## Usage
```
/ralph <path-to-task-file>
```

## Arguments
- `$ARGUMENTS` - Path to the task markdown file (required)

---

## INSTRUCTIONS

You are executing an autonomous Ralph Wiggum loop on the task file: `$ARGUMENTS`

---

## PHASE 0: CONTEXT LOADING (CRITICAL - DO THIS FIRST)

Before ANY task execution, load context in this order:

### Step 0.1: Load Core Context

Read these files for overall system understanding:
```
CLAUDE.md
docs/ROADMAP.md (if exists)
docs/ARCHITECTURE.md (if exists)
```

### Step 0.2: Auto-Detect Project Structure

Parse the task file path (`$ARGUMENTS`) to detect project context:

**Detection Rules:**
1. If path contains `/phaseX/` or `\phaseX\` (where X is a number or "25"):
   - Extract phase number (e.g., `phase2` -> 2, `phase25` -> 2.5)
   - Project root = parent directory of `phaseX/`

2. If path contains `/projects/` or `\projects\`:
   - Project root = first directory after `projects/`

**Example:**
```
$ARGUMENTS = projects/MyProject_v1/phase2/phase2.md
-> Project root: projects/MyProject_v1/
-> Current phase: 2
-> Previous phase: 1
```

### Step 0.3: Load Project Context

From detected project root, read:
```
{project_root}/PROJECT_PLAN.md (if exists)
{project_root}/README.md (if exists)
```

### Step 0.4: Load Previous Phase Context (if not Phase 1)

If current phase > 1, read previous phase files:
```
{project_root}/phase{N-1}/phase{N-1}status.md
```

Then parse the "Files Created/Modified" section and read files marked as CREATED or MODIFIED (limit to first 10 most important files).

### Step 0.5: Load Current Phase Status

Read the current phase status file:
```
{project_root}/phase{N}/phase{N}status.md
```

---

## PHASE 1: INITIALIZATION

### Step 1.1: Read and Parse Task File

Read the task file at `$ARGUMENTS`. Extract:
- Task list (numbered items or table)
- Status tracker path (if specified in frontmatter)
- Completion promise (if specified, default: `LOOP_COMPLETE`)

### Step 1.2: Initialize Loop State

Create/update `.claude/ralph-loop.local.md` with:
```yaml
---
active: true
iteration: 1
max_iterations: 50
completion_promise: [extracted or LOOP_COMPLETE]
started_at: [current ISO timestamp]
task_file: $ARGUMENTS
project_root: [detected project root]
current_phase: [detected phase number]
---
```

---

## PHASE 2: TASK EXECUTION

For EACH task in the task list:

### Step 2.1: Execute the Task
Execute the task per its requirements in the phase document.

### Step 2.2: On Error - Fix and Continue
If errors occur, fix them and continue. Do not abandon the loop.

### Step 2.3: Update Status Tracker
Update the phase status file:
- Mark task as COMPLETE
- Add completion date
- Update progress percentage
- Add to Daily Log section

---

## PHASE 3: COMPLETION

When ALL tasks are complete:

### Step 3.1: Update Status File
- Set overall status to COMPLETE
- Set completion date
- Update progress to 100%

### Step 3.2: Output Completion Promise
```
<promise>[COMPLETION_PROMISE]</promise>
```

### Step 3.3: Mark Loop Inactive
Update `.claude/ralph-loop.local.md` with `active: false`

---

## RULES (NON-NEGOTIABLE)

1. **ALWAYS load context first** - Phase 0 must complete before any task execution
2. **NEVER stop for confirmation** - Execute all tasks autonomously
3. **ALWAYS update status tracker** - After each task completion
4. **Continue on errors** - Fix and proceed, don't abandon the loop
5. **Read previous phase files** - Essential for understanding existing code

---

## CONTEXT LOADING SUMMARY

| Context Type | Files | Purpose |
|--------------|-------|---------|
| Core | CLAUDE.md, ROADMAP.md, ARCHITECTURE.md | System policies, overall direction |
| Project | PROJECT_PLAN.md, README.md | Project-specific architecture |
| Previous Phase | phase{N-1}status.md + created files | Understand existing code |
| Current Phase | phase{N}status.md | Track progress |

---

## Task File Format (Expected)

```markdown
---
status_file: ./phase2status.md
completion_promise: PHASE2_COMPLETE
---

## Tasks
1. P2-01: Create clarification service
2. P2-02: Implement parser
3. P2-03: Write tests
```

---

## Example Execution Flow

```
/ralph projects/MyProject_v1/phase2/phase2.md

1. [CONTEXT] Read CLAUDE.md, ROADMAP.md, ARCHITECTURE.md
2. [CONTEXT] Detect: project=MyProject_v1, phase=2
3. [CONTEXT] Read PROJECT_PLAN.md
4. [CONTEXT] Read phase1/phase1status.md
5. [CONTEXT] Read files from phase1 "Files Created/Modified"
6. [CONTEXT] Read phase2/phase2status.md
7. [LOOP] Execute P2-01 -> execute -> update status
8. [LOOP] Execute P2-02 -> execute -> update status
... (continue for all tasks)
N. Output <promise>PHASE2_COMPLETE</promise>
```
