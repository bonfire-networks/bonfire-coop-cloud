#!/bin/bash

set -e

BACKUP_PATH="/var/lib/postgresql/data"
LATEST_BACKUP_FILE="${BACKUP_PATH}/backup.sql"

function backup {
  FILE_WITH_DATE="${BACKUP_PATH}/backup_$(date +%F).sql"
  
  if [ -f "$POSTGRES_PASSWORD_FILE" ]; then
    export PGPASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
  fi
  
  echo "Creating backup at ${FILE_WITH_DATE}..."
  pg_dump -U "${POSTGRES_USER:-postgres}" "${POSTGRES_DB:-postgres}" > "${FILE_WITH_DATE}"
  
  echo "Copying to ${LATEST_BACKUP_FILE}..."
  cp -f "${FILE_WITH_DATE}" "${LATEST_BACKUP_FILE}"
  
  echo "Backup done. You will find it at ${LATEST_BACKUP_FILE}"
}

function restore {
    echo "Restoring database from ${LATEST_BACKUP_FILE}..."

    cd ${BACKUP_PATH}
    
    function restore_config {
        echo "Restoring original pg_hba.conf configuration..."
        cat pg_hba.conf.bak > pg_hba.conf
        su postgres -c 'pg_ctl reload'
    }
    
    # Don't allow any other connections than local
    echo "Setting up temporary pg_hba.conf to only allow local connections..."
    cp pg_hba.conf pg_hba.conf.bak
    echo "local all all trust" > pg_hba.conf
    su postgres -c 'pg_ctl reload'
    trap restore_config EXIT INT TERM

    # Recreate Database
    echo "Dropping existing database ${POSTGRES_DB:-postgres}..."
    psql -U "${POSTGRES_USER:-postgres}" -d postgres -c "DROP DATABASE \"${POSTGRES_DB:-postgres}\" WITH (FORCE);" 
    
    echo "Creating fresh database ${POSTGRES_DB:-postgres}..."
    createdb -U "${POSTGRES_USER:-postgres}" "${POSTGRES_DB:-postgres}"
    
    echo "Restoring data from ${LATEST_BACKUP_FILE}..."
    psql -U "${POSTGRES_USER:-postgres}" -d "${POSTGRES_DB:-postgres}" -1 -f "${LATEST_BACKUP_FILE}"

    trap - EXIT INT TERM
    restore_config
    
    echo "Database restore completed successfully."
}

# Execute the function passed as argument
case "$1" in
  backup)
    backup
    ;;
  restore)
    restore
    ;;
  *)
    echo "Usage: $0 {backup|restore}"
    exit 1
    ;;
esac