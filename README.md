# Uliano's Dotfiles

Cross-platform development environment setup with Bash, Starship, and PyEnv for Python.
Supports both **macOS** and **Linux**.

## Quick Setup

### 1. Shell Configuration

**macOS:**
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Bash (macOS uses old bash 3.x by default)
brew install bash

# Add Homebrew bash to allowed shells
sudo sh -c 'echo "/opt/homebrew/bin/bash" >> /etc/shells'

# Set as default shell
chsh -s /opt/homebrew/bin/bash

# Create symlinks to dotfiles
ln -sf "$(pwd)/.bashrc" ~/.bashrc
ln -sf "$(pwd)/.bash_profile" ~/.bash_profile
mkdir -p ~/.config
ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml

# Install Starship prompt and modern CLI tools
brew install starship eza bat fd fzf
```

**Linux:**
```bash
# Create symlinks to dotfiles
ln -sf "$(pwd)/.bashrc" ~/.bashrc
ln -sf "$(pwd)/.bash_profile" ~/.bash_profile
mkdir -p ~/.config
ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
ln -sf "$(pwd)/.aliases" ~/.aliases

# Install Starship prompt
wget -qO- https://starship.rs/install.sh | sh -s -- --yes

# Install modern CLI tools
sudo apt install eza bat fd-find fzf -y
```

### 2. Python Environment with PyEnv

**macOS:**
```bash
# Install PyEnv via Homebrew
brew install pyenv pyenv-virtualenv

# PyEnv will be initialized automatically via .bashrc
```

**Linux:**
```bash
# Install dependencies
sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install PyEnv
curl https://pyenv.run | bash

# PyEnv will be initialized automatically via .bashrc
```

**Install Python and set global version:**
```bash
# Install Python 3.13.7 (or latest)
pyenv install 3.13.7

# Set as global version
pyenv global 3.13.7

# Verify
python --version  # Should show Python 3.13.7
which python      # Should show ~/.pyenv/shims/python
```

**Install base packages:**
```bash
# Essential packages
pip install openai pydantic httpx tqdm
```

### 3. Optional: Additional Development Tools

**Node.js with NVM:**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
# NVM will be initialized automatically via .bashrc
```

**Rust with Cargo:**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Cargo will be initialized automatically via .bashrc
```

## Features

- **Cross-platform**: Automatic OS detection (macOS/Linux) with platform-specific configurations
- **Bash**: Modern bash configuration with history, completion, and modern tools
- **Starship**: Fast, customizable prompt with Git integration and Python version display
- **PyEnv**: Flexible Python version management (replaces Conda/Mamba)
- **Modern CLI tools**: eza (ls replacement), bat (cat replacement), fd (find replacement)
- **FZF**: Fuzzy finder integration
- **Custom aliases**: Tool-specific aliases loaded from `.aliases`

## Files

- `.bashrc`: Main bash configuration with PyEnv, NVM, Cargo integration
- `.bash_profile`: Login shell configuration (sources .bashrc)
- `.aliases`: Custom tool aliases (OpenOCD variants, etc.)
- `starship.toml`: Starship prompt configuration
- `gpu_test.py`: PyTorch CUDA functionality test (if using GPU)

## Python Version Display

The Starship prompt automatically shows the Python version when in a Python project:
- Detects `requirements.txt`, `pyproject.toml`, `.python-version`, etc.
- Shows active virtual environment if present
- Format: `🐍3.13.7`

## Custom Aliases

The `.aliases` file includes:
- **openocd_stm**: STMicroelectronics OpenOCD build for STM32 development
- **openocd_wch**: WCH OpenOCD build for CH32V RISC-V microcontrollers
- Add your custom tools following the documented pattern

## Embedded Development Toolchains

Pre-configured PATH for:
- Quantum Leaps QM tools (`/opt/qp/qm/bin`)
- ARM GCC toolchain (`/opt/gcc-arm-none-eabi/bin`)
- RISC-V WCH GCC toolchain (`/opt/RISC-V-gcc12-wch-v210/bin`)

## Platform-Specific Features

### macOS
- Homebrew integration and PATH configuration
- VS Code, VMD, MOE, Schrodinger software aliases
- macOS-specific tool locations

### Linux
- Ubuntu/Debian package manager integration
- Alternative VS Code installation paths (apt, snap)
- xdg-open alias for 'open' command

## System Requirements

**macOS:**
- macOS 10.15+ (Catalina or later)
- Homebrew package manager
- Git installed
- Bash 5.0+ (via Homebrew)

**Linux:**
- Ubuntu/Debian-based system
- Git installed
- Bash 4.0+ (for modern features like `autocd`)

For detailed installation logs and troubleshooting, see `install.md`.

## Migration Notes

**Migration from Conda/Mamba to PyEnv (October 2025):**
- Removed Conda/Miniforge in favor of PyEnv for lighter, more flexible Python management
- ZSH configuration backup created in `~/.zsh_backup/`
- Changed default shell from ZSH to Bash
- All configurations ported to cross-platform `.bashrc`

**Why this setup?**
- **ZSH → Bash**: Simpler, more portable, better compatibility across systems
- **Conda/Miniforge → PyEnv**: Lightweight, flexible Python version management without heavy base environments
- **Cross-platform**: Single `.bashrc` works on both macOS and Linux with automatic OS detection
