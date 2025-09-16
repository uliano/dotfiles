# Uliano's Dotfiles

Modern development environment setup with ZSH, Starship, and Python ML environments.

## Quick Setup

### 1. Shell Configuration

```bash
# Copy dotfiles
cp .zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml

# Install dependencies
sudo apt install zsh -y
wget -qO- https://starship.rs/install.sh | sh -s -- --yes

# Install modern tools
sudo apt install eza bat fd-find -y

# Switch to ZSH (optional)
chsh -s $(which zsh)
```

### 2. Python Environment Architecture

**Base Environment (conda):**
```bash
# Install Miniforge3
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
bash Miniforge3-Linux-x86_64.sh -b -p /home/miniconda3
/home/miniconda3/bin/conda init zsh

# Configure conda
/home/miniconda3/bin/conda config --set changeps1 False

# Install base packages
mamba install -n base $(cat requirements/base-conda.txt | grep -v '^#' | tr '\n' ' ')
```

**Python 3.13 Environment:**
```bash
mamba create -n 3.13 python=3.13 pip -y
```

**PyTorch + CUDA Environment:**
```bash
# Create venv with system-site-packages inheritance
python -m venv /home/venvs/pytorch --system-site-packages
source /home/venvs/pytorch/bin/activate

# Check CUDA version
nvidia-smi | grep "CUDA Version"

# Install PyTorch (adjust cu124 based on your CUDA version)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Install ML packages
pip install transformers datasets accelerate diffusers timm torchmetrics lightning wandb tensorboard huggingface_hub tokenizers safetensors
```

### 3. Test GPU Setup

```bash
source /home/venvs/pytorch/bin/activate
python gpu_test.py
```

## Environment Overview

After setup, you'll have:

```
🅒 Conda envs: base 3.13
📦 /home/venvs: pytorch
```

- **base**: Rich scientific environment (300+ packages)
- **3.13**: Bleeding edge Python for experimentation
- **pytorch**: ML/DL with CUDA + inheritance from base

## Activation

```bash
# Conda environments
conda activate 3.13

# Virtual environment
source /home/venvs/pytorch/bin/activate
```

## Features

- **ZSH + Starship**: Modern shell with Git integration
- **Environment listing**: Shows available environments on shell start
- **Modern tools**: eza, bat, fd for enhanced CLI experience
- **CUDA Support**: Dual GPU setup ready for ML/DL
- **Hybrid approach**: conda stability + pip flexibility

## Files

- `.zshrc`: ZSH configuration with modern tools and environment listing
- `starship.toml`: Custom prompt configuration
- `gpu_test.py`: PyTorch CUDA functionality test
- `install.md`: Complete installation log and reference
- `requirements/`: Package lists for each environment

## Hardware Requirements

- NVIDIA GPU with CUDA support
- Ubuntu/Debian-based system
- Git installed

For detailed setup process and troubleshooting, see `install.md`.