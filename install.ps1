# Claude Skills Factory Installer
# Installs skills, commands, hooks, and templates to a target project

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetProject,

    [switch]$SkipHooks,
    [switch]$SkipSkills,
    [switch]$SkipCommands,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Resolve paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetProject = Resolve-Path $TargetProject -ErrorAction SilentlyContinue
if (-not $TargetProject) {
    Write-Error "Target project directory does not exist: $TargetProject"
    exit 1
}

$TargetClaude = Join-Path $TargetProject ".claude"

Write-Host "=== Claude Skills Factory Installer ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Source: $ScriptDir"
Write-Host "Target: $TargetProject"
Write-Host ""

# Create .claude directory if it doesn't exist
if (-not (Test-Path $TargetClaude)) {
    Write-Host "Creating .claude directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $TargetClaude | Out-Null
}

# Function to copy with backup
function Copy-WithBackup {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Force
    )

    if (Test-Path $Destination) {
        if (-not $Force) {
            Write-Host "  Skipping (exists): $Destination" -ForegroundColor DarkGray
            return $false
        }
        $backup = "$Destination.bak"
        Write-Host "  Backing up: $Destination -> $backup" -ForegroundColor DarkYellow
        Copy-Item $Destination $backup -Force
    }

    Copy-Item $Source $Destination -Force
    Write-Host "  Installed: $Destination" -ForegroundColor Green
    return $true
}

# Install skills.json
Write-Host ""
Write-Host "Installing skills registry..." -ForegroundColor Cyan
$skillsJson = Join-Path $ScriptDir "skills.json"
$targetSkillsJson = Join-Path $TargetClaude "skills.json"
Copy-WithBackup -Source $skillsJson -Destination $targetSkillsJson -Force:$Force

# Install commands
if (-not $SkipCommands) {
    Write-Host ""
    Write-Host "Installing commands..." -ForegroundColor Cyan

    $targetCommands = Join-Path $TargetClaude "commands"
    if (-not (Test-Path $targetCommands)) {
        New-Item -ItemType Directory -Path $targetCommands | Out-Null
    }

    $sourceCommands = Join-Path $ScriptDir "commands"
    Get-ChildItem -Path $sourceCommands -Filter "*.md" | ForEach-Object {
        $dest = Join-Path $targetCommands $_.Name
        Copy-WithBackup -Source $_.FullName -Destination $dest -Force:$Force
    }
}

# Install external skills
if (-not $SkipSkills) {
    Write-Host ""
    Write-Host "Installing external skills..." -ForegroundColor Cyan

    $targetSkills = Join-Path $TargetClaude "external-skills"
    if (-not (Test-Path $targetSkills)) {
        New-Item -ItemType Directory -Path $targetSkills | Out-Null
    }

    $sourceSkills = Join-Path $ScriptDir "external-skills"
    if (Test-Path $sourceSkills) {
        # Copy skill directories
        Get-ChildItem -Path $sourceSkills -Directory | ForEach-Object {
            $targetSkillDir = Join-Path $targetSkills $_.Name
            if (-not (Test-Path $targetSkillDir)) {
                New-Item -ItemType Directory -Path $targetSkillDir | Out-Null
            }

            Get-ChildItem -Path $_.FullName -Filter "*.md" | ForEach-Object {
                $dest = Join-Path $targetSkillDir $_.Name
                Copy-WithBackup -Source $_.FullName -Destination $dest -Force:$Force
            }
        }
    }
}

# Install hooks
if (-not $SkipHooks) {
    Write-Host ""
    Write-Host "Installing hooks..." -ForegroundColor Cyan

    $targetHooks = Join-Path $TargetClaude "hooks"
    if (-not (Test-Path $targetHooks)) {
        New-Item -ItemType Directory -Path $targetHooks | Out-Null
    }

    $sourceHooks = Join-Path $ScriptDir "hooks"
    if (Test-Path $sourceHooks) {
        Get-ChildItem -Path $sourceHooks -Filter "*.ps1" | ForEach-Object {
            $dest = Join-Path $targetHooks $_.Name
            Copy-WithBackup -Source $_.FullName -Destination $dest -Force:$Force
        }
    }
}

# Copy templates for reference
Write-Host ""
Write-Host "Installing templates..." -ForegroundColor Cyan

$targetTemplates = Join-Path $TargetClaude "templates"
if (-not (Test-Path $targetTemplates)) {
    New-Item -ItemType Directory -Path $targetTemplates | Out-Null
}

$sourceTemplates = Join-Path $ScriptDir "templates"
if (Test-Path $sourceTemplates) {
    Get-ChildItem -Path $sourceTemplates | ForEach-Object {
        $dest = Join-Path $targetTemplates $_.Name
        Copy-WithBackup -Source $_.FullName -Destination $dest -Force:$Force
    }
}

# Summary
Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Installed to: $TargetClaude" -ForegroundColor Cyan
Write-Host ""
Write-Host "Structure created:" -ForegroundColor Yellow
Write-Host "  .claude/"
Write-Host "  ├── skills.json"
Write-Host "  ├── commands/"
Write-Host "  │   ├── skill.md"
Write-Host "  │   ├── ralph.md"
Write-Host "  │   ├── ralph-project.md"
Write-Host "  │   ├── vega-plan.md"
Write-Host "  │   └── project.md"
Write-Host "  ├── external-skills/"
Write-Host "  │   └── vercel-labs/"
Write-Host "  │       ├── react-best-practices.md"
Write-Host "  │       └── web-design-guidelines.md"
Write-Host "  ├── hooks/"
Write-Host "  │   └── load-context.ps1"
Write-Host "  └── templates/"
Write-Host "      ├── ralph-loop-template.md"
Write-Host "      └── settings.json.template"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review and customize hooks/load-context.ps1 for your project"
Write-Host "  2. Update settings.json with hook configuration (see templates/settings.json.template)"
Write-Host "  3. Test commands: /skill list, /ralph, /project"
Write-Host ""
