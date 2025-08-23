#!/usr/bin/env bash
set -euo pipefail

# Config
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
PROJECT_DIR="${1:-$PWD}"           # pass a project path as first arg or defaults to current directory
VENV_DIR="${PROJECT_DIR}/.venv"

echo "==> Project directory: ${PROJECT_DIR}"
echo "==> Dotfiles directory: ${DOTFILES_DIR}"

# 1) Ensure pipx is available (won't install system packages here)
if ! command -v pipx >/dev/null 2>&1; then
  echo "!! pipx not found. Install with your package manager (e.g., sudo pacman -S python-pipx) and rerun."
  exit 1
fi

echo "==> Ensuring pipx path (you may need to reload your shell after this)"
pipx ensurepath || true

# 2) Create per-project venv and install base packages
echo "==> Creating venv at: ${VENV_DIR}"
python -m venv "${VENV_DIR}"
# shellcheck disable=SC1090
source "${VENV_DIR}/bin/activate"
python -m pip install -U pip wheel
python -m pip install requests debugpy

echo "==> Venv ready. Use:"
echo "    source \"${VENV_DIR}/bin/activate\" && nvim"

# 3) Optional: Auto-activation via direnv
if command -v direnv >/dev/null 2>&1; then
  if [ ! -f "${PROJECT_DIR}/.envrc" ]; then
    echo "==> Creating .envrc for direnv auto-activation"
    cat > "${PROJECT_DIR}/.envrc" <<EOF
# Auto-activate project venv
if [ -d ".venv" ]; then
  layout python3
fi
EOF
    (cd "${PROJECT_DIR}" && direnv allow) || true
  fi
else
  echo "==> direnv not found. Optional: sudo pacman -S direnv; then add 'eval \"\$(direnv hook zsh)\"' to your shell rc."
fi

# 4) History rewrite: scrub leaked API keys from ~/.dotfiles
if [ ! -d "${DOTFILES_DIR}/.git" ]; then
  echo "!! ${DOTFILES_DIR} is not a git repo; skipping secret purge."
else
  if ! command -v git-filter-repo >/dev/null 2>&1; then
    echo "!! git-filter-repo not found. Install via 'sudo pacman -S git-filter-repo' or 'pipx install git-filter-repo' and rerun."
    deactivate || true
    exit 1
  fi

  echo "==> Preparing secret removal (OPENAI_API_KEY / GOOGLE_API_KEY patterns)"
  TMP_REPL=$(mktemp)
  cat > "${TMP_REPL}" << 'EOF'
regex:OPENAI_API_KEY\s*=\s*"[^\"]*"=>OPENAI_API_KEY=""
regex:GOOGLE_API_KEY\s*=\s*"[^\"]*"=>GOOGLE_API_KEY=""
EOF

  echo "==> Rewriting git history in ${DOTFILES_DIR} (this will force-push)"
  (
    cd "${DOTFILES_DIR}"
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "!! Not a git repo"; exit 1; }
    git filter-repo --replace-text "${TMP_REPL}"
    rm -f "${TMP_REPL}"

    echo "==> Force-pushing rewritten history (all refs and tags)"
    git push --force --all
    git push --force --tags

    echo "==> Cleaning local refs"
    git reflog expire --expire=now --all || true
    git gc --prune=now --aggressive || true
  )

  echo "==> Done. If GitHub still blocks due to cached detection, follow the unblock link only AFTER rotation and rewrite."
fi

echo "==> All done."
echo "Notes:"
echo " - Run: source ~/.zshrc or exec zsh to refresh your PATH for pipx."
echo " - Activate venv before opening nvim: source \"${VENV_DIR}/bin/activate\" && nvim"