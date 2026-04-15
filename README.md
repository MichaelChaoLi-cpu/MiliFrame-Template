# [Project Name]

> Replace with your project description.

---

## Structure

```
myproj/
├── src/           # Python scripts; experimental *.ipynb allowed but not tracked
├── data/          # Datasets and reports — DVC-tracked, Git-ignored
├── etc/           # Shell utilities
├── docs/          # Documentation (TEAM_RULES, COMMANDS, SOP, etc.)
├── export/        # Final artifacts for Jiazi (figures, tables, code, metadata)
├── pyproject.toml
└── requirements.txt
```

---

## Setup (once per project)

```bash
# 1. Clone and rename
export myproj=YOUR_PROJECT_NAME
git clone https://github.com/MichaelChaoLi-cpu/MiliFrame-Template.git
mv MiliFrame-Template $myproj && cd $myproj
git remote rename origin upstream

# 2. Link to your own repo
git remote add origin https://<token>@github.com/<user>/<repo>.git
git push -u origin main

# 3. Create .env
echo "myproj=$myproj"       > .env
echo "PROJECT_ROOT=$(pwd)" >> .env
echo "PYTHON_VERSION=3.12" >> .env

# 4. Create conda environment
conda create -n $myproj python=3.12 -y && conda activate $myproj

# 5. Install dependencies
pip install -r requirements.txt
pip install pre-commit dvc
pre-commit install

# 6. Install pip auto-freeze hook
chmod +x etc/setup_conda_hooks.sh && ./etc/setup_conda_hooks.sh
conda activate $myproj        # re-activate to apply hook

# 7. Initialize DVC
dvc init
dvc remote add -d <name> <path>   # HPC: /home/<group>/share/dvc_remote
```

---

## Daily Workflow

```bash
# Start session
conda activate $myproj
set -a && source .env && set +a
git pull && dvc pull

# Work on an experiment
git checkout dev && git pull
git checkout -b exp/001-description
# ... edit scripts in src/ ...
dvc add data/<large-outputs>
git add . && git commit -m "exp: 001 - description"
dvc push
git checkout dev && git merge exp/001-description
git push && dvc push
```

---

## Export for Jiazi

Place final artifacts in `export/` following `docs/LAWS/law_export_folder.yaml`.
Include `export/actionbrief.yaml` validated against `docs/LAWS/law_actionbrief.yaml`.

```
export/
├── figures/          # figXX_description.png
├── tables/           # TableX_description.xlsx
├── code/
│   └── run_analysis.py
├── metadata/
└── actionbrief.yaml
```

---

See `docs/TEAM_RULES.md` for full conventions and `docs/COMMANDS.md` for detailed commands.
