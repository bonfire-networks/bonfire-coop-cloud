#!/bin/bash

set -e

BACKUP_PATH='/var/lib/postgresql/data'
LATEST_BACKUP_FILE='$BACKUP_PATH/backup.sql'

function backup {
  export FILE_WITH_DATE='$BACKUP_PATH/backup_`date +%F`.sql'
  export PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
  pg_dump -U ${POSTGRES_USER} ${POSTGRES_DB} > $FILE_WITH_DATE
  cp -f $FILE_WITH_DATE $LATEST_BACKUP_FILE
}

function restore {
    cd /var/lib/postgresql/data/
    restore_config(){
        # Restore allowed connections
        cat pg_hba.conf.bak > pg_hba.conf
        su postgres -c 'pg_ctl reload'
    }
    # Don't allow any other connections than local
    cp pg_hba.conf pg_hba.conf.bak
    echo "local all all trust" > pg_hba.conf
    su postgres -c 'pg_ctl reload'
    trap restore_config EXIT INT TERM

    # Recreate Database
    psql -U ${POSTGRES_USER} -d postgres -c "DROP DATABASE ${POSTGRES_DB} WITH (FORCE);" 
    createdb -U ${POSTGRES_USER} ${POSTGRES_DB}
    psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -1 -f $LATEST_BACKUP_FILE

    trap - EXIT INT TERM
    restore_config
}

$@
