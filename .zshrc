# ====================================================================
# Cross-Platform ZSH Configuration
# Compatible with macOS and Linux
# ====================================================================

# ====================================================================
# HISTORY CONFIGURATION
# ====================================================================
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

# History options
setopt share_history
setopt append_history
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_ignore_space        # Don't record commands starting with space

alias hist='history 1'

# ====================================================================
# ZSH OPTIONS
# ====================================================================
setopt no_case_glob            # Case insensitive globbing
setopt auto_cd                 # cd without typing cd
setopt correct                 # Spell correction for commands (commented in original)
# setopt correct_all           # Spell correction for arguments (can be annoying)

# ====================================================================
# COMPLETION SYSTEM
# ====================================================================
# Initialize completion system once
autoload -Uz compinit
# Check if compinit needs to run (performance optimization)
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Better completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ====================================================================
# COLORS AND ALIASES
# ====================================================================
autoload -U colors && colors

# OS Detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    export OS_TYPE="macos"
    # Default ls aliases (will be overridden by modern tools if available)
    alias ls="ls -G"
    alias lr="ls -ltrGh"
    # Add macOS specific PATH entries
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [[ "$OSTYPE" == "linux"* ]]; then
    # Linux
    export OS_TYPE="linux"
    # Default ls aliases (will be overridden by modern tools if available)
    alias ls="ls --color=auto"
    alias lr="ls -ltrh --color=auto"
fi

# Common aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Modern alternatives (install with package manager)
if command -v eza >/dev/null; then
    alias ls='eza'
    alias ll='eza -la'
    alias lr='eza -lo --sort=modified'        # without group
    alias lrg='eza -lag --sort=modified'      # with group (-g flag)
fi

command -v bat >/dev/null && alias cat='bat'
command -v batcat >/dev/null && alias bat='batcat' && alias cat='batcat'  # Ubuntu package name
command -v fd >/dev/null && alias find='fd'
command -v fdfind >/dev/null && alias fd='fdfind'  # Ubuntu package name

# ====================================================================
# PATH CONFIGURATION
# ====================================================================
# Common paths
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Conditionally add neovim if exists
[[ -d "$HOME/neovim/bin" ]] && export PATH="$HOME/neovim/bin:$PATH"

# ====================================================================
# LOCALE
# ====================================================================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ====================================================================
# PLATFORM SPECIFIC CONFIGURATIONS
# ====================================================================
if [[ "$OS_TYPE" == "macos" ]]; then
    # ================== macOS SPECIFIC ==================

    # Homebrew
    if command -v brew >/dev/null; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Homebrew completions
        FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    fi

    # VS Code
    [[ -d "/Applications/Visual Studio Code.app" ]] && \
        alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

    # VMD (commented - uncomment if needed)
    # export VMD=/Applications/VMD.app
    # alias vmd='$VMD/Contents/Resources/VMD.app/Contents/MacOS/VMD'
    # alias catdcd='$VMD/Contents/vmd/plugins/MACOSXX86_64/bin/catdcd5.2/catdcd'

    # MOE (commented - uncomment if needed)
    # export MOE=/Applications/moe2022/
    # alias moe='$MOE/bin/moe'
    # alias licenze81='$MOE/lm/bin/lmutil lmstat -c $MOE/license.81 -a'
    # alias licenze128='$MOE/lm/bin/lmutil lmstat -c $MOE/license.128 -a'

    # Schrodinger (commented - uncomment if needed)
    # export SCHRODINGER=/opt/schrodinger/suites2025-3/
    # export SCHRODINGER_SCRIPTS=/opt/schrodinger/schrodinger_utils/scripts
    # alias schrun='$SCHRODINGER/run'

    # Python scripts (commented - adjust path as needed)
    # [[ -d "/opt/python_scripts" ]] && export PATH="/opt/python_scripts:$PATH"

elif [[ "$OS_TYPE" == "linux" ]]; then
    # ================== LINUX SPECIFIC ==================

    # VS Code (various installation methods)
    command -v code >/dev/null || {
        [[ -f "/usr/bin/code" ]] && alias code='/usr/bin/code'
        [[ -f "/snap/bin/code" ]] && alias code='/snap/bin/code'
    }

    # Add common Linux paths
    [[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"
    [[ -d "/opt/bin" ]] && export PATH="/opt/bin:$PATH"

    # Linux specific aliases
    alias open='xdg-open'  # macOS-like open command

fi

# ====================================================================
# DEVELOPMENT TOOLS
# ====================================================================

# FZF integration (cross-platform)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Custom functions directory
export FPATH="$HOME/.zfunc:$FPATH"

# ====================================================================
# CONDA/MAMBA INITIALIZATION
# ====================================================================
# This block will be managed by mamba/conda init
# Auto-detect common installation paths
MAMBA_LOCATIONS=(
    "/home/miniforge3/bin/mamba"
)

for location in "${MAMBA_LOCATIONS[@]}"; do
    if [[ -f "$location" ]]; then
        export MAMBA_EXE="$location"
        export MAMBA_ROOT_PREFIX="$(dirname $(dirname $location))"
        break
    fi
done

# Initialize mamba if found
if [[ -n "$MAMBA_EXE" ]]; then
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [[ $? -eq 0 ]]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"
    fi
    unset __mamba_setup
fi

# ====================================================================
# PROMPT INITIALIZATION (STARSHIP)
# ====================================================================
# Initialize starship if available
command -v starship >/dev/null && eval "$(starship init zsh)"

# ====================================================================
# ENVIRONMENT OVERVIEW ON STARTUP
# ====================================================================
# Show available environments when shell starts
show_environments() {
    # Get conda environments (skip header lines)
    local conda_list=$(/home/miniforge3/bin/conda info --envs 2>/dev/null | grep -v '^#' | grep -v '^$' | awk '{print $1}' | tr '\n' ' ')

    # Get venvs
    local venvs_list=$(ls -1 /home/venvs 2>/dev/null | tr '\n' ' ')

    echo "🅒 Conda envs: $conda_list"
    echo "📦 /home/venvs: $venvs_list"
}

# Show environments on new shell (but not on sourcing)
if [[ $SHLVL -eq 1 ]]; then
    show_environments
fi

# ====================================================================
# LOCAL CUSTOMIZATIONS
# ====================================================================
# Source local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

