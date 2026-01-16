# Claude Skills Factory

A modular skills system for Claude Code that provides reusable commands, external skills, and session hooks.

## Features

- **External Skills** - Prompt-based capabilities that can be enabled/disabled
- **Custom Commands** - Slash commands for project scaffolding and autonomous execution
- **Session Hooks** - Automatic context loading at session start
- **Skills Manager** - `/skill` command to manage external skills

## Quick Install

### Windows (PowerShell)

```powershell
# Clone the repository
git clone git@github.com:chrislabrado/skills-factory-v1.git

# Run the installer
cd skills-factory-v1
.\install.ps1 -TargetProject "C:\path\to\your\project"
```

### Manual Install

Copy the following to your project's `.claude/` directory:

```
.claude/
├── skills.json                    # Skills registry
├── commands/
│   ├── skill.md                   # /skill manager
│   ├── ralph.md                   # /ralph task loop
│   ├── ralph-project.md           # /ralph-project multi-phase
│   ├── vega-plan.md               # /vega-plan scaffolding
│   └── project.md                 # /project scaffolding
├── external-skills/
│   └── vercel-labs/
│       ├── react-best-practices.md
│       └── web-design-guidelines.md
└── hooks/
    └── load-context.ps1           # Session start hook (customize)
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/skill` | Manage external skills (list, enable, disable, invoke) |
| `/ralph <task-file>` | Execute single task file with notifications |
| `/ralph-project <project-path>` | Execute all phases of a project autonomously |
| `/vega-plan <feature-request>` | Transform feature request into project scaffold |
| `/project <design-doc>` | Create project structure from design document |

## Available Skills

| Skill | Rules | Description |
|-------|-------|-------------|
| `vercel-labs/react-best-practices` | 45 | React/Next.js performance optimization |
| `vercel-labs/web-design-guidelines` | 100+ | UI/UX accessibility audit |

## Configuration

### skills.json

```json
{
  "enabled": ["vercel-labs/react-best-practices"],
  "disabled": ["vercel-labs/web-design-guidelines"],
  "aliases": {
    "react": "vercel-labs/react-best-practices",
    "ux": "vercel-labs/web-design-guidelines"
  }
}
```

### Customization Points

1. **Notification URL** - Update curl commands in ralph.md if using different notification endpoint
2. **Status file path** - Update hook script for your project's status file location
3. **Context files** - Modify hook to load project-specific documentation

## Adding New Skills

1. Create markdown file: `.claude/external-skills/{source}/{skill-name}.md`
2. Include YAML frontmatter:
   ```yaml
   ---
   name: skill-name
   description: What this skill does
   version: 1.0.0
   triggers:
     - keyword1
     - keyword2
   ---
   ```
3. Add to `skills.json` enabled or disabled array

## External Skill Sources

| Source | Repository | Description |
|--------|------------|-------------|
| vercel-labs | [agent-skills](https://github.com/vercel-labs/agent-skills) | Official Vercel engineering skills |
| snarktank | [amp-skills](https://github.com/snarktank/amp-skills) | Amp AI coding agent skills |

## License

MIT
