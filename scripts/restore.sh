set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path-to-backup.sql>"
  exit 1
fi

BACKUP_FILE="$1"

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Error: backup file '${BACKUP_FILE}' not found."
  exit 1
fi

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-admin}"
PGDATABASE="${PGDATABASE:-hotel}"
export PGPASSWORD="${PGPASSWORD:-password}"

echo "Restoring '${BACKUP_FILE}' into database '${PGDATABASE}' on ${PGHOST}:${PGPORT}"
read -r -p "This will DROP the existing '${PGDATABASE}' database. Continue? [y/N] " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

echo "1/3 Dropping database (if exists) ..."
psql --host="$PGHOST" --port="$PGPORT" --username="$PGUSER" --dbname=postgres \
  -c "DROP DATABASE IF EXISTS ${PGDATABASE};"

echo "2/3 Creating database ..."
psql --host="$PGHOST" --port="$PGPORT" --username="$PGUSER" --dbname=postgres \
  -c "CREATE DATABASE ${PGDATABASE};"

echo "3/3 Restoring from backup ..."
psql --host="$PGHOST" --port="$PGPORT" --username="$PGUSER" --dbname="$PGDATABASE" \
  -f "$BACKUP_FILE"

echo "Restore complete."