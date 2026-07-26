# Installation Log & Reference

Complete installation guide for the development environment based on Bash, uv, and modern CLI tools.

## System Overview

**Operating System:** Ubuntu/Debian-based Linux (testato su TUXEDO OS, glibc 2.39)
**Shell:** Bash with Starship prompt
**Python Management:** **uv** + Python 3.14 (dal 17 luglio 2026; prima pyenv — vedi sezione 2)
**Additional Tools:** NVM (Node.js), Cargo (Rust), FZF, eza, bat, fd, ripgrep

---

## 1. Base System Setup

### Shell Configuration

Bash is the default shell on most Linux systems. Configuration files:

- `~/.bashrc` - Main configuration (non-login shells)
- `~/.bash_profile` - Login shell configuration (sources .bashrc)
- `~/.aliases` - Custom tool aliases

Symlink dotfiles (meglio di `cp`: le modifiche restano tracciate dal repo).
**NB:** nel repo i file si chiamano `bashrc`/`bash_profile`, **senza punto iniziale**.

```bash
cd ~/dotfiles
ln -sf "$(pwd)/bashrc" ~/.bashrc
ln -sf "$(pwd)/bash_profile" ~/.bash_profile
ln -sf "$(pwd)/.aliases" ~/.aliases
mkdir -p ~/.config && ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
ln -sf "$(pwd)/ssh_config" ~/.ssh/config
ln -sf "$(pwd)/gdbinit" ~/.gdbinit
source ~/.bashrc
```

⚠️ **Conseguenza del symlink:** `~/.bashrc` punta *dentro il repo*. Gli installer che
appendono righe a `~/.bashrc` (nvm, rustup, fzf, conda…) scrivono nei dotfiles condivisi
e la modifica finisce su **tutte** le macchine. Dopo averne lanciato uno, controllare
sempre `git -C ~/dotfiles diff`. (rustup: usare `--no-modify-path`.)

### Bash Features Enabled

- **History**: 1M entries, shared across sessions, ignores duplicates
- **Completion**: Case-insensitive tab completion
- **Options**: `globstar`, `autocd`, `nocaseglob`
- **Modern tools**: Integration with eza, fd, bat

---

## 2. Python: uv (attuale) / PyEnv (storico)

> **Dal 17 luglio 2026 questa macchina usa uv.** La sezione PyEnv sotto resta come
> riferimento per macOS e per l'altra macchina Windows, non ancora migrate.

### 2a. uv — setup usato adesso

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh     # uv finisce in ~/.local/bin

uv python install 3.14 --default                    # CPython 3.14 + python/python3 nudi
uv python pin --global 3.14                         # default a livello utente

# Ambiente "globale" di default (effetto pyenv-global, senza attivare nulla)
uv venv --python 3.14 ~/.venvs/py314
uv pip install --python ~/.venvs/py314 pip          # UNA TANTUM: semina pip nel venv
```

Il `bashrc` prepone `~/.venvs/py314/bin` al PATH (guardato), **senza** settare `VIRTUAL_ENV`:
`python`/`pip` nudi risolvono nel default e starship resta pulito fuori dai progetti.

⚠️ Nel default installare con **`pip install`**, non `uv pip` (non scopre un venv che sta
solo sul PATH). Razionale completo e false piste: `windows-setup.md`.

Verifica:
```bash
python --version        # Python 3.14.6
command -v python       # ~/.venvs/py314/bin/python
echo "[$VIRTUAL_ENV]"   # vuoto = corretto
```

### 2b. PyEnv — riferimento storico (macOS / altra macchina Windows)

### Install Dependencies

```bash
sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev
```

### Install PyEnv

```bash
curl https://pyenv.run | bash
```

The installer adds PyEnv to your shell automatically. Our `.bashrc` includes:

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### Install Python

```bash
# List available versions
pyenv install --list | grep "^\s*3\."

# Install Python 3.13.7 (or latest)
pyenv install 3.13.7

# Set global version
pyenv global 3.13.7

# Verify
python --version
which python  # Should show ~/.pyenv/shims/python
```

### Install Base Packages

```bash
pip install --upgrade pip
pip install openai pydantic httpx tqdm
```

### PyEnv Virtual Environments

Create project-specific environments:

```bash
# Create virtualenv
pyenv virtualenv 3.13.7 myproject

# Activate
pyenv activate myproject

# Or set local version for directory
cd ~/myproject
pyenv local myproject
```

---

## 3. Starship Prompt

### Installation

```bash
wget -qO- https://starship.rs/install.sh | sh -s -- --yes
```

### Configuration

Copy the configuration:
```bash
mkdir -p ~/.config
cp starship.toml ~/.config/starship.toml
```

Starship is initialized at the end of `.bashrc`:
```bash
command -v starship >/dev/null && eval "$(starship init bash)"
```

### Custom Format

```
username@hostname:directory git_info python_version duration
❯
```

- **Python**: Shows 🐍 icon with version when in Python project
- **Git**: Branch, status, commit hash
- **Duration**: Command execution time (if > 500ms)
- **No conda**: Removed (using PyEnv instead)

---

## 4. Modern CLI Tools

### Install via apt

```bash
sudo apt update
sudo apt install -y eza bat fd-find fzf ripgrep
```

### Tool Replacements

- **eza** → `ls` (with colors, icons, git integration)
- **bat** → `bat` (cat con syntax highlighting; NON sostituisce `cat`)
- **fd** → `find` (faster, simpler syntax)
- **fzf** → Fuzzy finder (Ctrl+R for history, Ctrl+T for files)
- **ripgrep** → `rg` (grep veloce)

### Nomi dei binari su Debian/Ubuntu

Due pacchetti hanno il binario rinominato per conflitto con pacchetti preesistenti:

| pacchetto apt | binario reale |
|---|---|
| `fd-find` | **`fdfind`** |
| `bat` | **`batcat`** |

### Aliases (auto-configured in .bashrc)

```bash
alias ls='eza'
alias ll='eza -la'
alias lr='eza -lo --sort=modified'
alias lrg='eza -lag --sort=modified'
alias fd='fdfind'      # nome del binario su Ubuntu
alias find='fdfind'    # NB: punta al binario, non all'alias 'fd' (vedi sotto)
alias bat='batcat'     # bat con nome sensato; 'cat' resta il vero cat
```

> **Bug corretto il 17/07/2026 — `find` non era mai aliasato su Ubuntu.** Il `bashrc` aveva:
> ```bash
> command -v fd >/dev/null && alias find='fd'       # 'fd' non esiste su Ubuntu -> mai eseguito
> command -v fdfind >/dev/null && alias fd='fdfind'
> ```
> Su Debian/Ubuntu il binario e' `fdfind`, quindi `command -v fd` fallisce **sempre** e
> l'alias `find` non veniva creato: `find` restava quello di sistema, in silenzio.
> Non basta invertire le due righe (`fd` diventa un *alias*, e `command -v` cerca un
> *comando*): l'alias `find` ora punta direttamente a `fdfind`.

---

## 5. Optional: Node.js with NVM

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc

# Install latest LTS
nvm install --lts

# Verify
node --version
npm --version
```

NVM is auto-initialized in `.bashrc`:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

---

## 6. Optional: Rust with Cargo

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Choose: 1) Proceed with installation (default)
source ~/.bashrc

# Verify
cargo --version
rustc --version
```

Cargo is auto-initialized in `.bashrc`:
```bash
. "$HOME/.cargo/env"
```

---

## 7. Embedded Development Toolchains

Pre-configured PATH entries in `.bashrc`:

### Quantum Leaps Tools
```bash
export PATH=/opt/qp/qm/bin:$PATH
```

### ARM GCC (STM32, etc.)
```bash
export PATH=/opt/gcc-arm-none-eabi/bin:$PATH
```

### RISC-V WCH GCC (CH32V series)
```bash
export PATH=/opt/RISC-V-gcc12-wch-v210/bin:$PATH
```

---

## 8. Custom Tools & Aliases

### OpenOCD Builds

Two custom OpenOCD builds are aliased in `~/.aliases`:

**STMicroelectronics OpenOCD** (STM32 MCU/MPU):
```bash
alias openocd_stm='/opt/openocd_stm/bin/openocd'
```

**WCH OpenOCD** (CH32V RISC-V):
```bash
alias openocd_wch='/opt/OpenOCD-wch-v210/bin/openocd'
```

See `.aliases` file for build instructions and usage examples.

---

## 9. FZF Integration

### Installation
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Key Bindings (Bash)
- **Ctrl+R**: Search command history
- **Ctrl+T**: Search files
- **Alt+C**: Change directory

Auto-initialized in `.bashrc`:
```bash
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
```

---

## Configuration Files Summary

| File | Purpose |
|------|---------|
| `.bashrc` | Main bash configuration |
| `.bash_profile` | Login shell (sources .bashrc) |
| `.aliases` | Custom tool aliases |
| `starship.toml` | Starship prompt config |
| `.gdbinit` | gdb: auto-load safe-path per /sw (pretty printer STL del gcc compilato da sorgente) |
| `.bash_history` | Command history (auto-managed) |
| `.fzf.bash` | FZF bash integration (auto-generated) |

---

## Migration from Previous Setup

### Changes from Old Configuration

**Shell:**
- ❌ ZSH → ✅ Bash (simpler, more portable)

**Python:**
- ❌ Miniforge3/Conda (`/home/miniforge3`) → ✅ PyEnv (`~/.pyenv`)
- ❌ Hybrid conda + venv → ✅ PyEnv virtualenvs
- ❌ Multiple conda environments → ✅ PyEnv global + virtualenvs

**Prompt:**
- ✅ Starship (same, but bash init instead of zsh)
- ❌ Removed conda module from starship config
- ✅ Python version display preserved

**Tools:**
- ✅ All modern tools preserved (eza, bat, fd)
- ✅ All embedded toolchains preserved
- ✅ Custom OpenOCD builds preserved

---

## Verification

After setup, verify your environment:

```bash
# Shell
echo $SHELL  # /bin/bash

# Python (uv)
python --version     # Python 3.14.6
command -v python    # ~/.venvs/py314/bin/python
echo "[$VIRTUAL_ENV]" # vuoto = corretto (default solo-PATH)
uv --version
pip list

# Tools (NB: su Ubuntu i binari sono batcat e fdfind)
eza --version
batcat --version
fdfind --version
fzf --version
rg --version

# Optional
node --version  # if NVM installed
cargo --version # if Rust installed

# Starship
starship --version
```

---

## Troubleshooting

### Python not found after PyEnv install
```bash
# Ensure PyEnv is in PATH
echo $PYENV_ROOT  # Should show /home/user/.pyenv
source ~/.bashrc
```

### Starship not showing Python version
```bash
# Check if in Python project
touch requirements.txt
# Or create .python-version
pyenv local 3.13.7
```

### FZF keybindings not working
```bash
# Reinstall with keybindings
~/.fzf/install --key-bindings --completion --no-update-rc
source ~/.bashrc
```

---

## Quick Reference Commands

```bash
# uv (setup attuale)
uv python list                    # versioni disponibili/installate
uv python install 3.12            # installa un interprete
uv python pin --global 3.14       # default utente
uv python pin 3.11                # versione per il progetto corrente (.python-version)
uv venv                           # venv di progetto (poi: source .venv/bin/activate)
uv tool install --python 3.12 X   # tool isolato su un Python diverso
pip install X                     # installa NELL'ambiente di default py314 (non 'uv pip')

# PyEnv (macchine non ancora migrate)
pyenv versions              # List installed versions
pyenv global 3.13.7         # Set global version
pyenv virtualenv NAME       # Create virtualenv
pyenv activate NAME         # Activate virtualenv
pyenv local NAME            # Set local version for directory

# NVM
nvm list                    # List installed Node versions
nvm install --lts          # Install latest LTS
nvm use VERSION            # Switch version

# Starship
starship config            # Edit config
starship explain           # Debug prompt
starship toggle <module>   # Toggle module
```
