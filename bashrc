# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
fi

# --color=auto funziona sia con GNU grep (Linux) che BSD grep (macOS),
# quindi sta fuori dal guard dircolors (che e' solo Linux).
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ====================================================================
# ALIASES
# ====================================================================
# Default ls aliases (will be overridden by modern tools if available)
alias ls="ls --color=auto"
alias lr="ls -ltrh --color=auto"
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
# fd: su Debian/Ubuntu il binario si chiama fdfind (conflitto col pkg 'fd').
# NB: aliasare 'find' a 'fd' e basta non funziona qui — 'fd' e' un alias, non un
# comando, quindi 'command -v fd' fallisce; si punta direttamente al binario.
if command -v fdfind >/dev/null; then
    alias fd='fdfind'
    alias find='fdfind'
elif command -v fd >/dev/null; then
    alias find='fd'
fi

# bat: su Debian/Ubuntu il binario si chiama batcat (conflitto di nome col pkg 'bat')
# Aliasiamo solo bat->batcat, così bat è disponibile con un nome sensato.
# NON aliasiamo cat: 'cat' resta il vero cat. (batcat pipa in less e su file grossi
# 'G'/vai-a-fine blocca finché bat non ha processato tutto; per navigare usa less/tail.)
command -v batcat >/dev/null && alias bat='batcat'

# ====================================================================
# PATH CONFIGURATION
# ====================================================================
# Common paths
#export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
[[ -d "/opt/bin" ]] && export PATH="/opt/bin:$PATH"
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# npm global packages (user install)
[[ -d "$HOME/.npm-global/bin" ]] && export PATH="$HOME/.npm-global/bin:$PATH"

# Conditionally add neovim if exists
[[ -d "$HOME/neovim/bin" ]] && export PATH="$HOME/neovim/bin:$PATH"

# PlatformIO CLI tool
[[ -d "$HOME/.platformio/penv/bin" ]] && export PATH="$HOME/.platformio/penv/bin:$PATH"

# from biostars
[[ -d "$HOME/edirect" ]] && export PATH="$HOME/edirect:$PATH"
[[ -d "$HOME/bin/sratoolkit.3.0.0-ubuntu64" ]] && export PATH=~/bin/sratoolkit.3.0.0-ubuntu64/bin:$PATH

# brio
[[ -d "$HOME/projects/brio/bin" ]] && export PATH="$HOME/projects/brio/bin:$PATH"

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

    # avr-gcc e' keg-only (formula versionata avr-gcc@N, tap osx-cross/avr):
    # brew non lo linka in /opt/homebrew/bin. Il glob prende tutte le versioni
    # installate; prependendo in ordine, l'ultima (la piu' alta) vince.
    for _keg in /opt/homebrew/opt/avr-gcc@*/bin; do
        [[ -d "$_keg" ]] && export PATH="$_keg:$PATH"
    done
    unset _keg

    # gcc GNU: brew installa solo i nomi versionati (gcc-16, g++-16) per non
    # coprire gcc/g++ di sistema (= Apple clang). Alias solo interattivi:
    # in shell gcc e' GNU come su Linux (/sw/gcc), ma make/cmake/pip
    # continuano a vedere clang e i build macOS non si rompono.
    for _v in 17 16 15; do
        if command -v "gcc-$_v" >/dev/null; then
            alias gcc="gcc-$_v"
            alias g++="g++-$_v"
            break
        fi
    done
    unset _v

    # VS Code
    [[ -d "/Applications/Visual Studio Code.app" ]] && \
        alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

    # VMD
    export VMD=/Applications/VMD.app
    alias vmd='$VMD/Contents/Resources/VMD.app/Contents/MacOS/VMD'
    alias catdcd='$VMD/Contents/vmd/plugins/MACOSXX86_64/bin/catdcd5.2/catdcd'

    # MOE
    export MOE=/Applications/moe2024.0604
    alias moe='$MOE/bin/moe'
    alias licenze='$MOE/lm/bin/lmutil lmstat -c $MOE/license.dat -a'
    [[ -d "$MOE/bin" ]] && export PATH="$PATH:$MOE/bin"

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

    alias open='xdg-open'

    # Add an "alert" alias for long running commands (notify-send e' solo Linux).
    # Use like so:  sleep 10; alert
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

fi

# Common embedded toolchains (both platforms)
# Quantum Leaps tools
[[ -d "/opt/qp/qm/bin" ]] && export PATH=/opt/qp/qm/bin:$PATH

# Embedded ARM GCC toolchain
[[ -d "/opt/gcc-arm-none-eabi/bin" ]] && export PATH=/opt/gcc-arm-none-eabi/bin:$PATH

# RISC-V WCH GCC toolchain
[[ -d "/opt/RISC-V-gcc12-wch-v210/bin" ]] && export PATH=/opt/RISC-V-gcc12-wch-v210/bin:$PATH

# Toolchain compilate da sorgente in /sw (build-arm-none-eabi.sh / build-avr.sh).
# Prepese DOPO le /opt: dove coesistono, la versione /sw (piu' recente) vince.
# Symlink versionati (/sw/arm-none-eabi -> ...-16.1, /sw/avr -> avr-16.1).
[[ -d "/sw/arm-none-eabi/bin" ]] && export PATH=/sw/arm-none-eabi/bin:$PATH
[[ -d "/sw/avr/bin" ]] && export PATH=/sw/avr/bin:$PATH
[[ -d "/sw/gcc/bin" ]] && export PATH=/sw/gcc/bin:$PATH   # gcc nativo 16.x (shadowa il gcc di sistema)
[[ -d "/sw/cmake/bin" ]] && export PATH=/sw/cmake/bin:$PATH  # cmake 4.x da sorgente (build-devtools.sh)
[[ -d "/sw/gdb/bin" ]] && export PATH=/sw/gdb/bin:$PATH      # gdb 17.x da sorgente (build-devtools.sh)
[[ -d "/sw/claude-science/bin" ]] && export PATH=/sw/claude-science/bin:$PATH  # binario standalone Anthropic

# ====================================================================
# PYENV CONFIGURATION
# ====================================================================
# Macchine ancora su pyenv (vedi README "Migration Notes"). Sulle macchine
# passate a uv, pyenv non c'e' e questo blocco e' un no-op.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# ====================================================================
# UV: AMBIENTE "GLOBALE" DI DEFAULT (effetto pyenv-global)
# ====================================================================
# venv NON attivato, solo-PATH: bare python/pip/jupyter risolvono qui, ma
# senza VIRTUAL_ENV -> starship resta pulito fuori dai progetti python.
# Prepeso DOPO pyenv cosi' vince; guardato, quindi no-op sulle macchine a pyenv.
# NB: installare nel default con `pip install`, NON `uv pip` (vedi windows-setup.md).
[[ -d "$HOME/.venvs/py314/bin" ]] && export PATH="$HOME/.venvs/py314/bin:$PATH"

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
# Su macOS serve `brew install bash-completion@2` (terzo ramo).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  fi
fi

# ====================================================================
# ADDITIONAL INTEGRATIONS
# ====================================================================
# FZF integration (cross-platform)
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# Cargo environment
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ====================================================================
# NODE / NVM: TOLTO, E PERCHE'
# ====================================================================
# nvm era entrato per Claude Code, quando si installava come pacchetto
# npm globale (vedi il vecchio PATH su node_modules/.bin, tolto come
# obsoleto). Oggi claude e kimi sono binari nativi, e su questa
# macchina non restava un solo pacchetto globale oltre a npm e
# corepack, ne' un progetto node: gli unici node_modules erano quelli
# delle estensioni di VS Code, che girano sul node di VS Code. Le
# ultime due invocazioni di npm registrate erano `npm config get
# prefix` e `npm ls -g --depth 0`, cioe' Claude Code che controllava di
# non essere piu' un pacchetto npm. Sorgere nvm.sh costava 88 ms dei
# 148 che costa aprire una shell, per un comando che non usava nessuno.
#
# SULLE ALTRE MACCHINE: se ~/.nvm c'e' ancora, guarda
# `npm ls -g --depth 0`; se non elenca niente di tuo e' un residuo
# (qui erano 236 MB) e si toglie con `rm -rf ~/.nvm ~/.npm`.
#
# SE UN GIORNO NODE SERVE DAVVERO: si installa allora, scegliendo la
# versione che serve in quel momento; e se torna nvm, torna caricato
# pigramente - il PATH della versione installata messo qui e una
# funzione `nvm` che sorge nvm.sh alla prima invocazione, cosi' i
# processi figli vedono node e la shell non paga gli 88 ms.

if [[ -d "$HOME/micromamba" ]]; then
    # >>> mamba initialize >>>
    # !! Contents within this block are managed by 'micromamba shell init' !!
    export MAMBA_EXE='/home/uliano/bin/micromamba';
    export MAMBA_ROOT_PREFIX='/home/uliano/micromamba';
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
    fi
    unset __mamba_setup
    # <<< mamba initialize <<<
fi

# kimi-code
# Ultimo prepend, quindi la voce che vince: sta QUI e non in fondo al
# file perche' il dedupe qui sotto deve vedere ogni aggiunta al PATH.
[[ -d "$HOME/.kimi-code/bin" ]] && export PATH="$HOME/.kimi-code/bin:$PATH"

# ====================================================================
# PATH: UNA SOLA COPIA DI OGNI VOCE
# ====================================================================
# I prepend di questo file - e quelli di nvm, pyenv, uv, cargo,
# micromamba, kimi-code - antepongono senza controllare se la voce c'e'
# gia'. Se ~/.bashrc viene applicato due volte nella stessa discendenza
# (VS Code risolve l'ambiente con una shell di login e POI il terminale
# integrato sorge di nuovo questo file) il PATH esce duplicato, e ogni
# shell annidata aggiunge un'altra copia. Si tiene la PRIMA occorrenza,
# che e' quella che vince nella ricerca: la precedenza non cambia; una
# voce vuota (= la directory corrente) sparisce, ed e' un bene.
# Misurato: 358 us su un PATH di 37 voci, contro i 148 ms che costa
# aprire una shell - e quanto le venti guardie messe a ogni prepend,
# che pero' non coprirebbero le righe scritte dagli installer altrui.
# Sintassi bash 3.2, per il ramo macOS.
__path_dedupe() {
    local out= dir
    local IFS=:
    for dir in $PATH; do
        case ":$out:" in
            *":$dir:"*) ;;
            *) out="${out:+$out:}$dir" ;;
        esac
    done
    PATH=$out
}
__path_dedupe
unset -f __path_dedupe

# ====================================================================
# PROMPT INITIALIZATION (STARSHIP)
# ====================================================================
# Initialize starship if available
# this should be the last in the file: prende PS1, si accoda a
# PROMPT_COMMAND e stratifica il trap DEBUG, quindi chi viene sorto
# dopo di lui glieli sovrascrive.
command -v starship >/dev/null && eval "$(starship init bash)"
