# Team Rules

Defines how we manage code, data, and experiments for reproducible, collaborative work.

---

## 1) Principles

1. **Data-centric** — code and structure exist to make data generation reproducible.
2. **exp for feasibility, dev for readability** — experiment on branches, refactor on `dev`.
3. **Tests are for data** — focus on shape, distributions, and key visualisations; keep records in `.ipynb`.
4. **Reuse, not redefine** — extract reusable logic into modules rather than duplicating it.

---

## 2) Repository Structure

```
myproj/
├── notebooks/          # Source .ipynb (outputs stripped by pre-commit)
├── test_notebooks/     # Test notebooks (DVC-controlled, outputs kept)
├── nbs/                # Paired .py files (percent format, for Git diff)
├── data/               # Datasets (DVC-tracked, Git-ignored)
├── reports/            # Metrics and plots (DVC-tracked)
├── scripts/            # Shell utilities
├── actionplan/         # Workflow diagrams, named by version (e.g. v0.1.0.md)
├── LAWS/               # Schema definitions (law_*.yaml) for artifacts and exports
├── export/             # Final artifacts for Jiazi ingestion (figures, tables, code, metadata)
├── etc/                # Miscellaneous config and auxiliary files
├── params.yaml         # Centralised experiment parameters
├── dvc.yaml            # Pipeline definition
├── experiment_log.md   # Log of completed experiments
├── pyproject.toml      # Project metadata and dependencies
├── .jupytext.toml      # ipynb ↔ py pairing config
├── .env                # Local environment variables (not committed)
└── .gitignore
```

---

## 3) Golden Rules

| What | Where |
|------|-------|
| Code | Git |
| Data & large outputs | DVC |
| Parameters | `params.yaml` |
| Packages | `pip install / uninstall` (auto-updates `requirements.txt`) |
| Experiments | `git checkout -b exp/<id>-<topic>` + DVC |
| Final artifacts (figures, tables, code, metadata) | `export/` |
| Artifact & export schemas | `LAWS/` |

---

## 4) Git Practices

**Branches**

| Branch | Purpose |
|--------|---------|
| `main` | Stable, reproducible. PR required, no direct push. |
| `dev` | Integration of validated experiments. |
| `exp/<id>-<topic>` | Active experiment (e.g. `exp/001-baseline`). |
| `feature/<scope>-<desc>` | Productionising a proven experiment. |
| `data/<dataset>-<change>` | Data ingestion / cleaning. |
| `spike/<topic>` | Throwaway prototype, may never merge. |
| `hotfix/<issue>` | Urgent fix off `main`. |

Flow: `spike/*` → `exp/*` → `feature/*` → `dev` → `main`

**Commit format:** `<type>(<scope>): <imperative summary ≤ 72 chars>`

| Type | Use |
|------|-----|
| `feat` | New feature or model |
| `fix` | Bug fix |
| `data` | Dataset changes |
| `exp` | Experiment config or result |
| `refactor` | Code restructure, no behaviour change |
| `docs` | Documentation only |
| `build` | Environment, dependencies, or build scripts |
| `chore` | Tooling / config / maintenance |

```
feat(model): add cosine LR scheduler
exp: 003 - grid search over regularisation strengths
data: add CMIP6 temperature 2000-2050
```

---

## 5) DVC Practices

```bash
dvc add data/raw/dataset.parquet
git add data/raw/dataset.parquet.dvc .gitignore
git commit -m "data: track dataset"
dvc push
```

- Always `dvc push` after updating data or artifacts.
- HPC shared cache (run once):
  ```bash
  dvc config cache.shared group
  dvc config cache.type hardlink,symlink
  ```

---

## 6) Notebook Rules

Every notebook must start with:

```python
import os
from dotenv import load_dotenv

load_dotenv()
os.chdir(os.getenv("PROJECT_ROOT"))
```

Import order: standard library → third-party → internal, each group alphabetically sorted.

```python
import os

import numpy as np

from myproj.utils import helper
```

---

## 7) Experiment Workflow

```bash
git checkout dev && git pull
git checkout -b exp/001-description

# work ...

dvc add <large outputs>
git add . && git commit -m "exp: 001 - description"
dvc push

git checkout dev && git merge exp/001-description
git push && dvc push
```

To revisit: `git checkout exp/001-description && dvc pull`

---

## 8) Environment Management

See `COMMANDS.md` for full setup instructions.

```bash
pip install <package>       # requirements.txt auto-updated
pip uninstall <package>     # same
```

---

## 9) Collaboration Rhythm

- **Start of session:** `git pull && dvc pull`
- **End of session:** `git push && dvc push`
- **Never** commit raw data, credentials, or `.env` to Git.

---

## 10) Versioning (`pyproject.toml`)

`major.minor.patch`

| Level | Trigger |
|-------|---------|
| Major | Breaks or invalidates existing downstream components |
| Minor | Adds new components without breaking existing ones |
| Patch | Incremental improvement within the current segment |

Update the version whenever an `actionplan/` file is modified.

---

## 11) Security

- Store secrets in `.env` only — never commit them.
- Restrict DVC remote access to the project group (`chmod g+rwX`).

---

## 12) Export & Jiazi Integration

The `export/` directory is the **sole interface** between this analysis repo and Jiazi (manuscript generation). All final artifacts must be placed here before handing off.

### Required structure

```
export/
├── figures/            # Final figures: figXX_description.png | .jpg
├── tables/             # Final tables:  TableX_description.xlsx
├── code/               # Minimal reproducible code
│   └── run_analysis.py # Must regenerate all exported figures and tables
├── configs/            # (optional) params.yaml, experiment_config.yaml
├── metadata/           # variable_dictionary.yaml, dataset_dictionary.yaml
└── actionbrief.yaml    # Core interface: datasets, variables, figures, tables, workflow
```

### Naming conventions

| Artifact | Pattern | Example |
|----------|---------|---------|
| Figure | `figXX_description.ext` | `fig01_global_distribution.png` |
| Table | `TableX_description.xlsx` | `Table1_DataSummary.xlsx` |

### actionbrief.yaml

Validated against `LAWS/law_actionbrief.yaml`. Required fields:

- `doc_type: actionbrief`
- `version`
- `datasetDictionary` — keyed dataset descriptors
- `variableDictionary` — keyed variable descriptors
- `tableDictionary` / `figureDictionary` — keyed artifact descriptors
- `analysisStructureBrief.levels` — ordered analytical levels (inputs → method → outputs → interpretation)

### Rules

- `export/` contains **only final artifacts** — no intermediate outputs.
- Every figure/table referenced in `actionbrief.yaml` must exist in `export/figures/` or `export/tables/`.
- `run_analysis.py` must reproduce all exported artifacts without notebook execution.
- Jiazi will never modify files inside `export/`.
- Schema definitions for validation live in `LAWS/` — do not edit them unless intentionally updating the law version.
