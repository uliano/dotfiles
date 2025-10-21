# Windows Development Environment Setup

## Contesto
Configurazione ambiente di sviluppo Windows per replicare setup Linux/macOS usando dotfiles esistenti.

**Obiettivi:**
1. File cross-platform (starship.toml, ssh_config) → symlink da dotfiles/
2. Analizzare bashrc per capire tool usati → installare equivalenti Windows
3. Creare nuovo profilo PowerShell → salvarlo in dotfiles/ e symlinkarlo
4. Mantenere simmetria tra Linux/Mac e Windows dove possibile

## Directory Dotfiles
```
C:\Users\uliano\dotfiles\
├── .aliases                             # Alias custom (openocd_stm, ecc.)
├── bash_profile                         # Bash profile (Linux/Mac)
├── bashrc                               # Bash config principale (Linux/Mac)
├── starship.toml                        # Config Starship (cross-platform!) ✅
├── Microsoft.PowerShell_profile.ps1     # PowerShell profile (Windows) ✅
├── ssh_config                           # Config SSH (cross-platform!) ✅
├── windows-setup.md                     # Documentazione setup Windows
└── README.md                            # Documentazione generale
```

## Tool da Installare (da bashrc)

### ✅ COMPLETATI
1. **Starship** - Prompt cross-platform
   - Installato: `winget install --id Starship.Starship`
   - Config: `C:\Users\uliano\.config\starship.toml` → symlink a `dotfiles/starship.toml`
   - Symlink creato con: `sudo powershell -Command "New-Item -ItemType SymbolicLink ..."`

2. **pyenv-win** (v3.1.1) - Gestione versioni Python
   - Installato via script ufficiale (winget non disponibile)
   - Python 3.13.7 installato e configurato come versione globale
   - Variabili d'ambiente configurate (PYENV, PYENV_ROOT, PYENV_HOME)
   - PATH aggiornato automaticamente

3. **eza** (v0.23.4) - Sostituto moderno di `ls`
   - Installato: `winget install eza-community.eza`
   - Alias configurati nel profilo PowerShell: `ls`, `ll`, `lr`, `lrg`

4. **fd** (v10.3.0) - Sostituto moderno di `find`
   - Installato: `winget install sharkdp.fd`
   - Alias `find` configurato nel profilo

5. **fzf** (v0.66.0) - Fuzzy finder
   - Installato: `winget install fzf`
   - Disponibile nel PATH

6. **ripgrep** (v14.1.1) - Grep veloce
   - Installato: `winget install BurntSushi.ripgrep.MSVC`
   - Alias `rg` disponibile

7. **nvm-windows** (v1.2.2) - Node Version Manager
   - Installato: `winget install CoreyButler.NVMforWindows`
   - Variabili d'ambiente configurate automaticamente

8. **bat** (v0.25.0) - Cat con syntax highlighting
   - Installato: `winget install sharkdp.bat`
   - Alias `cat` configurato nel profilo PowerShell

9. **GitHub CLI (gh)** (v2.81.0) - Interfaccia GitHub da riga di comando
   - Installato: `winget install GitHub.cli`
   - Disponibile automaticamente nel PATH
   - Per autenticarsi: `gh auth login`

## PowerShell Profile ✅ COMPLETATO

**Posizione:**
- File sorgente: `C:\Users\uliano\dotfiles\Microsoft.PowerShell_profile.ps1`
- Symlink Windows PowerShell 5.x: `C:\Users\uliano\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` → dotfiles
- Symlink PowerShell Core 7.x: `C:\Users\uliano\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` → dotfiles

**Configurazioni incluse:**
- ✅ Inizializzazione Starship (ultima riga, come bashrc)
- ✅ Alias eza: `ls`, `ll`, `lr`, `lrg`, `la`, `l`
- ✅ Alias fd: `find`
- ✅ Alias bat: `cat` usa `bat -p` (plain, no decorations), `bat` rimane decorato
- ✅ Alias ripgrep: `grep`
- ✅ Inizializzazione pyenv-win (variabili d'ambiente e PATH)
- ✅ Inizializzazione nvm-windows (variabili d'ambiente)
- ✅ WinGet Links PATH (aggiunto esplicitamente per eza, fd, fzf, rg, bat, gh)
- ✅ **PSReadLine configuration avanzata** (vedi sezione dedicata sotto)
- ✅ Encoding UTF-8
- ✅ Utility functions (edit profile, reload, public IP, ecc.)
- ✅ Compatibility aliases (navigation shortcuts: `..`, `...`, ecc.)

### 🎯 PSReadLine - Completamento e Predizioni Intelligenti

**PSReadLine** è un modulo PowerShell che trasforma l'esperienza di editing della command line, rendendola simile a shell moderne come fish o zsh con oh-my-zsh.

**Funzionalità attive nel profilo:**

1. **History-based Predictions** (`-PredictionSource History`)
   - Mentre digiti, PSReadLine analizza la tua cronologia e suggerisce comandi che hai già usato
   - Suggerimenti in **testo grigio** che appaiono automaticamente
   - Simile al comportamento di fish shell

2. **ListView Style** (`-PredictionViewStyle ListView`)
   - Mostra una **lista di suggerimenti sotto la riga corrente**
   - Display multi-riga con più opzioni dalla history
   - Navigazione con frecce ↑↓ tra i suggerimenti
   - Alternativa: `InlineView` mostra solo un suggerimento sulla stessa riga

3. **History Management**
   - `HistoryNoDuplicates` - Evita duplicati nella cronologia (come bash HISTCONTROL)
   - `MaximumHistoryCount: 10000` - Mantiene fino a 10.000 comandi in memoria
   - `HistorySearchCursorMovesToEnd` - Posiziona cursore alla fine durante la ricerca

4. **Keybindings avanzate**
   - `Tab` → Menu completion interattivo
   - `↑` → Ricerca all'indietro nella history (search backward)
   - `↓` → Ricerca in avanti nella history (search forward)
   - `Ctrl+R` → Ricerca interattiva nella history (built-in PowerShell)

**Esempio pratico:**
```powershell
# Digiti: py
# PSReadLine suggerisce automaticamente:
python --version          # Grigio - dalla tua history
python script.py         # Secondo suggerimento in ListView

# Premi → (freccia destra) o Tab per accettare il suggerimento
# Premi ↓ per vedere altre opzioni dalla history
```

**Note:**
- Le predizioni vengono disabilitate automaticamente in shell non interattive (con gestione errori)
- Funziona solo se il terminale supporta Virtual Terminal (VT) processing
- Su Windows Terminal, VS Code terminal e PowerShell 7+ funziona perfettamente

**Execution Policy:**
- Impostata a `RemoteSigned` per CurrentUser
- Comando usato: `pwsh -NoProfile -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"`

## SSH Config ✅ COMPLETATO

**Posizione:**
- File sorgente: `C:\Users\uliano\dotfiles\ssh_config`
- Symlink: `C:\Users\uliano\.ssh\config` → dotfiles

**Host configurati:**
- GitHub (con chiave id_ed25519)
- Host locali (pi, mele, riscv, orange3b)
- Server UNIMI (xlence, xlence2, indaco, indaco1, indaco2)
- Server lab (jane, nero, cita, huey, dewey, louie, licsrv, licensebox, elenuar, logbook)

**Opzioni globali:**
- ServerAliveInterval: 60 (keep-alive)
- ForwardAgent: yes (per chiavi SSH)
- Compression: yes
- ServerAliveCountMax: 3

## Comandi Symlink ✅ COMPLETATI

**Nota:** Developer Mode attivo, ma `sudo` è necessario per i symlink.

```bash
# Starship config ✅
sudo powershell -Command "New-Item -ItemType SymbolicLink -Path 'C:\Users\uliano\.config\starship.toml' -Target 'C:\Users\uliano\dotfiles\starship.toml'"

# PowerShell profile (Windows PowerShell 5.x) ✅
sudo powershell -Command "New-Item -ItemType SymbolicLink -Path 'C:\Users\uliano\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1' -Target 'C:\Users\uliano\dotfiles\Microsoft.PowerShell_profile.ps1'"

# PowerShell profile (PowerShell Core 7.x / pwsh) ✅
sudo powershell -Command "New-Item -ItemType SymbolicLink -Path 'C:\Users\uliano\Documents\PowerShell\Microsoft.PowerShell_profile.ps1' -Target 'C:\Users\uliano\dotfiles\Microsoft.PowerShell_profile.ps1'"

# SSH config ✅
sudo powershell -Command "New-Item -ItemType SymbolicLink -Path 'C:\Users\uliano\.ssh\config' -Target 'C:\Users\uliano\dotfiles\ssh_config'"
```

## Problemi Risolti
1. **Claude Code Bun crash** - Rimosso eseguibile nativo bacato (`C:\Users\uliano\.local\bin\claude.exe`)
2. **Logi Options** - Disinstallato vecchio, installato Logi Options+ (riavvio in corso per aggiornamento Windows)
3. **Profilo non caricato in pwsh (PowerShell Core 7.x)** - Creato symlink anche per PowerShell Core
   - Problema: PowerShell 5.x usa `WindowsPowerShell\`, PowerShell Core usa `PowerShell\`
   - Fix: Creati entrambi i symlink
4. **Alias eza non funzionanti** - Aggiunto esplicitamente WinGet Links al PATH
   - Problema: `C:\Users\uliano\AppData\Local\Microsoft\WinGet\Links` non veniva caricato nel profilo
   - Fix: Aggiunto controllo esplicito nel profilo PowerShell
5. **PSReadLine errors in shell non interattive** - Aggiunta gestione errori con try-catch
   - Problema: Predizioni PSReadLine fallivano quando eseguite da bash/cmd
   - Fix: Wrappato in try-catch con `-ErrorAction SilentlyContinue`

## Note
- Developer Mode è attivo ma la shell corrente non riconosce privilegi symlink
- Meglio usare PowerShell Admin per symlink
- Windows Update in corso: 25H2 (feature update) verrà installato domani
- GRUB configurato per bootare Windows di default durante aggiornamenti

## Prossimi Passi
1. ✅ ~~Aprire nuova PowerShell e creare symlink per starship.toml~~ - COMPLETATO
2. ✅ ~~Installare i tool rimanenti uno alla volta con conferma~~ - COMPLETATO
3. ✅ ~~Creare e configurare PowerShell profile~~ - COMPLETATO
4. ✅ ~~Creare symlink per SSH config~~ - COMPLETATO
5. **Testare l'ambiente** - Aprire una nuova finestra PowerShell/pwsh e verificare:
   - `python --version` → dovrebbe mostrare Python 3.13.7
   - `eza --version` → dovrebbe funzionare con alias `ls`, `ll`, ecc.
   - `fd --version` → disponibile come `find`
   - `fzf --version` → fuzzy finder
   - `rg --version` → ripgrep
   - `bat --version` → cat migliorato
   - `ssh -G xlence` → configurazione SSH dovrebbe funzionare
   - Starship prompt dovrebbe essere attivo e colorato
   - Alias personalizzati (`..`, `...`, `hist`, ecc.) dovrebbero funzionare

## Test Rapido
Aprire una nuova PowerShell e eseguire:
```powershell
# Verifica versioni
python --version
eza --version
fd --version
fzf --version
rg --version
bat --version
gh --version

# Test alias
ls  # dovrebbe usare eza
ll  # dovrebbe mostrare ls -la con eza
..  # dovrebbe tornare alla directory parent

# Test SSH config
ssh -G xlence  # dovrebbe mostrare config per xlence

# Autenticazione GitHub (opzionale)
gh auth login
```
