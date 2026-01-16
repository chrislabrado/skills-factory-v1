---
description: Execute ALL phases of a project autonomously via chained Ralph loops
argument-hint: <project-path> (e.g., projects/MyProject)
---

# Ralph Project - Multi-Phase Autonomous Execution

Execute ALL phases of a project back-to-back without stopping.

## Usage
```
/ralph-project <project-path>
```

## Arguments
- `$ARGUMENTS` - Path to project directory containing PROJECT_STATUS.md and phases/

---

## EXECUTION PROTOCOL (MANDATORY)

### STEP 1: VALIDATE PROJECT STRUCTURE

Read and verify these files exist:
```
$ARGUMENTS/PROJECT_STATUS.md
$ARGUMENTS/PROJECT_PLAN.md (optional)
$ARGUMENTS/phases/ (directory with phase_XX folders)
```

If PROJECT_STATUS.md doesn't exist, ERROR and stop.

### STEP 2: LOAD CORE CONTEXT

Read these files for system understanding:
```
CLAUDE.md
docs/ROADMAP.md
docs/ARCHITECTURE.md
```

### STEP 3: PARSE PROJECT STATUS

Read `$ARGUMENTS/PROJECT_STATUS.md` and extract:
- Current phase statuses (NOT_STARTED, IN_PROGRESS, COMPLETE)
- Total phase count
- Defect statuses

### STEP 4: SEND START NOTIFICATION (Optional)

If your project has a notification endpoint configured:
```bash
# Example: curl to your notification service
# curl -s -X POST <YOUR_NOTIFICATION_URL> -H "Content-Type: application/json" -d '{"message": "Project started"}'
```

---

## MAIN EXECUTION LOOP

```
WHILE any phase is NOT_STARTED or IN_PROGRESS:
    1. Find next phase to execute:
       - If any phase is IN_PROGRESS -> continue that phase
       - Else find first NOT_STARTED phase
       - If all COMPLETE -> exit loop

    2. Execute that phase (see PHASE EXECUTION below)

    3. After phase completes:
       - Update $ARGUMENTS/PROJECT_STATUS.md
       - Mark phase as COMPLETE
       - Send notification (if configured)
       - Increment to next phase

    4. CONTINUE TO NEXT ITERATION (DO NOT STOP)
END WHILE
```

---

## PHASE EXECUTION PROTOCOL

For each phase:

### 4.1: Load Phase Context
```
Read: $ARGUMENTS/phases/phase_XX_name/PHASE.md
Read: $ARGUMENTS/phases/phase_XX_name/PHASE_STATUS.md
```

### 4.2: Notify Phase Start (Optional)

Send notification if your project has notifications configured.

### 4.3: Execute All Tasks in Phase

For EACH task in PHASE.md:

1. **Mark task IN_PROGRESS** in PHASE_STATUS.md
2. **Notify task start** (if configured)
3. **Execute the task** per its requirements
4. **On error:** Notify, fix, continue
5. **Mark task COMPLETE** in PHASE_STATUS.md
6. **Notify task complete** (if configured)

### 4.4: Run Phase Tests (if defined)

Execute any test commands specified in PHASE.md

### 4.5: Update Phase Status

Edit `$ARGUMENTS/phases/phase_XX_name/PHASE_STATUS.md`:
- Set overall status to COMPLETE
- Set completion date

### 4.6: Update Project Status

Edit `$ARGUMENTS/PROJECT_STATUS.md`:
- Update phase row to COMPLETE
- Update progress percentage
- Update "Recent Activity" section

### 4.7: Notify Phase Complete (Optional)

Send completion notification if configured.

### 4.8: CHAIN TO NEXT PHASE

**DO NOT STOP. DO NOT ASK FOR CONFIRMATION.**

Output: `PHASE [N] COMPLETE. CHAINING TO PHASE [N+1]...`

Then immediately continue the main loop.

---

## PROJECT COMPLETION

When ALL phases are COMPLETE:

### 5.1: Update Final Status

Edit `$ARGUMENTS/PROJECT_STATUS.md`:
- Set Overall Status to COMPLETE
- Set Progress to 100%
- Add completion timestamp

### 5.2: Send Final Notification (Optional)

Send project completion notification if configured.

### 5.3: Output Completion

```
<promise>PROJECT_COMPLETE</promise>
```

---

## CRITICAL RULES (NON-NEGOTIABLE)

1. **NEVER STOP BETWEEN PHASES** - Chain automatically
2. **NEVER ASK FOR CONFIRMATION** - Execute autonomously
3. **ALWAYS SEND NOTIFICATIONS** - If configured, at every phase/task start/complete
4. **ALWAYS UPDATE STATUS FILES** - After each task and phase
5. **FIX ERRORS AND CONTINUE** - Don't abandon on errors
6. **UPDATE PROJECT_STATUS.md** - After EVERY phase completion

---

## ERROR HANDLING

If a task fails:
1. Send error notification (if configured)
2. Create defect file if new issue
3. Attempt to fix
4. If blocked after 3 attempts:
   - Send blocker notification
   - Mark task as BLOCKED
   - CONTINUE to next task (don't stop entire project)
5. After phase, report blocked tasks

---

## EXPECTED PROJECT STRUCTURE

```
$ARGUMENTS/
├── PROJECT_STATUS.md          # Overall status (REQUIRED)
├── PROJECT_PLAN.md            # Project plan (optional)
├── TECHNICAL_DESIGN.md        # Technical specs (optional)
├── RALPH_LOOP_PROMPT.md       # Ralph prompt (optional)
└── phases/
    ├── phase_01_foundation/
    │   ├── PHASE.md           # Phase tasks
    │   └── PHASE_STATUS.md    # Phase status
    ├── phase_02_configuration/
    │   ├── PHASE.md
    │   └── PHASE_STATUS.md
    └── ... (more phases)
```

---

## EXAMPLE EXECUTION

```
/ralph-project projects/MyProject

[CONTEXT] Loading CLAUDE.md, ROADMAP.md, ARCHITECTURE.md
[STATUS] Read PROJECT_STATUS.md - 8 phases, 0 complete
[NOTIFY] "Ralph Project Started - MyProject, 8 phases"

[PHASE 1] Loading phase_01_foundation/PHASE.md
[NOTIFY] "Phase 1 Started: Foundation"
[TASK 1.1] Started -> Execute -> Complete -> Notify
[TASK 1.2] Started -> Execute -> Complete -> Notify
... (all Phase 1 tasks)
[NOTIFY] "Phase 1 Complete. Chaining to Phase 2..."
[UPDATE] PROJECT_STATUS.md - Phase 1 = COMPLETE

[PHASE 2] Loading phase_02_configuration/PHASE.md
[NOTIFY] "Phase 2 Started: Configuration"
... (all Phase 2 tasks)
[NOTIFY] "Phase 2 Complete. Chaining to Phase 3..."

... (Phases 3-8)

[NOTIFY] "PROJECT COMPLETE - MyProject finished. 8 phases, 90 tasks"
<promise>PROJECT_COMPLETE</promise>
```

---

## BEGIN EXECUTION

Read `$ARGUMENTS/PROJECT_STATUS.md` and begin multi-phase execution NOW.

**DO NOT ASK FOR CONFIRMATION. EXECUTE ALL PHASES AUTONOMOUSLY.**
