# Installation Log & Reference

Complete installation guide for the development environment based on Bash, PyEnv, and modern CLI tools.

## System Overview

**Operating System:** Ubuntu/Debian-based Linux
**Shell:** Bash with Starship prompt
**Python Management:** PyEnv
**Additional Tools:** NVM (Node.js), Cargo (Rust), FZF, eza, bat, fd

---

## 1. Base System Setup

### Shell Configuration

Bash is the default shell on most Linux systems. Configuration files:

- `~/.bashrc` - Main configuration (non-login shells)
- `~/.bash_profile` - Login shell configuration (sources .bashrc)
- `~/.aliases` - Custom tool aliases

Copy dotfiles:
```bash
cd ~/dotfiles
cp .bashrc ~/.bashrc
cp .bash_profile ~/.bash_profile
cp .aliases ~/.aliases
source ~/.bashrc
```

### Bash Features Enabled

- **History**: 1M entries, shared across sessions, ignores duplicates
- **Completion**: Case-insensitive tab completion
- **Options**: `globstar`, `autocd`, `nocaseglob`
- **Modern tools**: Integration with eza, fd, bat

---

## 2. PyEnv Installation

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
sudo apt install -y eza bat fd-find fzf
```

### Tool Replacements

- **eza** → `ls` (with colors, icons, git integration)
- **bat** → `cat` (with syntax highlighting)
- **fd** → `find` (faster, simpler syntax)
- **fzf** → Fuzzy finder (Ctrl+R for history, Ctrl+T for files)

### Aliases (auto-configured in .bashrc)

```bash
alias ls='eza'
alias ll='eza -la'
alias lr='eza -lo --sort=modified'
alias lrg='eza -lag --sort=modified'
alias find='fd'
alias fd='fdfind'  # Ubuntu package name
```

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

# Python
python --version  # Python 3.13.7
which python      # ~/.pyenv/shims/python
pip list

# Tools
eza --version
bat --version
fd --version
fzf --version

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
# PyEnv
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
