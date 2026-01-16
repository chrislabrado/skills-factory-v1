---
description: Manage external skills - list, enable, disable, or invoke skills from the external-skills library
argument-hint: <command> [skill-name]
---

# Skill Manager

Manage external skills library. Skills are optional prompt-based capabilities that can be enabled or disabled without changing core functionality.

## Usage

```
/skill                           # List all skills and their status
/skill list                      # Same as above
/skill enable <skill-name>       # Enable a skill
/skill disable <skill-name>      # Disable a skill
/skill info <skill-name>         # Show skill details
/skill invoke <skill-name>       # Load and apply a skill to current context
```

## Arguments

- `$ARGUMENTS` - Command and optional skill name

---

## EXECUTION PROTOCOL

### Parse Arguments

```
COMMAND = first word of $ARGUMENTS (list|enable|disable|info|invoke)
SKILL_NAME = remaining arguments (supports aliases)
```

If `$ARGUMENTS` is empty or just whitespace, default to `list`.

---

### Command: LIST (default)

Read `.claude/skills.json` and `.claude/external-skills/` directory.

**Output format:**

```markdown
## External Skills Registry

### Enabled Skills
| Skill | Description | Source |
|-------|-------------|--------|
| vercel-labs/react-best-practices | React/Next.js optimization (45 rules) | vercel-labs |
| vercel-labs/web-design-guidelines | UI/UX audit (100+ rules) | vercel-labs |

### Disabled Skills
| Skill | Description | Source |
|-------|-------------|--------|
| (none) | | |

### Aliases
| Alias | Maps To |
|-------|---------|
| react | vercel-labs/react-best-practices |
| nextjs | vercel-labs/react-best-practices |
| ux | vercel-labs/web-design-guidelines |

### Quick Commands
- Enable: `/skill enable <name>`
- Disable: `/skill disable <name>`
- Use: `/skill invoke <name>` or `/skill invoke <alias>`
```

---

### Command: ENABLE

1. Read `.claude/skills.json`
2. Resolve alias if provided (check `aliases` object)
3. Move skill from `disabled` to `enabled` array
4. Write updated `.claude/skills.json`
5. Confirm change

**Output:**

```
Enabled skill: vercel-labs/react-best-practices

The skill is now available. Use `/skill invoke react-best-practices` to apply it.
```

**Error if skill not found:**

```
Skill not found: unknown-skill

Available skills:
- vercel-labs/react-best-practices (alias: react, nextjs)
- vercel-labs/web-design-guidelines (alias: ux, ui-audit, accessibility)
```

---

### Command: DISABLE

1. Read `.claude/skills.json`
2. Resolve alias if provided
3. Move skill from `enabled` to `disabled` array
4. Write updated `.claude/skills.json`
5. Confirm change

**Output:**

```
Disabled skill: vercel-labs/react-best-practices

The skill will no longer be suggested. Re-enable with `/skill enable react-best-practices`
```

---

### Command: INFO

1. Resolve skill name/alias
2. Read the skill markdown file from `.claude/external-skills/{source}/{skill}.md`
3. Parse YAML frontmatter
4. Display skill information

**Output:**

```markdown
## Skill: vercel-labs/react-best-practices

| Field | Value |
|-------|-------|
| Name | vercel-react-best-practices |
| Version | 1.0.0 |
| Author | vercel |
| Status | Enabled |
| Source | https://github.com/vercel-labs/agent-skills |

### Description
React and Next.js performance optimization guidelines from Vercel Engineering.

### Triggers
Use when working on: components, pages, data fetching, bundle optimization, performance work

### Aliases
- react
- nextjs

### Content Preview
Contains 45 rules across 8 categories:
1. Eliminating Waterfalls (CRITICAL)
2. Bundle Size Optimization (CRITICAL)
3. Server-Side Performance (HIGH)
4. Client-Side Data Fetching (MEDIUM-HIGH)
5. Re-render Optimization (MEDIUM)
6. Rendering Performance (MEDIUM)
7. JavaScript Performance (LOW-MEDIUM)
8. Advanced Patterns (LOW)
```

---

### Command: INVOKE

1. Check if skill is enabled in `.claude/skills.json`
2. If disabled, ask user to enable first
3. Read full skill content from `.claude/external-skills/{source}/{skill}.md`
4. Output the skill content to load it into context

**Output:**

```markdown
## Loading Skill: vercel-labs/react-best-practices

[Full skill content is output here, loading all rules into context]

---

Skill loaded. I will now apply these guidelines to your React/Next.js code.

What would you like me to review or optimize?
```

**If skill is disabled:**

```
Skill is disabled: vercel-labs/react-best-practices

Enable it first with: `/skill enable react-best-practices`

Or invoke anyway with: `/skill invoke react-best-practices --force`
```

---

## File Locations

```
.claude/
├── skills.json                          # Registry (enabled/disabled/aliases)
├── commands/
│   └── skill.md                         # This file
└── external-skills/
    ├── vercel-labs/
    │   ├── react-best-practices.md      # React optimization skill
    │   └── web-design-guidelines.md     # UI/UX audit skill
    └── snarktank/
        └── (future skills)
```

---

## Adding New Skills

To add a new external skill:

1. Create markdown file in `.claude/external-skills/{source}/{skill-name}.md`
2. Include YAML frontmatter with: name, description, version, triggers
3. Add to `enabled` or `disabled` array in `.claude/skills.json`
4. Optionally add aliases in `.claude/skills.json`

**Skill file format:**

```markdown
---
name: skill-name
description: What this skill does
version: 1.0.0
author: author-name
source: https://github.com/...
triggers:
  - keyword1
  - keyword2
---

# Skill Title

[Skill instructions and rules here]
```

---

## BEGIN EXECUTION

Parse `$ARGUMENTS` and execute the appropriate command.

If no arguments provided, execute LIST command.
