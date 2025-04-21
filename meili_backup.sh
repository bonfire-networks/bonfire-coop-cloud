#!/bin/bash

set -e

BACKUP_FILE='/var/lib/postgresql/data/backup.sql'

function backup {
  export SECRET=$(cat /run/secrets/meili_master_key)
  // pre-hook command for compose.meilisearch.yml 
  TASK_UID=$(curl -s -X POST 'http://localhost:7700/dumps' -H 'Authorization: Bearer $SECRET' | grep -o '\"uid\":[0-9]*' | cut -d':' -f2) && \
  echo "Waiting for dump creation (task $TASK_UID)..." && \
  MAX_ATTEMPTS=600 && \
  ATTEMPT=0 && \
  while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do \
    TASK_STATUS=$(curl -s "http://localhost:7700/tasks/$TASK_UID" -H "Authorization: Bearer $SECRET" | grep -o '\"status\":\"[^\"]*\"' | cut -d':' -f2 | tr -d '\"'); \
    if [ "$TASK_STATUS" = "succeeded" ]; then \
      echo "Dump creation succeeded" && \
      break; \
    elif [ "$TASK_STATUS" = "enqueued" ] || [ "$TASK_STATUS" = "processing" ]; then \
      echo "Dump creation in progress... ($TASK_STATUS)" && \
      ATTEMPT=$((ATTEMPT+1)) && \
      sleep 2; \
    else \
      echo "Dump creation in unexpected state: $TASK_STATUS" && \
      exit 1; \
    fi; \
  done && \
  if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then \
    echo "Timed out waiting for dump creation" && \
    exit 1; \
  fi && \
  DUMP_UID=$(curl -s "http://localhost:7700/tasks/$TASK_UID" -H "Authorization: Bearer $SECRET" | grep -o '\"dumpUid\":\"[^\"]*\"' | cut -d':' -f2 | tr -d '\"') && \
  echo "Using dump $DUMP_UID" && \
  cp "/meili_dumps/$DUMP_UID.dump" "/meili_dumps/meilisearch_latest.dump" && \
  echo "Dump created and copied successfully"
}

function restore {
    echo 'Restarting Meilisearch with imported dump, may take a while to become available...' 
    pkill meilisearch 
    MEILI_NO_ANALYTICS=true /bin/meilisearch --import-dump /meili_dumps/meilisearch_latest.dump &
}

$@
