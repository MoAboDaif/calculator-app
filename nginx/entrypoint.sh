#!/usr/bin/env bash
set -euo pipefail

# nginx/entrypoint.sh
# Render nginx/nginx.conf.template using envsubst and ./.env, producing
# a rendered config by default at ./nginx/nginx.conf.rendered.
#
# Usage:
#   cd nginx
#   ./entrypoint.sh            # -> ./nginx/nginx.conf.rendered
#   ./entrypoint.sh /path/out  # -> writes to given path
#   ./entrypoint.sh --install  # -> writes to /etc/nginx/conf.d/default.conf (requires sudo)
#   ./entrypoint.sh --install /etc/nginx/sites-available/calculator.conf
#
# Notes:
# - envsubst (gettext) must be installed.
# - ./.env is loaded from repo root (one directory up from this script).
# - Installing system config requires sudo and may overwrite existing config.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"
TEMPLATE="${SCRIPT_DIR}/nginx.conf.template"
DEFAULT_OUT="${SCRIPT_DIR}/nginx.conf.rendered"

# parse args
INSTALL=false
OUT_PATH="${DEFAULT_OUT}"
if [ "${#}" -gt 0 ]; then
  case "$1" in
    --install)
      INSTALL=true
      if [ "${#}" -gt 1 ]; then
        OUT_PATH="${2}"
      else
        OUT_PATH="/etc/nginx/conf.d/default.conf"
      fi
      ;;
    *)
      OUT_PATH="${1}"
      ;;
  esac
fi

# Check envsubst
if ! command -v envsubst >/dev/null 2>&1; then
  echo "ERROR: envsubst not found. Install gettext (e.g. 'sudo apt-get install gettext' or 'brew install gettext')."
  exit 2
fi

# Load .env if present and export variables
if [ -f "${ENV_FILE}" ]; then
  echo "Loading environment variables from ${ENV_FILE}"
  set -a
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
  set +a
else
  echo "Warning: ${ENV_FILE} not found. envsubst will use existing environment variables."
fi

# Ensure template exists
if [ ! -f "${TEMPLATE}" ]; then
  echo "ERROR: nginx template not found at: ${TEMPLATE}"
  exit 3
fi

# If target path is system path and we are not root, render to a temp file first
if [ "${INSTALL}" = true ]; then
  # Render to a temporary file first
  TMP_OUT="$(mktemp /tmp/nginx.conf.rendered.XXXXXX)"
  echo "Rendering ${TEMPLATE} -> ${TMP_OUT}"
  envsubst < "${TEMPLATE}" > "${TMP_OUT}"
  echo "Rendered to temporary file ${TMP_OUT}"

  echo "Installing rendered config to ${OUT_PATH} (requires sudo)..."
  sudo mkdir -p "$(dirname "${OUT_PATH}")"
  sudo cp "${TMP_OUT}" "${OUT_PATH}"
  sudo chown root:root "${OUT_PATH}"
  rm -f "${TMP_OUT}"

  echo "Testing nginx configuration..."
  sudo nginx -t

  echo "Reloading nginx..."
  # Try systemctl reload, otherwise fallback to nginx -s reload
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl reload nginx || sudo nginx -s reload || true
  else
    sudo nginx -s reload || true
  fi

  echo "Installed and reloaded Nginx (if reload succeeded)."
else
  # Non-install: render to OUT_PATH (within repo)
  echo "Rendering ${TEMPLATE} -> ${OUT_PATH}"
  envsubst < "${TEMPLATE}" > "${OUT_PATH}"
  echo "Rendered nginx config at ${OUT_PATH}"
fi

cat <<EOF

Done.

- Rendered file: ${OUT_PATH}
- If you installed to /etc/nginx/conf.d/... check with:
    sudo nginx -t
    sudo systemctl reload nginx

- If you want to run nginx in the foreground (e.g., in a container), add:
    exec nginx -g "daemon off;"

EOF
