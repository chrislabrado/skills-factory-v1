---
active: false
iteration: 1
max_iterations: 50
completion_promise: "LOOP_COMPLETE"
started_at: ""
---

# Ralph Loop Template

This template is used for tracking autonomous task execution loops.

## TASK DOCUMENT: [path to task document]
## STATUS TRACKER: [path to status tracker]

## EXECUTION ORDER:
1. Task 1
2. Task 2
...

## PER-TASK PROTOCOL (MANDATORY):

### Step 1: Announce Start

If your project has a notification system configured, announce task start.
Example notification format:
```json
{
  "title": "[TASK_ID] Started",
  "message": "Beginning work on [TASK_NAME]",
  "priority": "normal"
}
```

### Step 2: Execute Task
- Read specs
- Implement
- Run validation (build, tests, etc.)
- Fix any errors

### Step 3: Announce Completion (BEFORE moving to next task)

Notify completion if configured:
```json
{
  "title": "[TASK_ID] Complete",
  "message": "[Brief summary of what was done]",
  "priority": "normal"
}
```

### Step 4: Update Status Tracker
- Mark task COMPLETE in status document

### VERIFICATION CHECKPOINT:
Before proceeding to next task, confirm:
- [ ] Notification sent for task start (if configured)
- [ ] Notification sent for task completion (if configured)
- [ ] Status tracker updated

## ON ERROR:
If any task has compilation/test errors:
1. Notify error (if configured)
2. Fix the error
3. Continue to next task

## COMPLETION:
When ALL criteria met, send final summary and output:
```
<promise>LOOP_COMPLETE</promise>
```
