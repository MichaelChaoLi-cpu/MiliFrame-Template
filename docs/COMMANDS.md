# Commands Handbook

Reference for setting up and maintaining a MiliFrame project.
Run all commands from the **project root** unless stated otherwise.

---

## Chapter 1 — Initialization (do once per project)

### 1.1 Clone the template and rename

```bash
export myproj=YOUR_PROJECT_NAME

git clone https://github.com/MichaelChaoLi-cpu/MiliFrame-Template.git
mv MiliFrame-Template $myproj
cd $myproj

git remote rename origin upstream
```

### 1.2 Link to your own repository

```bash
export REPO_ADD_in_GITHUB=https://<token>@github.com/<user>/<repo>.git

git remote add origin $REPO_ADD_in_GITHUB
git push -u origin main
```

### 1.3 Set up environment variables (.env)

The `.env` file is loaded by every script and is **never committed to git**.

```bash
echo -n > .env
echo "myproj=$myproj"          >> .env
echo "PROJECT_ROOT=$(pwd)"     >> .env

# Load into current shell to verify
set -a && source .env && set +a
cat .env
```

Expected `.env` content:
```
myproj=YOUR_PROJECT_NAME
PROJECT_ROOT=/absolute/path/to/your/project
```

### 1.4 Install Python dependencies

uv reads `pyproject.toml` and `uv.lock` to install exact versions into `.venv`.

```bash
uv sync
pre-commit install
```

### 1.5 Initialize DVC and configure remote storage

```bash
dvc init
```

HPC:
```bash
dvc remote add -d hpc /home/<group>/share/dvc_remote
```

Local (another folder):
```bash
dvc remote add -d local /path/to/your/data/store
```

---

## Chapter 2 — Maintenance (day-to-day)

### 2.1 Start a new session (joining an existing project)

```bash
source .venv/bin/activate
set -a && source .env && set +a
dvc pull                        # fetch latest data/artifacts
```

### 2.2 Package management

```bash
uv add <package>                # updates pyproject.toml and uv.lock
uv remove <package>             # same
```

### 2.3 Run an experiment

Experiments are versioned entirely through **git branches + DVC**.

**Start:**
```bash
git checkout dev && git pull
git checkout -b exp/<id>-<short-description>   # e.g. exp/001-baseline-model
```

**Work and commit:**
```bash
# Edit scripts in src/ ...

dvc add data/processed/my_output.csv           # track large outputs with DVC
git add data/processed/my_output.csv.dvc src/
git commit -m "exp: 001 - baseline model"
dvc push
```

**Close — merge back to dev:**
```bash
git checkout dev
git merge exp/001-baseline-model
git push && dvc push
```

**Revisit a past experiment:**
```bash
git checkout exp/001-baseline-model
dvc pull                                        # restores data/artifacts for that run
```

### 2.4 DVC — track data and push/pull

```bash
dvc add data/raw/my_dataset.csv
git add data/raw/my_dataset.csv.dvc .gitignore
git commit -m "data: track my_dataset"

dvc push                        # upload to remote
dvc pull                        # download from remote
dvc repro                       # re-run pipeline if dvc.yaml is configured
```

### 2.5 Git commit conventions

| Prefix | Use |
|--------|-----|
| `feat` | new feature |
| `fix` | bug fix |
| `data` | dataset changes |
| `exp` | experiment result |
| `docs` | documentation |
| `refactor` | code restructure |
| `build` | Environment, dependencies, or build scripts |
| `chore` | tooling / config |

### 2.6 HPC (SLURM) — placeholder

```bash
# Add your cluster-specific sbatch commands here
```
