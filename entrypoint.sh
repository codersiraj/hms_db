#!/bin/bash

set -e

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

echo "⏳ Waiting for SQL Server to start..."
sleep 20

DB_NAME="HMS"
SA_PASSWORD="Sirajsql4041!"
BAK_FILE="/usr/src/app/HMS.bak"

if [ ! -f "$BAK_FILE" ]; then
  echo "❌ Backup file not found: $BAK_FILE"
  exit 1
fi

echo "🔄 Starting restore of $DB_NAME from $BAK_FILE"

# Get logical file names
FILELIST=$(/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" \
  -Q "RESTORE FILELISTONLY FROM DISK = N'$BAK_FILE'" -s"|" -W)

DATA_LOGICAL=$(echo "$FILELIST" | sed -n '2p' | cut -d'|' -f1 | xargs)
LOG_LOGICAL=$(echo "$FILELIST" | sed -n '3p' | cut -d'|' -f1 | xargs)

echo "📁 Logical Data: $DATA_LOGICAL"
echo "📁 Logical Log: $LOG_LOGICAL"

if [ -z "$DATA_LOGICAL" ] || [ -z "$LOG_LOGICAL" ]; then
  echo "❌ Could not extract logical file names."
  exit 1
fi

# Perform the restore
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "
RESTORE DATABASE [$DB_NAME]
FROM DISK = N'$BAK_FILE'
WITH MOVE '$DATA_LOGICAL' TO '/var/opt/mssql/data/$DB_NAME.mdf',
MOVE '$LOG_LOGICAL' TO '/var/opt/mssql/data/$DB_NAME.ldf',
REPLACE;
"

echo "✅ Restore complete. Waiting for SQL Server..."
wait
