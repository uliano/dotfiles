# Installation Log

Questo documento tiene traccia delle installazioni e configurazioni effettuate su questo sistema.

## 📋 Note Metodologiche per Claude

**Approccio sistematico utilizzato:**
1. **TodoWrite**: Creare sempre todo list per task complessi, aggiornare in tempo reale lo stato
2. **Verifica situazione**: Controllare hardware/software esistente prima di procedere
3. **Installazioni incrementali**: Un componente alla volta, verificare ogni step
4. **Test completi**: Creare programmi di test per validare funzionalità
5. **Documentazione dettagliata**: Aggiornare questo file con comandi, risultati, configurazioni finali
6. **Directory custom**: Usare `/stuff/` per installazioni personalizzate invece dei default
7. **Environment isolati**: Creare conda environment dedicati per ogni progetto

**Pattern di lavoro:**
- Leggere questo file all'inizio per capire lo stato attuale
- Usare TodoWrite per pianificare e tracciare progresso
- Testare ogni installazione con programmi dedicati
- Aggiornare documentazione al completamento
- Mantenere approccio metodico e incrementale

**Setup attuale completato:**
- CUDA 12.0.140 + Driver NVIDIA 550.163.01
- Dual NVIDIA GTX 1080 Ti setup (2 GPU)
- Driver AMD rimossi (problema SMU risolto)
- Boot time ottimizzato: plymouth-quit-wait 4.6s (era 1+ minuto)
- Miniforge da reinstallare in `/home/uliano/.local/miniforge3`

## Hardware

- **CPU**: [da verificare]
- **GPU Primary**: NVIDIA GeForce GTX 1080 (8GB VRAM, PCIe 04:00.0) - Display attivo
- **GPU Secondary**: NVIDIA GeForce GTX 1080 (8GB VRAM, PCIe 0b:00.0) - Compute
- **Monitor**: 5120x1440 (richiede firmware update NVIDIA per BIOS/GRUB visibility)
- **OS**: Ubuntu 24.04.3 LTS (Noble)

## CUDA Setup

### Data: 2025-09-13

**Situazione iniziale:**
- Driver NVIDIA 550.163.01 già installato e funzionante
- Supporto CUDA 12.4 disponibile dal driver
- AMD RX 5700 XT gestisce il display
- CUDA toolkit mancante

**Installazione effettuata:**
```bash
sudo apt install nvidia-cuda-toolkit -y
```

**Risultato:**
- ✅ CUDA Toolkit 12.0.140 installato
- ✅ nvcc compiler disponibile
- ✅ Tutte le librerie CUDA installate
- ✅ Tool di sviluppo inclusi (Nsight Compute, Nsight Systems, Visual Profiler)
- ✅ Test di compilazione ed esecuzione superato

**Verifica:**
```bash
nvcc --version  # CUDA 12.0.140
nvidia-smi     # GTX 1080 operativa
# Test program compilato e eseguito con successo
```

**Configurazione finale:**
- AMD RX 5700 XT: Display e rendering grafico
- NVIDIA GTX 1080: Calcolo CUDA e machine learning
- Setup ibrido perfettamente funzionante

## Mouse Configuration

### Data: 2025-09-13

**Problema:** Rotella mouse con scorrimento al contrario

**Soluzione applicata:**
```bash
# Identificazione mouse
xinput list | grep -i mouse
# → Logitech Wireless Mouse MX Master 3 (id=11 pointer, id=14 keyboard)

# Inversione rotella (temporanea)
xinput set-button-map 11 1 2 3 5 4

# Configurazione permanente con rilevamento dinamico ID
echo '#!/bin/bash' > ~/.xprofile
echo '# Mouse scroll wheel inversion - find MX Master 3 pointer device dynamically' >> ~/.xprofile
echo 'MOUSE_ID=$(xinput list | grep "Logitech Wireless Mouse MX Master 3" | grep "slave  pointer" | sed '\''s/.*id=\([0-9]*\).*/\1/'\'')' >> ~/.xprofile
echo 'if [ -n "$MOUSE_ID" ]; then' >> ~/.xprofile
echo '    xinput set-button-map $MOUSE_ID 1 2 3 5 4' >> ~/.xprofile
echo 'fi' >> ~/.xprofile
chmod +x ~/.xprofile
```

**Alternative per GNOME:**
```bash
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
```

**Risultato:**
- ✅ Rotella mouse invertita immediatamente
- ✅ Configurazione permanente tramite `.xprofile` con rilevamento dinamico ID
- ✅ Si attiva automaticamente al login GUI
- ✅ Fix: Errore "device has no buttons" risolto usando ID corretto del pointer device

## Miniforge Setup

### Data: 2025-09-13

**Situazione iniziale:**
- Python di sistema disponibile ma senza package manager conda
- Necessità di gestione ambienti Python per machine learning

**Installazione effettuata:**
```bash
# Download installer
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh

# Installazione in directory personalizzata
bash Miniforge3-Linux-x86_64.sh -b -p /stuff/miniforge3

# Inizializzazione bash
/stuff/miniforge3/bin/conda init bash
```

**Risultato:**
- ✅ Miniforge3 25.3.1 installato in `/stuff/miniforge3`
- ✅ Python 3.12.11 incluso
- ✅ Conda package manager disponibile
- ✅ Mamba solver per performance migliori
- ✅ .bashrc modificato automaticamente per PATH

**Verifica:**
```bash
conda --version  # conda 25.3.1
python --version # Python 3.12.11 (miniforge)
which python     # /stuff/miniforge3/bin/python
```

**Configurazione finale:**
- Miniforge installato in `/stuff/miniforge3` invece del default `~/miniforge3`
- Auto-attivazione conda all'avvio della shell
- Pronto per installazione pacchetti ML (PyTorch, TensorFlow, etc.)

## PyTorch Environment Setup

### Data: 2025-09-13

**Creazione ambiente:**
```bash
# Creazione environment conda dedicato
conda create -n pytorch python=3.12 -y

# Attivazione environment
conda activate pytorch

# Installazione PyTorch con supporto CUDA
conda install pytorch torchvision torchaudio cpuonly -c pytorch -y

# Installazione pacchetti ML principali
conda install matplotlib scikit-learn pandas jupyter notebook transformers datasets -y
```

**Risultato:**
- ✅ Environment `pytorch` creato con Python 3.12.11
- ✅ PyTorch 2.5.1 con supporto CUDA 12.6 installato
- ✅ TorchVision e TorchAudio per computer vision e audio
- ✅ Pacchetti ancillari: matplotlib, scikit-learn, pandas, jupyter
- ✅ Transformers e datasets per NLP e ML
- ✅ Triton per ottimizzazioni GPU

**Test GPU creato:**
- Programma completo in `/stuff/test-pytorch/gpu_test.py`
- Test setup CUDA, operazioni matriciali, training rete neurale
- Benchmark CPU vs GPU, monitoraggio memoria
- Grafico performance generato automaticamente

**Risultati test:**
```bash
PyTorch Version: 2.5.1
CUDA Available: True
GPU 0: NVIDIA GeForce GTX 1080 (7.9 GB, Compute 6.1)

# Performance GPU vs CPU (matmul 5000x5000):
- CPU: 0.258s
- GPU: 0.038s
- Speedup: ~6.8x

# Neural Network Training: 50 epochs in 0.37s
# Memory usage: up to 680MB during heavy operations
```

**Configurazione finale:**
- PyTorch environment completamente operativo
- CUDA 12.6 + cuDNN 9.13 funzionanti
- GTX 1080 riconosciuta e utilizzabile per ML
- Test suite completa per validazione setup

## AMD GPU Power Management Fix

### Data: 2025-09-14

**Problema identificato:**
- AMD RX 5700 XT con timeout SMU (System Management Unit) ripetuti ogni 4-5 secondi
- Errori: `SMU: I'm not done with your previous command: SMN_C2PMSG_66:0x0000000D`
- Causa lunghi timeout all'avvio e spegnimento sistema
- Power management problematico su PC desktop fisso

**Diagnosi effettuata:**
```bash
# Analisi kernel logs
sudo dmesg | grep -i amdgpu
# → Errori SMU ripetuti, failure su ppfeatures e workload mask
# → Thermal protection rimane sempre attiva (hardware-level)
```

**Tentativi di soluzione:**

1. **Primo tentativo - Configurazione aggressiva (FALLITO)**:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.runpm=0 amdgpu.dpm=0 amdgpu.bapm=0 processor.max_cstate=1 intel_idle.max_cstate=0 idle=poll intel_pstate=disable amd_pstate=disable"
```
- ❌ **Risultato**: Sistema instabile con SMU timeout storm ogni 4-5 secondi
- ❌ **Boot logs**: `amd_pstate: failed to register with return -19`
- ❌ **Problema**: Loop infinito di errori SMU, sistema non responsive

2. **Entry GRUB di backup sicura** creata in `/etc/grub.d/40_custom`:
   - "Ubuntu SAFE (current working config)" - configurazione originale funzionante
   - Kernel: 6.14.0-29-generic con parametri `quiet splash`

3. **Soluzione finale conservativa** in `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.runpm=0"
```

**Parametro applicato:**
- `amdgpu.runpm=0` - Solo runtime power management AMD GPU disabilitato
- CPU power management mantenuto normale per stabilità sistema

**Risultato atteso:**
- ✅ Eliminazione timeout SMU specifici
- ✅ Sistema stabile con power management CPU normale
- ✅ Performance prevedibili senza compromettere stabilità
- ✅ Thermal protection hardware sempre attiva
- ✅ Entry backup "SAFE" sempre disponibile per recovery

**Configurazione finale:**
- GRUB default: Solo `amdgpu.runpm=0` (approccio conservativo)
- GRUB backup: Configurazione sicura originale (`quiet splash`)
- Comando: `sudo update-grub` eseguito

## Hardware Upgrade: Dual GTX 1080 Setup

### Data: 2025-09-16

**Problema risolto definitivamente:** AMD SMU timeout che causava boot lenti (1+ minuto)

**Soluzione radicale applicata:**
- Rimozione completa AMD RX 5700 XT (causa dei timeout SMU)
- Installazione dual NVIDIA GTX 1080
- Setup definitivamente stabile senza timeout AMD

**Configurazione hardware finale:**
```bash
# GPU verificate
lspci | grep VGA
# 04:00.0 VGA compatible controller: NVIDIA Corporation GP104 [GeForce GTX 1080]
# 0b:00.0 VGA compatible controller: NVIDIA Corporation GP104 [GeForce GTX 1080]

nvidia-smi
# GPU 0: NVIDIA GeForce GTX 1080 (04:00.0) - Display + Compute
# GPU 1: NVIDIA GeForce GTX 1080 (0b:00.0) - Compute dedicato
```

**Driver AMD rimossi:**
```bash
sudo apt remove --autoremove -y xserver-xorg-video-amdgpu
# Rimossi: xserver-xorg-video-amdgpu, libdrm-amdgpu1, e dipendenze
```

**Risultato straordinario:**
- ✅ Boot time: plymouth-quit-wait da **1+ minuto a 4.6 secondi** 🎉
- ✅ Zero timeout SMU (problema completamente eliminato)
- ✅ Dual GPU NVIDIA completamente funzionanti
- ✅ Monitor 5120x1440 supportato (firmware update required per BIOS visibility)
- ✅ Setup definitivamente stabile per ML/CUDA workloads

**Cleanup sistema post-upgrade:**
```bash
# Pulizia configurazione GRUB (16 Settembre 2025)
sudo cp /etc/default/grub /etc/default/grub.backup-before-cleanup
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash" #  amdgpu.runpm=0"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
sudo update-grub

# Verifica sistema boot
systemd-analyze verify && grub-install --version
```

**Doublecheck completato:** ✅
- GRUB: Configurazione pulita, parametri AMD rimossi
- Pacchetti boot: Tutti essenziali presenti (GRUB EFI, shim, kernel)
- Initramfs: 72MB integro, zero tracce AMD, NVIDIA inclusi
- Moduli: NVIDIA loaded correttamente, persistenced attivo su entrambe GPU
- EFI: Boot files aggiornati, Ubuntu primo in boot order

**Note tecniche importanti:**
- Firmware NVIDIA: Update necessario per visibilità BIOS/GRUB su monitor ultrawide
- PRIME: Configurazione "on-demand" mantenuta per compatibilità
- CUDA: Doppia potenza di calcolo disponibile con dual GPU

## Mouse Configuration

### Data: 2025-09-13

**Problema:** Rotella mouse con scorrimento al contrario

**Soluzione applicata:**
```bash
# Identificazione mouse
xinput list | grep -i mouse
# → Logitech Wireless Mouse MX Master 3 (id=14)

# Inversione rotella (temporanea)
xinput set-button-map 14 1 2 3 5 4

# Configurazione permanente
echo '#!/bin/bash' > ~/.xprofile
echo 'xinput set-button-map 14 1 2 3 5 4' >> ~/.xprofile
chmod +x ~/.xprofile
```

**Alternative per GNOME:**
```bash
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
```

**Risultato:**
- ✅ Rotella mouse invertita immediatamente
- ✅ Configurazione permanente tramite `.xprofile`
- ✅ Si attiva automaticamente al login GUI

## Shell Configuration: ZSH + Starship

### Data: 2025-09-16

**Obiettivo:** Configurare shell moderna con prompt avanzato copiando configurazione da macchina remota (192.168.1.167)

**Setup effettuato:**
```bash
# Installazione zsh e starship
sudo apt update && sudo apt install zsh -y
sudo wget -qO- https://starship.rs/install.sh | sudo sh -s -- --yes

# Copia configurazioni dalla macchina remota
scp 192.168.1.167:~/.zshrc ~/.zshrc
scp 192.168.1.167:~/.config/starship.toml ~/.config/starship.toml
```

**Configurazione ZSH (.zshrc):**
- Cross-platform compatibility (macOS/Linux)
- History avanzato (1M entries, no duplicates)
- Completion intelligente case-insensitive
- Aliases moderni con fallback (eza→ls, bat→cat, fd→find)
- OS detection automatico
- PATH management intelligente
- Conda/Mamba auto-detection
- Platform-specific configurations
- Starship prompt integration

**Configurazione Starship (starship.toml):**
- Formato custom: `user@host:path git_info conda python duration`
- Prompt colorato con simboli Unicode
- Timeout 1000ms per performance
- Git status completo (ahead/behind/staged)
- Conda environment display con icona 🅒
- Python version detection automatico 🐍
- Command duration per comandi lenti
- Moduli Docker/Package disabilitati per performance

**Risultato:**
- ✅ ZSH installato come shell alternativa
- ✅ Starship prompt funzionante e configurato
- ✅ Configurazione cross-platform copiata correttamente
- ✅ Modern aliases disponibili (eza, bat, fd se installati)
- ✅ Git integration completo
- ✅ Conda/Python environment detection

**Attivazione finale:**
```bash
# Per testare immediatamente
zsh

# Per rendere default (richiede logout/login)
chsh -s $(which zsh)
```

**Features principali:**
- Prompt moderno come su macchina remota 192.168.1.167
- Auto-completion intelligente
- Git status visuale immediato
- Environment Python/Conda identificati automaticamente
- Performance ottimizzate con timeout configurabili

## Modern Python Environment Setup

### Data: 2025-09-16

**Obiettivo:** Creare architettura Python completa con conda + venv ibrida per diversi use case

**Situazione iniziale:**
- Sistema con dual NVIDIA GTX 1080 funzionanti
- ZSH + Starship configurati
- Conda base esistente da ripulire

**Strategia implementata:**

**1. Conda Base Environment (mamba)**
- Pulizia completa installazione precedente
- Fresh install Miniforge3 in `/home/miniconda3`
- Configurazione `changeps1=False` per nascondere `(base)` nel prompt
- Popolamento base con 300+ pacchetti scientifici stabili

**2. Environment 3.13 (conda)**
- Python 3.13.7 bleeding edge in conda environment
- Pip 25.2 per pacchetti nuovi/sperimentali
- Posizione: `/home/miniconda3/envs/3.13`

**3. Environment PyTorch (venv --system-site-packages)**
- Venv con ereditarietà da base conda (trucco geniale!)
- PyTorch 2.6.0 + CUDA 12.4 via pip
- Stack ML completo senza rompere base
- Posizione: `/home/venvs/pytorch`

**Installazioni effettuate:**

**Base environment (mamba):**
```bash
# Excel e data manipulation
mamba install -n base openpyxl xlsxwriter xlrd xlwt polars pyarrow fastparquet

# Plotting avanzato
mamba install -n base altair bokeh plotnine holoviews datashader pyviz_comms param panel streamlit

# Statistiche avanzate
mamba install -n base pymc arviz emcee corner lifelines pingouin networkx graphviz python-graphviz

# Produttività e utility
mamba install -n base papermill nbconvert jupyterlab-git voila faker mimesis sqlalchemy psycopg2 pymongo redis-py httpx aiohttp fastapi uvicorn
```

**PyTorch environment (pip):**
```bash
source /home/venvs/pytorch/bin/activate

# PyTorch con CUDA 12.4
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# ML stack completo
pip install transformers datasets accelerate diffusers timm torchmetrics lightning wandb tensorboard huggingface_hub tokenizers safetensors
```

**Risultato architettura:**
```
🅒 Conda envs: base 3.13
📦 /home/venvs: pytorch
```

**Configurazioni shell:**

**Starship personalizzazione:**
```toml
# Spazio tra icona conda e nome environment
format = "🅒 [$environment]($style) "
```

**ZSH environment listing:**
```bash
show_environments() {
    local conda_list=$(/home/miniconda3/bin/conda info --envs 2>/dev/null | grep -v '^#' | grep -v '^$' | awk '{print $1}' | tr '\n' ' ')
    local venvs_list=$(ls -1 /home/venvs 2>/dev/null | tr '\n' ' ')

    echo "🅒 Conda envs: $conda_list"
    echo "📦 /home/venvs: $venvs_list"
}
```

**Test PyTorch completato:**
- ✅ Dual GPU rilevate (2x NVIDIA GTX 1080, 7.9GB each)
- ✅ CUDA 12.4 + cuDNN 9.1.0 funzionanti
- ✅ Performance GPU vs CPU: 8-15x speedup
- ✅ Neural network training: 50 epochs in 0.41s
- ✅ File test aggiornato: `/home/test-pytorch/gpu_test.py`

**Configurazione finale:**
- **base**: Ambiente ricchissimo per data science quotidiana
- **3.13**: Python fresco per sperimentazione e pacchetti nuovi
- **pytorch**: ML/DL con CUDA + ereditarietà intelligente da base
- **Prompt**: Informativo e pulito con environment listing all'avvio
- **GPU**: Dual setup operativo per training pesanti

**Attivazione environments:**
```bash
# Conda environments
conda activate 3.13

# Virtual environment
source /home/venvs/pytorch/bin/activate
```

**Setup pronto per:**
- 📊 Data science e analisi statistiche avanzate
- 🤖 Machine Learning e Deep Learning con CUDA
- 🎨 Generative AI (Stable Diffusion, transformers)
- 📈 Visualizzazioni avanzate (plotnine, altair, bokeh)
- ⚡ Development API moderne (FastAPI, async)
- 📚 Jupyter notebooks con estensioni Git