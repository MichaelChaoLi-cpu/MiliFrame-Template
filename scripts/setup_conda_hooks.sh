#!/bin/bash
# ============================================================
# Script: setup_conda_hooks.sh
# Purpose: Install pip wrapper hook into the active conda env.
#          Run once after: conda activate <your_env_name>
# ============================================================

set -e

if [ -z "$CONDA_PREFIX" ] || [ "$CONDA_DEFAULT_ENV" = "base" ]; then
    echo "Error: Please activate your project conda environment first."
    echo "  conda activate <your_env_name>"
    exit 1
fi

ACTIVATE_DIR="$CONDA_PREFIX/etc/conda/activate.d"
DEACTIVATE_DIR="$CONDA_PREFIX/etc/conda/deactivate.d"

mkdir -p "$ACTIVATE_DIR" "$DEACTIVATE_DIR"

# ---------- activate hook ----------
cat > "$ACTIVATE_DIR/pip_hook.sh" << 'EOF'
# Auto-update requirements.txt after pip install / uninstall / upgrade
pip() {
    command pip "$@"
    local _exit=$?
    case "$1" in
        install|uninstall|upgrade)
            if [ "$_exit" -eq 0 ] && [ -f "pyproject.toml" ]; then
                command pip freeze > requirements.txt
                echo "[pip-hook] requirements.txt updated"
            fi
            ;;
    esac
    return $_exit
}
EOF

# ---------- deactivate hook (cleanup) ----------
cat > "$DEACTIVATE_DIR/pip_hook.sh" << 'EOF'
unset -f pip 2>/dev/null || true
EOF

echo ">>> Hooks installed for environment: $CONDA_DEFAULT_ENV"
echo ">>> Re-activate to apply:"
echo "    conda activate $CONDA_DEFAULT_ENV"
