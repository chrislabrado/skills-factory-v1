# Context Loader - SessionStart Hook Template
# Automatically injects standard context at Claude Code session start
#
# CUSTOMIZE THIS FILE for your project's needs

$projectDir = $env:CLAUDE_PROJECT_DIR
if (-not $projectDir) {
    $projectDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
}

# Track what we load
$loadedFiles = @()
$failedFiles = @()

# Determine time-based greeting
$hour = (Get-Date).Hour
if ($hour -lt 12) {
    $timeGreeting = "Good morning"
} elseif ($hour -lt 17) {
    $timeGreeting = "Good afternoon"
} else {
    $timeGreeting = "Good evening"
}

# Select a greeting (customize these for your project)
$greetings = @(
    "$timeGreeting! Ready to build something great.",
    "$timeGreeting! Let's get to work.",
    "$timeGreeting! What are we tackling today?",
    "$timeGreeting! I'm all set and ready to help.",
    "$timeGreeting! What's on the agenda?"
)
$greeting = $greetings | Get-Random

Write-Output "=== STANDARD CONTEXT LOADED ==="
Write-Output ""

# Load STATUS file (customize path for your project)
$statusFile = Join-Path $projectDir "docs\STATUS.md"
if (Test-Path $statusFile) {
    Write-Output "--- docs/STATUS.md ---"
    $statusContent = Get-Content $statusFile -Raw
    Write-Output $statusContent
    Write-Output ""
    $loadedFiles += "STATUS.md"

    # Extract key info from status (customize patterns for your format)
    $currentProject = ""
    $currentStatus = ""

    if ($statusContent -match "ACTIVE PROJECT:\s*(\S+)") {
        $currentProject = $Matches[1]
    }
    if ($statusContent -match "\*\*Status:\*\*\s*(.+?)(?:\r?\n|$)") {
        $currentStatus = $Matches[1].Trim()
    }
} else {
    $failedFiles += "STATUS.md"
}

# Load ROADMAP file (customize path for your project)
$roadmapFile = Join-Path $projectDir "docs\ROADMAP.md"
if (Test-Path $roadmapFile) {
    Write-Output "--- docs/ROADMAP.md ---"
    Get-Content $roadmapFile -Raw
    Write-Output ""
    $loadedFiles += "ROADMAP.md"
} else {
    $failedFiles += "ROADMAP.md"
}

# Load ARCHITECTURE file (customize path for your project)
$archFile = Join-Path $projectDir "docs\ARCHITECTURE.md"
if (Test-Path $archFile) {
    Write-Output "--- docs/ARCHITECTURE.md ---"
    Get-Content $archFile -Raw
    Write-Output ""
    $loadedFiles += "ARCHITECTURE.md"
} else {
    $failedFiles += "ARCHITECTURE.md"
}

Write-Output "=== END CONTEXT ==="
Write-Output ""

# Output structured summary for Claude to parse and respond to
Write-Output "=== SESSION SUMMARY ==="
Write-Output "GREETING: $greeting"
Write-Output "LOADED_FILES: $($loadedFiles -join ', ')"
if ($failedFiles.Count -gt 0) {
    Write-Output "FAILED_FILES: $($failedFiles -join ', ')"
}
if ($currentProject) {
    Write-Output "ACTIVE_PROJECT: $currentProject"
}
if ($currentStatus) {
    Write-Output "PROJECT_STATUS: $currentStatus"
}
Write-Output "CONTEXT_LEVEL: standard"
Write-Output "READY: true"
Write-Output "=== END SESSION SUMMARY ==="

exit 0
