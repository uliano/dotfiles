# Windows Development Environment Setup

> **⚠️ Aggiornamento giugno 2026 — Python ora con uv:** su QUESTA macchina la gestione di Python è passata da **pyenv-win a uv** (vedi [Python con uv (giugno 2026)](#python-con-uv-giugno-2026) in fondo). La sezione **pyenv-win** più sotto è tenuta come **riferimento storico** e descrive il setup ancora in uso sull'**altra macchina Windows**.

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

2. **pyenv-win** (v3.1.1) - Gestione versioni Python  *(⚠️ su questa macchina sostituito da uv — vedi nota in cima e sezione "Python con uv"; resta valido per l'altra macchina Windows)*
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

---

## Python con uv (giugno 2026)

**Variante a pyenv-win adottata su QUESTA macchina.** La sezione *pyenv-win* sopra resta valida per l'altra macchina Windows; qui la sostituisce uv.

**Perché uv:** un solo binario (Rust) che rimpiazza pyenv + venv + pip + pipx, senza il bloat di conda. Nativo su Windows (niente shim/PATH gymnastics come pyenv-win), molto veloce.

### Installazione
```bash
winget install --id astral-sh.uv          # uv finisce in WinGet\Links (sul PATH)
uv python install 3.14 --default           # CPython 3.14 + python/python3 "nudi" in ~/.local/bin
uv python pin --global 3.14                # versione di default a livello utente
```

### Ambiente "globale" di default (effetto pyenv-global)
- venv dedicato, **non** attivato: `uv venv --python 3.14 ~/.venvs/py314`
- nel profilo PowerShell `~/.venvs/py314/Scripts` è prepeso **in fondo** alla sezione PATH (così vince su tutto) → `python`/`pip`/`jupyter`/… risolvono lì scavalcando lo stub del Microsoft Store
- è **solo-PATH** (niente `VIRTUAL_ENV`) → starship non mostra il nome ambiente fuori dai progetti python

#### ⚠️ Installare nel default: usare `pip`, NON `uv pip` (lezione appresa)
**`uv pip` NON scopre l'ambiente dal PATH.** Anche se `python` risolve a py314 via PATH, `uv pip install <pkg>` *senza flag* installa nel Python **gestito da uv** (`AppData\Roaming\uv\python\…`), NON in py314 — uv non seleziona mai da solo un venv che sta solo sul PATH e non è attivato. Per centrare py314 con uv serve **sempre** `--python ~/.venvs/py314`.

Soluzione adottata per avere il default "alla pyenv-global" senza flag e con prompt pulito: **installare `pip` dentro py314 una volta sola**, poi usare `pip` nudo (risolto dal PATH → `pip` installa sempre nel proprio env, cioè py314):
```bash
uv pip install --python ~/.venvs/py314 pip   # UNA TANTUM, subito dopo aver creato il venv
pip install <pkg…>                            # poi: installa in py314, senza flag
```
Dove finisce il pacchetto è leggibile dal prompt starship:
- `🐍v3.14.6` (senza parentesi) → default **py314**
- `🐍v3.14.6 (.venv)` → venv di progetto **attivato**

I pacchetti del default sono in `python_packages_installed.txt` (numpy, torch CPU, rdkit, markitdown, …); installali con `pip install …` (oppure `uv pip install --python ~/.venvs/py314 …`).

#### False piste scartate (NON rifarle sull'altra macchina)
- **`UV_PYTHON=~/.venvs/py314` nel profilo** → ha priorità su tutto: `uv pip` punta a py314 **anche dentro un progetto col venv ATTIVATO** → rompe il lavoro per-progetto. ❌
- **`VIRTUAL_ENV=~/.venvs/py314` nel profilo** → uv lo rispetta, ma starship mostra `🐍 (py314)` in **ogni** cartella (il modulo python si attiva sul venv attivo) → prompt sporco. ❌
- **`python-preference=system` (`UV_PYTHON_PREFERENCE=system`)** → uv continua a preferire il suo Python gestito, non py314. ❌

### Per-progetto
`uv venv` (+ `uv python pin <ver>` per una versione diversa) → **da attivato** ha la precedenza sul default (lo vedi: compare `(.venv)` nel prompt).

### Tool che non supportano l'ultimo Python (es. marker-pdf)
marker-pdf vincola pillow 10.4.0, **senza wheel per Python 3.14 su Windows** → isolato in un suo ambiente:
```bash
uv tool install --python 3.12 marker-pdf   # comandi marker / marker_gui / … in ~/.local/bin
```

### Mappatura pyenv → uv
| pyenv | uv |
|---|---|
| `pyenv install 3.12` | `uv python install 3.12` |
| `pyenv global 3.14` | `uv python pin --global 3.14` (+ `--default` per `python` nudo) |
| `pyenv local 3.11` | `uv python pin 3.11` |
| `pyenv shell 3.12` | `$env:UV_PYTHON='3.12'` oppure `uv run --python 3.12 …` |
| `pyenv versions` | `uv python list` |

### Stub Microsoft Store
`…\WindowsApps\python.exe` è un alias da 0 byte che apre lo Store. Neutralizzato dal prepend del venv sul PATH; in alternativa si spegne in *Impostazioni → App → Impostazioni avanzate app → Alias di esecuzione app*.
