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

The `.env` file is loaded by every notebook and is **never committed to git**.

```bash
echo -n > .env
echo "myproj=$myproj"          >> .env
echo "PROJECT_ROOT=$(pwd)"     >> .env
echo "PYTHON_VERSION=3.12"     >> .env   # change if you need a different version

# Load into current shell to verify
set -a && source .env && set +a
cat .env
```

Expected `.env` content:
```
myproj=YOUR_PROJECT_NAME
PROJECT_ROOT=/absolute/path/to/your/project
PYTHON_VERSION=3.12
```

### 1.4 Create the conda environment (Python 3.12)

```bash
# If variables are not set in your current shell, reload them first:
set -a && source .env && set +a

conda create -n $myproj python=${PYTHON_VERSION:-3.12} -y
conda activate $myproj
```

> If the project ships a pre-built `environment.yml`, use
> `conda env create -f environment.yml` instead.

### 1.5 Install Python dependencies

```bash
pip install -r requirements.txt
pip install jupytext nbconvert nbformat pre-commit dvc
pre-commit install
```

### 1.6 Install the pip auto-freeze hook (once per conda env)

This makes every `pip install / uninstall / upgrade` in your terminal
automatically update `requirements.txt`.

```bash
chmod +x ./scripts/setup_conda_hooks.sh
./scripts/setup_conda_hooks.sh
conda activate $myproj          # re-activate to apply the hook
type pip                        # should print: pip is a shell function
```

### 1.7 Initialize DVC and configure remote storage

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
conda activate $myproj
set -a && source .env && set +a
dvc pull                        # fetch latest data/artifacts
```

### 2.2 Package management

```bash
pip install <package>           # requirements.txt auto-updated by hook
pip uninstall <package>         # same
```

To manually sync if the hook was not active:
```bash
./scripts/update_env.sh
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
# Edit notebooks, scripts, params.yaml ...

dvc add data/processed/my_output.csv           # track large outputs with DVC
git add data/processed/my_output.csv.dvc params.yaml notebooks/
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
dvc repro                       # re-run pipeline (dvc.yaml)
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
