set -euo pipefail

PGHOST="${PGHOST:-localhost}"
PGPORT="${PGPORT:-5432}"
PGUSER="${PGUSER:-admin}"
PGDATABASE="${PGDATABASE:-hotel}"
export PGPASSWORD="${PGPASSWORD:-password}"

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/backups"
mkdir -p "$BACKUP_DIR"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_FILE="${BACKUP_DIR}/backup_${TIMESTAMP}.sql"

echo "Backing up database '${PGDATABASE}' from ${PGHOST}:${PGPORT} ..."

pg_dump \
  --host="$PGHOST" \
  --port="$PGPORT" \
  --username="$PGUSER" \
  --dbname="$PGDATABASE" \
  --format=plain \
  --no-owner \
  --file="$BACKUP_FILE"

echo "Backup complete: ${BACKUP_FILE}"