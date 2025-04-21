#!/bin/sh

set -e

backup() {
  SECRET=$(cat /run/secrets/meili_master_key)
  # Create dump
  echo "Creating new Meilisearch dump..."
  RESPONSE=$(curl -s -X POST 'http://localhost:7700/dumps' -H "Authorization: Bearer $SECRET")
  echo "Response: $RESPONSE"
  
  # More robust extraction of task UID
  TASK_UID=$(echo "$RESPONSE" | sed -n 's/.*"taskUid":\([0-9]*\).*/\1/p')
  
  if [ -z "$TASK_UID" ]; then
    echo "Failed to extract task UID from response. Aborting."
    exit 1
  fi
  
  echo "Waiting for dump creation (task $TASK_UID)..."
  
  MAX_ATTEMPTS=600
  ATTEMPT=0
  while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    RESPONSE=$(curl -s "http://localhost:7700/tasks/$TASK_UID" -H "Authorization: Bearer $SECRET")
    echo "Task status response: $RESPONSE"
    
    TASK_STATUS=$(echo "$RESPONSE" | sed -n 's/.*"status":"\([^"]*\)".*/\1/p')
    
    if [ -z "$TASK_STATUS" ]; then
      echo "Failed to extract task status. Retrying..."
      ATTEMPT=$((ATTEMPT+1))
      sleep 5
      continue
    fi
    
    echo "Current status: $TASK_STATUS"
    
    if [ "$TASK_STATUS" = "succeeded" ]; then
      echo "Dump creation succeeded"
      break
    elif [ "$TASK_STATUS" = "enqueued" ] || [ "$TASK_STATUS" = "processing" ]; then
      echo "Dump creation in progress... ($TASK_STATUS)"
      ATTEMPT=$((ATTEMPT+1))
      sleep 5
    else
      echo "Dump creation in unexpected state: $TASK_STATUS. Giving up."
      exit 1
    fi
  done
  
  if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    echo "Timed out waiting for dump creation"
    exit 1
  fi
  
  # Extract dump UID more reliably
  DUMP_UID=$(echo "$RESPONSE" | sed -n 's/.*"dumpUid":"\([^"]*\)".*/\1/p')
  
  if [ -z "$DUMP_UID" ]; then
    echo "Failed to extract dump UID. Aborting."
    exit 1
  fi
  
  echo "Using dump $DUMP_UID"
  
  # Check if file exists before copying
  if [ ! -f "/meili_dumps/$DUMP_UID.dump" ]; then
    echo "Dump file /meili_dumps/$DUMP_UID.dump not found!"
    ls -la /meili_dumps/
    exit 1
  fi
  
  cp -f "/meili_dumps/$DUMP_UID.dump" "/meili_dumps/meilisearch_latest.dump"
  echo "Dump created and copied successfully. You can find it at /meili_dumps/meilisearch_latest.dump"
}

restore() {
  echo 'Restarting Meilisearch with imported dump, may take a while to become available...'
  
  # Check if dump file exists
  if [ ! -f "/meili_dumps/meilisearch_latest.dump" ]; then
    echo "Error: Dump file not found at /meili_dumps/meilisearch_latest.dump"
    exit 1
  fi
  
  pkill meilisearch || echo "No Meilisearch process found to kill"

  echo "Starting Meilisearch with import dump option..."
  MEILI_NO_ANALYTICS=true /bin/meilisearch --import-dump /meili_dumps/meilisearch_latest.dump &
  
  echo "Meilisearch restore process initiated..."
}

# Handle command line argument
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