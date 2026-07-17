# Uliano's Dotfiles

Cross-platform development environment setup with Bash, Starship, and Python.
Supports **macOS**, **Linux** and **Windows** (PowerShell — vedi `windows-setup.md`).

**Python:** migrazione **pyenv → uv** in corso (Python 3.14). Stato per macchina:

| Macchina | Python | Note |
|---|---|---|
| Windows (workstation) | **uv** + 3.14 | prima migrata, giugno 2026 — `windows-setup.md` |
| Linux (TUXEDO) | **uv** + 3.14.6 | migrata 17 luglio 2026 |
| Windows (altra) | pyenv-win | da migrare |
| macOS | pyenv | da migrare |

Il `bashrc` supporta entrambi: il blocco pyenv e quello uv sono guardati, quindi
lo stesso file funziona sulle macchine migrate e su quelle ancora a pyenv.

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
# NB: nel repo i file si chiamano 'bashrc' e 'bash_profile', SENZA punto iniziale.
ln -sf "$(pwd)/bashrc" ~/.bashrc
ln -sf "$(pwd)/bash_profile" ~/.bash_profile
mkdir -p ~/.config
ln -sf "$(pwd)/starship.toml" ~/.config/starship.toml
ln -sf "$(pwd)/.aliases" ~/.aliases
ln -sf "$(pwd)/ssh_config" ~/.ssh/config

# Install Starship prompt
# NB: lo script ufficiale fa sudo per scrivere in /usr/local/bin, ma in pipe da
# curl non ha un tty per la password e aborta. Installarlo in ~/.local/bin
# (gia' nel PATH via bashrc) evita del tutto il problema:
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin

# Install modern CLI tools
sudo apt install eza bat fd-find fzf ripgrep -y
```

### 2. Python Environment

> **Aggiornamento luglio 2026:** su **Windows (workstation)** e **Linux** Python e' gestito
> da **uv** con Python 3.14 — vedi [Python con uv](#python-con-uv) qui sotto.
> La sezione **PyEnv** che segue resta valida per **macOS** e per l'**altra macchina Windows**,
> ancora da migrare.

#### Python con uv

```bash
# Installazione (Linux/macOS)
curl -LsSf https://astral.sh/uv/install.sh | sh

uv python install 3.14 --default      # CPython 3.14 + python/python3 in ~/.local/bin
uv python pin --global 3.14           # versione di default a livello utente

# Ambiente "globale" di default (effetto pyenv-global, senza attivare nulla)
uv venv --python 3.14 ~/.venvs/py314
uv pip install --python ~/.venvs/py314 pip   # UNA TANTUM: semina pip nel venv
```

Il `bashrc` prepone `~/.venvs/py314/bin` al PATH (guardato da `[[ -d ... ]]`), quindi
`python`/`pip`/`jupyter` nudi risolvono li' **senza** settare `VIRTUAL_ENV` → il prompt
starship resta pulito fuori dai progetti Python.

⚠️ **Nel default si installa con `pip install`, NON con `uv pip`**: `uv pip` non scopre un
venv che sta solo sul PATH e installerebbe nel Python gestito da uv. Il razionale completo
e le false piste sono in `windows-setup.md` (valgono identiche su Linux).

Per-progetto: `uv venv` (+ `uv python pin <ver>`). Vedi la tabella pyenv→uv in `windows-setup.md`.

#### PyEnv (macOS e altra macchina Windows)

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
- **uv / PyEnv**: gestione Python — uv sulle macchine migrate, pyenv sulle altre (blocchi guardati, stesso `bashrc`)
- **Modern CLI tools**: eza (ls replacement), bat (cat replacement), fd (find replacement), ripgrep
- **FZF**: Fuzzy finder integration
- **Custom aliases**: Tool-specific aliases loaded from `.aliases`

## Files

Nomi reali nel repo (senza punto iniziale — si symlinkano a `~/.bashrc` ecc.):

- `bashrc`: Main bash configuration — pyenv, **uv**, NVM, Cargo, aliases
- `bash_profile`: Login shell configuration (sources .bashrc)
- `.aliases`: Custom tool aliases (attualmente solo `openocd_stm`)
- `starship.toml`: Starship prompt configuration (cross-platform)
- `ssh_config`: SSH config (cross-platform) → `~/.ssh/config`
- `Microsoft.PowerShell_profile.ps1`: profilo PowerShell (Windows)
- `python_packages_installed.txt`: pacchetti dell'ambiente di default py314
- `install.md` / `windows-setup.md`: log di installazione Linux/macOS e Windows

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

**Experimenting with uv on Windows (June 2026):**
- On the Windows workstation, trialing [uv](https://docs.astral.sh/uv/) as a single-tool replacement for PyEnv (uv also subsumes venv / pip / pipx).
- Default "global" environment is a uv venv pinned to Python 3.14 whose `Scripts` dir is prepended to `PATH`, so bare `python` / `pip` / `jupyter` resolve to it — the PyEnv-global feel, **without** activating a venv (keeps the Starship prompt clean). Note: `pip` is seeded into that venv on purpose, because `uv pip` does **not** discover the env from `PATH` (it would target uv's managed Python) — so installs into the default use bare `pip install`, not `uv pip`. See `windows-setup.md` for the full rationale and the dead-ends to avoid.
- Per-project: `uv venv` (+ `.python-version`); other interpreters via `uv python install <ver>`.
- Tools that lag on the newest Python (e.g. marker-pdf, pinned to an old Pillow with no 3.14 Windows wheel) are isolated with `uv tool install --python 3.12 <tool>`.

**uv esteso a Linux (17 luglio 2026):**
- Esperimento promosso: la macchina **Linux (TUXEDO OS)** e' stata configurata da zero con uv + **Python 3.14.6**, stesso design di Windows (venv `~/.venvs/py314` non attivato, solo-PATH, `pip` seminato dentro).
- Su Linux la dir del venv e' `bin/` (non `Scripts/`); il resto e' identico, incluse le false piste da evitare (`UV_PYTHON`, `VIRTUAL_ENV` nel profilo).
- Il blocco uv nel `bashrc` e' guardato da `[[ -d ~/.venvs/py314/bin ]]` → **no-op** sulle macchine ancora a pyenv, che restano intatte.
- **Da migrare:** macOS e l'altra macchina Windows.

**Politica sulle versioni (luglio 2026):**
- Si punta alle **versioni piu' recenti compatibili**, non alla riproduzione dei pin esistenti: le macchine si allineano a seguire, dove si riesce.
- Corollario pratico: prima di aggirare un vincolo (compilare dai sorgenti, declassare una dipendenza), **verificare se l'upstream l'ha gia' rimosso in una release recente**. E' successo con `opencv-python` e `nglview` — vedi `python_packages_installed.txt`.

**Pacchetti GPU/NVIDIA: nessuna regola per piattaforma, si verifica macchina per macchina.**
Il parco e' misto (Linux/Windows/macOS, alcune con NVIDIA e alcune no) e i default di PyPI
cambiano col sistema operativo: su Linux `torch` di default e' la build **CUDA**, su Windows
e' **CPU**. Sbagliare costa in entrambi i versi — gigabyte di peso morto dove NVIDIA non c'e',
GPU sprecata dove c'e'. Procedura (`nvidia-smi` prima, scelta poi) e trappole note
(`torch`, `xgboost`) in **`python_packages_installed.txt`**, sezione
*"PACCHETTI NVIDIA: VERIFICARE MACCHINA PER MACCHINA"*.

**Why this setup?**
- **ZSH → Bash**: Simpler, more portable, better compatibility across systems
- **Conda/Miniforge → PyEnv**: Lightweight, flexible Python version management without heavy base environments
- **Cross-platform**: Single `.bashrc` works on both macOS and Linux with automatic OS detection
