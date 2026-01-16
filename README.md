# Claude Skills Factory

```
   _____ _    _ _ _       ______         _
  / ____| |  (_) | |     |  ____|       | |
 | (___ | | ___| | |___  | |__ __ _  ___| |_ ___  _ __ _   _
  \___ \| |/ / | | / __| |  __/ _` |/ __| __/ _ \| '__| | | |
  ____) |   <| | | \__ \ | | | (_| | (__| || (_) | |  | |_| |
 |_____/|_|\_\_|_|_|___/ |_|  \__,_|\___|\__\___/|_|   \__, |
                                                        __/ |
    For Claude Code                                    |___/
```

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blueviolet)](https://claude.ai)
[![Skills](https://img.shields.io/badge/Skills-2-green)](./external-skills)
[![Commands](https://img.shields.io/badge/Commands-5-blue)](./commands)

A modular skills system for [Claude Code](https://claude.ai/code) that supercharges your AI assistant with reusable commands, curated skills, and automatic context loading.

---

## What is This?

Claude Skills Factory extends Claude Code with:

```
┌─────────────────────────────────────────────────────────────────┐
│                      SKILLS FACTORY                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│   │   COMMANDS   │  │    SKILLS    │  │    HOOKS     │         │
│   │              │  │              │  │              │         │
│   │  /skill      │  │  React Best  │  │  Auto-load   │         │
│   │  /ralph      │  │  Practices   │  │  context at  │         │
│   │  /project    │  │              │  │  session     │         │
│   │  /vega-plan  │  │  Web Design  │  │  start       │         │
│   │              │  │  Guidelines  │  │              │         │
│   └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
│   ┌────────────────────────────────────────────────────┐        │
│   │              YOUR CLAUDE CODE SESSION               │        │
│   │                                                     │        │
│   │  > /skill invoke react                             │        │
│   │  Loading 45 React optimization rules...            │        │
│   │                                                     │        │
│   │  > /ralph-project ./my-feature                     │        │
│   │  Executing 5 phases autonomously...                │        │
│   │                                                     │        │
│   └────────────────────────────────────────────────────┘        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Features at a Glance

| Feature | What It Does |
|---------|--------------|
| **External Skills** | Load curated prompt libraries (React optimization, UI/UX auditing) on demand |
| **Custom Commands** | Slash commands for project scaffolding and autonomous task execution |
| **Session Hooks** | Auto-load project context when Claude Code starts |
| **Skills Manager** | Enable, disable, and invoke skills with `/skill` |

---

## Quick Start

### Option 1: PowerShell Installer (Recommended)

```powershell
# Clone the repository
git clone https://github.com/chrislabrado/skills-factory-v1.git

# Run the installer
cd skills-factory-v1
.\install.ps1 -TargetProject "C:\path\to\your\project"
```

### Option 2: Manual Installation

Copy the contents to your project's `.claude/` directory:

```
your-project/
└── .claude/
    ├── skills.json                              # Skills registry
    ├── commands/
    │   ├── skill.md                             # /skill manager
    │   ├── ralph.md                             # /ralph task loop
    │   ├── ralph-project.md                     # /ralph-project multi-phase
    │   ├── vega-plan.md                         # /vega-plan scaffolding
    │   └── project.md                           # /project scaffolding
    ├── external-skills/
    │   └── vercel-labs/
    │       ├── react-best-practices.md          # 45 React/Next.js rules
    │       └── web-design-guidelines.md         # 100+ UI/UX rules
    └── hooks/
        └── load-context.ps1                     # Session start hook
```

---

## Available Commands

### `/skill` - Skills Manager

Manage your external skills library.

```
/skill                    # List all skills and their status
/skill list               # Same as above
/skill enable react       # Enable a skill (supports aliases)
/skill disable ux         # Disable a skill
/skill info react         # Show skill details
/skill invoke react       # Load skill into current context
```

**Example Output:**
```
## External Skills Registry

### Enabled Skills
| Skill | Description |
|-------|-------------|
| vercel-labs/react-best-practices | React/Next.js optimization (45 rules) |

### Disabled Skills
| Skill | Description |
|-------|-------------|
| vercel-labs/web-design-guidelines | UI/UX audit (100+ rules) |

### Aliases
| Alias | Maps To |
|-------|---------|
| react | vercel-labs/react-best-practices |
| ux    | vercel-labs/web-design-guidelines |
```

---

### `/ralph` - Task Loop Executor

Execute a single task file autonomously with status tracking.

```
/ralph ./phase1/tasks.md
```

**What it does:**
1. Reads task file and extracts task list
2. Loads project context (CLAUDE.md, architecture docs)
3. Executes each task sequentially
4. Updates status tracker after each task
5. Sends notifications (if configured)
6. Outputs completion promise when done

---

### `/ralph-project` - Multi-Phase Executor

Execute ALL phases of a project back-to-back without stopping.

```
/ralph-project ./projects/MyFeature
```

**Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│                    RALPH PROJECT FLOW                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐  │
│  │ Phase 1 │───▶│ Phase 2 │───▶│ Phase 3 │───▶│ Phase N │  │
│  │         │    │         │    │         │    │         │  │
│  │ 8 tasks │    │ 10 tasks│    │ 6 tasks │    │ 5 tasks │  │
│  └─────────┘    └─────────┘    └─────────┘    └─────────┘  │
│       │              │              │              │        │
│       ▼              ▼              ▼              ▼        │
│  [COMPLETE]    [COMPLETE]    [COMPLETE]    [COMPLETE]      │
│                                                              │
│  ════════════════════════════════════════════════════════   │
│                                                              │
│  Output: <promise>PROJECT_COMPLETE</promise>                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

### `/vega-plan` - Feature to Project Scaffold

Transform a feature request document into a complete project structure.

```
/vega-plan ./FEATURE_REQUEST_new_dashboard.md
```

**Input:** A markdown file describing what you want to build

**Output:** Complete project structure ready for `/ralph-project`

```
projects/NewDashboard_v1/
├── PROJECT_STATUS.md
├── PROJECT_PLAN.md
├── FEATURE_REQUEST.md
├── CLAUDE_INSTRUCTIONS.md
├── RALPH_LOOP_PROMPT.md
└── phases/
    ├── phase_01_foundation/
    │   ├── PHASE.md (8 tasks)
    │   └── PHASE_STATUS.md
    ├── phase_02_implementation/
    │   ├── PHASE.md (10 tasks)
    │   └── PHASE_STATUS.md
    └── phase_03_polish/
        ├── PHASE.md (6 tasks)
        └── PHASE_STATUS.md
```

---

### `/project` - Design Doc to Project

Lower-level project scaffolding from a technical design document.

```
/project ./designs/api-redesign.md
```

---

## Available Skills

### React Best Practices
**Source:** [Vercel Labs](https://github.com/vercel-labs/agent-skills)

45 rules across 8 categories for React/Next.js optimization:

| Category | Impact | Rules |
|----------|--------|-------|
| Eliminating Waterfalls | CRITICAL | 5 |
| Bundle Size Optimization | CRITICAL | 4 |
| Server-Side Performance | HIGH | 5 |
| Client-Side Data Fetching | MEDIUM-HIGH | 1 |
| Re-render Optimization | MEDIUM | 4 |
| Rendering Performance | MEDIUM | 3 |
| JavaScript Performance | LOW-MEDIUM | 4 |
| Advanced Patterns | LOW | 1 |

**Usage:**
```
/skill invoke react
```

---

### Web Design Guidelines
**Source:** [Vercel Labs](https://github.com/vercel-labs/agent-skills)

100+ rules for UI/UX auditing across 13 categories:

| Category | Rules |
|----------|-------|
| Accessibility | 9 |
| Focus States | 5 |
| Forms | 6 |
| Animation | 5 |
| Typography | 5 |
| Content Handling | 5 |
| Images | 5 |
| Performance | 6 |
| Navigation & State | 5 |
| Touch & Interaction | 5 |
| Dark Mode & Theming | 5 |
| Locale & i18n | 5 |
| Hydration Safety | 4 |

**Usage:**
```
/skill invoke ux
```

---

## Configuration

### skills.json

Central registry for managing skills:

```json
{
  "enabled": [
    "vercel-labs/react-best-practices",
    "vercel-labs/web-design-guidelines"
  ],
  "disabled": [],
  "aliases": {
    "react": "vercel-labs/react-best-practices",
    "nextjs": "vercel-labs/react-best-practices",
    "ux": "vercel-labs/web-design-guidelines",
    "ui-audit": "vercel-labs/web-design-guidelines",
    "accessibility": "vercel-labs/web-design-guidelines"
  }
}
```

### Session Hooks

The `hooks/load-context.ps1` script runs when Claude Code starts, automatically loading your project context:

```
=== SESSION SUMMARY ===
GREETING: Good morning! Ready to build something great.
LOADED_FILES: STATUS.md, ROADMAP.md, ARCHITECTURE.md
ACTIVE_PROJECT: MyProject
PROJECT_STATUS: Phase 2 in progress
CONTEXT_LEVEL: standard
READY: true
=== END SESSION SUMMARY ===
```

**Customize** the hook to load your project's specific files.

---

## Adding Your Own Skills

1. **Create the skill file:**
   ```
   .claude/external-skills/my-org/my-skill.md
   ```

2. **Add YAML frontmatter:**
   ```yaml
   ---
   name: my-skill
   description: What this skill does
   version: 1.0.0
   author: your-name
   triggers:
     - keyword1
     - keyword2
   ---

   # My Skill

   [Your skill content here - rules, guidelines, examples]
   ```

3. **Register in skills.json:**
   ```json
   {
     "enabled": ["my-org/my-skill"],
     "aliases": {
       "myskill": "my-org/my-skill"
     }
   }
   ```

4. **Use it:**
   ```
   /skill invoke myskill
   ```

---

## Project Structure

```
skills-factory-v1/
│
├── README.md                 # You are here
├── install.ps1               # PowerShell installer
├── skills.json               # Skills registry
│
├── commands/                 # Slash commands
│   ├── skill.md              # /skill - manage skills
│   ├── ralph.md              # /ralph - single task loop
│   ├── ralph-project.md      # /ralph-project - multi-phase
│   ├── vega-plan.md          # /vega-plan - feature scaffolding
│   └── project.md            # /project - design scaffolding
│
├── external-skills/          # Curated skill libraries
│   └── vercel-labs/
│       ├── react-best-practices.md
│       └── web-design-guidelines.md
│
├── hooks/                    # Session hooks
│   └── load-context.ps1      # Auto-load context
│
└── templates/                # Reference templates
    ├── ralph-loop-template.md
    └── settings.json.template
```

---

## Workflow Example

Here's a complete workflow using Skills Factory:

```
1. Write a feature request document
   └── FEATURE_REQUEST_user_dashboard.md

2. Scaffold the project
   └── /vega-plan FEATURE_REQUEST_user_dashboard.md

3. Load relevant skills
   └── /skill invoke react

4. Execute autonomously
   └── /ralph-project projects/UserDashboard_v1

5. Watch Claude build your feature phase by phase
   └── Phase 1: Foundation ✓
   └── Phase 2: Core UI ✓
   └── Phase 3: Data Integration ✓
   └── Phase 4: Polish & Testing ✓

6. Done!
   └── <promise>PROJECT_COMPLETE</promise>
```

---

## External Skill Sources

Looking for more skills? Check these repositories:

| Source | Repository | Description |
|--------|------------|-------------|
| Vercel Labs | [agent-skills](https://github.com/vercel-labs/agent-skills) | Official Vercel engineering skills |
| SnarktanK | [amp-skills](https://github.com/snarktank/amp-skills) | Amp AI coding agent skills |

---

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- PowerShell 5.1+ (for Windows installer and hooks)
- Git (for cloning)

---

## Contributing

Contributions welcome! Feel free to:

- Add new skills to `external-skills/`
- Create new commands in `commands/`
- Improve documentation
- Report issues

---

## Acknowledgements

This project includes content adapted from the following sources. Full credit and thanks to the original authors:

### External Skills

| Skill | Original Source | Authors |
|-------|-----------------|---------|
| React Best Practices | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | [Vercel](https://vercel.com) Engineering Team |
| Web Design Guidelines | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | [Vercel](https://vercel.com) Engineering Team |

### Inspiration & Patterns

| Concept | Source | Description |
|---------|--------|-------------|
| Ralph Loops | [snarktank/amp-skills](https://github.com/snarktank/amp-skills) | Autonomous task execution patterns |
| Skill Architecture | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | YAML frontmatter skill format |

### Special Thanks

- **[Vercel Labs](https://github.com/vercel-labs)** - For open-sourcing their comprehensive React and Web Design guidelines that form the foundation of the included skills
- **[SnarktanK](https://github.com/snarktank)** - For pioneering the "Ralph Loop" autonomous execution pattern for AI coding agents
- **[Anthropic](https://anthropic.com)** - For Claude and Claude Code

---

## License

MIT License - See [LICENSE](LICENSE) for details.

The external skills included in this repository are derived from open source projects. Please refer to the original repositories for their specific licensing terms.

---

<p align="center">
  <i>Built with Claude Code</i><br>
  <i>Standing on the shoulders of giants</i>
</p>
