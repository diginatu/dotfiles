# Windows counterpart of link_linux.sh, limited to the Claude Code / APM part.
# Run: powershell -ExecutionPolicy Bypass -File link_windows.ps1
#
# Symlinks need Developer Mode (or an elevated shell); without it, the
# symlinked files fall back to copies and this script must be re-run after
# editing them.

param(
    [string]$DistDir = $HOME
)

$ErrorActionPreference = 'Stop'
$FromDir = $PSScriptRoot

function Link-File($Source, $Dest) {
    if (Test-Path $Dest) { Remove-Item -Force $Dest }
    try {
        New-Item -ItemType SymbolicLink -Path $Dest -Target $Source | Out-Null
    } catch {
        Write-Warning "Cannot symlink $Dest (enable Developer Mode); copying instead."
        Copy-Item $Source $Dest
    }
}

function Copy-File($Source, $Dest) {
    if (Test-Path $Dest) { Remove-Item -Force $Dest }
    Copy-Item $Source $Dest
}

$ClaudeDir = Join-Path $DistDir '.claude'
$ApmDir = Join-Path $DistDir '.apm'
New-Item -ItemType Directory -Force $ClaudeDir, $ApmDir | Out-Null

# Copied: APM merges package hooks (e.g. superpowers) into it; a symlink would
# let APM write into this repo. The statusline path is hard-coded for Linux,
# so point it at this home directory instead.
$Settings = [IO.File]::ReadAllText((Join-Path $FromDir 'ai\claude\settings.json'))
$ClaudeDirPosix = $ClaudeDir -replace '\\', '/'
$Settings = $Settings -replace '/home/[^/"]+/\.claude/', "$ClaudeDirPosix/"
$SettingsDest = Join-Path $ClaudeDir 'settings.json'
if (Test-Path $SettingsDest) { Remove-Item -Force $SettingsDest }
[IO.File]::WriteAllText($SettingsDest, $Settings, (New-Object Text.UTF8Encoding $false))

Link-File (Join-Path $FromDir 'ai\claude\keybindings.json') (Join-Path $ClaudeDir 'keybindings.json')
Link-File (Join-Path $FromDir 'ai\claude\statusline-command.sh') (Join-Path $ClaudeDir 'statusline-command.sh')

## APM: see link_linux.sh. The manifest must be a real file. No CLAUDE.md
## placeholder: compile -g does not generate ~/.claude/CLAUDE.md here.
Copy-File (Join-Path $FromDir 'ai\apm\global\apm.yml') (Join-Path $ApmDir 'apm.yml')

Write-Output 'Next, run: apm install -g --update; apm compile -g'
