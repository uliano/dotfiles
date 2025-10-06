# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# ====================================================================
# HISTORY CONFIGURATION
# ====================================================================
HISTFILE=~/.bash_history
HISTSIZE=1000000
HISTFILESIZE=1000000

# History options (bash equivalents of zsh settings)
HISTCONTROL=ignoreboth:ignoredups  # ignore duplicates and commands starting with space
shopt -s histverify               # verify history expansion before executing
alias hist='history'              # The whole story!

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ====================================================================
# BASH OPTIONS
# ====================================================================
# Enable globstar for ** pattern matching (equivalent to zsh globbing)
shopt -s globstar
# Case insensitive completion (partial equivalent to zsh no_case_glob)
shopt -s nocaseglob
shopt -s nocasematch
# Auto cd (equivalent to zsh auto_cd)
shopt -s autocd 2>/dev/null || true  # ignore if not supported in older bash

# Case insensitive tab completion
bind "set completion-ignore-case on"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ====================================================================
# ALIASES
# ====================================================================
# Default ls aliases (will be overridden by modern tools if available)
alias ls="ls --color=auto"
alias lr="ls -ltrh --color=auto"
alias open='xdg-open'  # macOS-like open command

# Common aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Tool-specific aliases
source ~/.aliases 2>/dev/null  # Load custom aliases if file exists

# Modern alternatives (install with package manager)
if command -v eza >/dev/null; then
    alias ls='eza'
    alias ll='eza -la'
    alias lr='eza -lo --sort=modified'        # without group
    alias lrg='eza -lag --sort=modified'      # with group (-g flag)
fi
command -v fd >/dev/null && alias find='fd'
command -v fdfind >/dev/null && alias fd='fdfind'  # Ubuntu package name

# ====================================================================
# PATH CONFIGURATION
# ====================================================================
# Common paths
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
[[ -d "/opt/bin" ]] && export PATH="/opt/bin:$PATH"
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Conditionally add neovim if exists
[[ -d "$HOME/neovim/bin" ]] && export PATH="$HOME/neovim/bin:$PATH"

# ====================================================================
# LOCALE
# ====================================================================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Safety: some config tools prefer bash
export CONFIG_SHELL=/bin/bash

# ====================================================================
# OS DETECTION
# ====================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
    export OS_TYPE="macos"
elif [[ "$OSTYPE" == "linux"* ]]; then
    export OS_TYPE="linux"
fi

# ====================================================================
# PLATFORM SPECIFIC CONFIGURATIONS
# ====================================================================
if [[ "$OS_TYPE" == "macos" ]]; then
    # ================== macOS SPECIFIC ==================

    # Homebrew - check if brew exists at standard location
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # VS Code
    [[ -d "/Applications/Visual Studio Code.app" ]] && \
        alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

    # VMD
    export VMD=/Applications/VMD.app
    alias vmd='$VMD/Contents/Resources/VMD.app/Contents/MacOS/VMD'
    alias catdcd='$VMD/Contents/vmd/plugins/MACOSXX86_64/bin/catdcd5.2/catdcd'

    # MOE
    export MOE=/Applications/moe2022/
    alias moe='$MOE/bin/moe'
    alias licenze81='$MOE/lm/bin/lmutil lmstat -c $MOE/license.81 -a'
    alias licenze128='$MOE/lm/bin/lmutil lmstat -c $MOE/license.128 -a'

    # Schrodinger
    export SCHRODINGER=/opt/schrodinger/suites2025-3/
    export SCHRODINGER_SCRIPTS=/opt/schrodinger/schrodinger_utils/scripts
    alias schrun='$SCHRODINGER/run'

    # Python scripts (commented - adjust path as needed)
    [[ -d "/opt/python_scripts" ]] && export PATH="/opt/python_scripts:$PATH"

elif [[ "$OS_TYPE" == "linux" ]]; then
    # ================== LINUX SPECIFIC ==================

    # VS Code (various installation methods)
    command -v code >/dev/null || {
        [[ -f "/usr/bin/code" ]] && alias code='/usr/bin/code'
        [[ -f "/snap/bin/code" ]] && alias code='/snap/bin/code'
    }

    # Add common Linux paths
    [[ -d "/usr/local/bin" ]] && export PATH="/usr/local/bin:$PATH"

fi

# Common embedded toolchains (both platforms)
# Quantum Leaps tools
[[ -d "/opt/qp/qm/bin" ]] && export PATH=/opt/qp/qm/bin:$PATH

# Embedded ARM GCC toolchain
[[ -d "/opt/gcc-arm-none-eabi/bin" ]] && export PATH=/opt/gcc-arm-none-eabi/bin:$PATH

# RISC-V WCH GCC toolchain
[[ -d "/opt/RISC-V-gcc12-wch-v210/bin" ]] && export PATH=/opt/RISC-V-gcc12-wch-v210/bin:$PATH

# ====================================================================
# PYENV CONFIGURATION
# ====================================================================
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ====================================================================
# ADDITIONAL INTEGRATIONS
# ====================================================================
# FZF integration (cross-platform)
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# Cargo environment
. "$HOME/.cargo/env"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ====================================================================
# PROMPT INITIALIZATION (STARSHIP)
# ====================================================================
# Initialize starship if available
# this should be the last in the file
command -v starship >/dev/null && eval "$(starship init bash)"
