#!/usr/bin/env bash
set -euo pipefail

# database/init-db.sh
# Renders init.sql.template and seed.sql.template -> init.sql and seed.sql
# Automatically loads variables from the repository root .env (if present).
#
# Usage:
#   cd database
#   ../database/init-db.sh
#   # or from repo root:
#   ./database/init-db.sh
#
# Output:
#   ./database/init.sql
#   ./database/seed.sql  (if seed template exists)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ENV_FILE="${REPO_ROOT}/.env"

# Templates and outputs
TEMPLATE_INIT="${SCRIPT_DIR}/init.sql.template"
TEMPLATE_SEED="${SCRIPT_DIR}/seed.sql.template"
OUT_INIT="${SCRIPT_DIR}/init.sql"
OUT_SEED="${SCRIPT_DIR}/seed.sql"

# Check for envsubst (gettext)
if ! command -v envsubst >/dev/null 2>&1; then
  echo "ERROR: envsubst not found. Install gettext (e.g. 'sudo apt-get install gettext' or 'brew install gettext')."
  exit 2
fi

# Load .env if present and export variables
if [ -f "${ENV_FILE}" ]; then
  echo "Loading environment variables from ${ENV_FILE}"
  # export variables defined in .env for envsubst to use
  set -a
  # shellcheck disable=SC1090
  . "${ENV_FILE}"
  set +a
else
  echo "Warning: ${ENV_FILE} not found. envsubst will use existing environment variables."
fi

# Ensure templates exist
if [ ! -f "${TEMPLATE_INIT}" ]; then
  echo "ERROR: Template not found: ${TEMPLATE_INIT}"
  exit 3
fi

# Render init.sql
echo "Rendering ${TEMPLATE_INIT} -> ${OUT_INIT}"
envsubst < "${TEMPLATE_INIT}" > "${OUT_INIT}"
echo "Wrote ${OUT_INIT}"

# Render seed.sql if template exists
if [ -f "${TEMPLATE_SEED}" ]; then
  echo "Rendering ${TEMPLATE_SEED} -> ${OUT_SEED}"
  envsubst < "${TEMPLATE_SEED}" > "${OUT_SEED}"
  echo "Wrote ${OUT_SEED}"
else
  echo "No seed template found at ${TEMPLATE_SEED} — skipping seed generation."
fi

cat <<EOF

Done.

Next steps (example):

# From repository root (or adjust paths if you are elsewhere)
mysql -u root -p < database/init.sql

# optionally:
mysql -u root -p < database/seed.sql

If you do not have root access, run the CREATE USER / GRANT statements in database/init.sql
with an account that has the necessary privileges, or ask your DBA.

EOF
