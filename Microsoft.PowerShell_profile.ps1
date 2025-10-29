# ====================================================================
# PowerShell Profile - Windows Development Environment
# ====================================================================
# This profile replicates the Linux/macOS bashrc configuration for Windows
# Symlink this file to: $PROFILE
# Command: New-Item -ItemType SymbolicLink -Path $PROFILE -Target "C:\Users\uliano\dotfiles\Microsoft.PowerShell_profile.ps1"

# ====================================================================
# ENCODING AND LOCALE
# ====================================================================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$env:LANG = "en_US.UTF-8"
$env:LC_ALL = "en_US.UTF-8"

# ====================================================================
# PSREADLINE CONFIGURATION (Enhanced History)
# ====================================================================
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine

    # History settings (similar to bash HISTCONTROL)
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -MaximumHistoryCount 10000

    # Prediction and completion (only if in interactive shell with VT support)
    try {
        Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction SilentlyContinue
    } catch {
        # Silently ignore if VT not supported (e.g., when run from non-interactive shell)
    }

    # Emacs-like key bindings
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# Add PlatformIO CLI tool path if it exists
# needs to stay above pyenv configuration
$platformioPath = "$env:USERPROFILE\.platformio\penv\Scripts"
if ((Test-Path $platformioPath) -and ($env:PATH -notlike "*$platformioPath*")) {
    $env:PATH = "$platformioPath;$env:PATH"
}

# ====================================================================
# PYENV-WIN CONFIGURATION
# ====================================================================
$env:PYENV = "$env:USERPROFILE\.pyenv\pyenv-win"
$env:PYENV_ROOT = "$env:USERPROFILE\.pyenv\pyenv-win"
$env:PYENV_HOME = "$env:USERPROFILE\.pyenv\pyenv-win"

# Add pyenv to PATH if not already present
if (Test-Path "$env:PYENV\bin") {
    $env:PATH = "$env:PYENV\bin;$env:PYENV\shims;$env:PATH"
}

# ====================================================================
# NVM-WINDOWS CONFIGURATION
# ====================================================================
# NVM for Windows sets its own environment variables during installation
# Verify it's available
$env:NVM_HOME = "$env:APPDATA\nvm"
$env:NVM_SYMLINK = "$env:ProgramFiles\nodejs"

# ====================================================================
# PATH CONFIGURATION
# ====================================================================
# Add WinGet Links path (where winget installs CLI tools)
$wingetLinks = "$env:LOCALAPPDATA\Microsoft\WinGet\Links"
if ((Test-Path $wingetLinks) -and ($env:PATH -notlike "*$wingetLinks*")) {
    $env:PATH = "$wingetLinks;$env:PATH"
}

# Add common paths (if they exist)
$pathsToAdd = @(
    "$env:USERPROFILE\bin",
    "$env:USERPROFILE\.local\bin",
    "$env:USERPROFILE\.cargo\bin"
)

foreach ($path in $pathsToAdd) {
    if ((Test-Path $path) -and ($env:PATH -notlike "*$path*")) {
        $env:PATH = "$path;$env:PATH"
    }
}

# ====================================================================
# ALIASES - Modern CLI Tools
# ====================================================================
# Remove built-in PowerShell aliases that conflict with modern tools
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Remove-Item Alias:cat -Force -ErrorAction SilentlyContinue

# eza - Modern replacement for ls
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ls { eza $args }
    function ll { eza -la $args }
    function lr { eza -lo --sort=modified $args }
    function lrg { eza -lag --sort=modified $args }
    function la { eza -A $args }
    function l { eza $args }
}

# fd - Modern replacement for find
if (Get-Command fd -ErrorAction SilentlyContinue) {
    function find { fd $args }
}

# bat - Cat with syntax highlighting
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat -p $args }  # Plain style, no decorations (easy to copy)
    # bat command stays as-is for full decorated view
}

# ripgrep - Fast grep
if (Get-Command rg -ErrorAction SilentlyContinue) {
    function grep { rg $args }
}

# ====================================================================
# CUSTOM ALIASES
# ====================================================================
# History alias (like bash 'hist')
function hist { Get-History }

# Common navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

# Quick edit profile
function Edit-Profile { code $PROFILE }
Set-Alias -Name ep -Value Edit-Profile

# Reload profile
function Reload-Profile {
    . $PROFILE
    Write-Host "PowerShell profile reloaded!" -ForegroundColor Green
}
Set-Alias -Name reload -Value Reload-Profile

# ====================================================================
# UTILITY FUNCTIONS
# ====================================================================
# Get public IP
function Get-PublicIP {
    (Invoke-WebRequest -Uri "https://api.ipify.org").Content
}
Set-Alias -Name myip -Value Get-PublicIP

# Quick directory listing with details
function Get-DirectorySize {
    Get-ChildItem |
    Measure-Object -Property Length -Sum |
    Select-Object @{Name="Size(MB)"; Expression={[math]::Round($_.Sum / 1MB, 2)}}
}
Set-Alias -Name dirsize -Value Get-DirectorySize

# ====================================================================
# WINDOWS-SPECIFIC CONFIGURATIONS
# ====================================================================
# Admin check function
function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Prompt indicator for admin shells (before Starship)
if (Test-Administrator) {
    $host.UI.RawUI.WindowTitle = "PowerShell (Administrator)"
}

# ====================================================================
# LINUX/MAC COMPATIBILITY ALIASES (Optional)
# ====================================================================
# Uncomment these if you want Linux-like commands
# function touch { New-Item -ItemType File -Name $args }
# function which { Get-Command $args | Select-Object -ExpandProperty Source }
# function export($name, $value) { Set-Item -Path "env:$name" -Value $value }

# ====================================================================
# CUSTOM TOOLS (Platform Specific)
# ====================================================================
# OpenOCD STM (if you install it on Windows)
# Set-Alias -Name openocd_stm -Value "C:\path\to\openocd_stm\bin\openocd.exe"

# ====================================================================
# PROMPT INITIALIZATION (STARSHIP)
# ====================================================================
# Initialize Starship prompt - MUST BE LAST
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
