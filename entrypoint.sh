#!/bin/bash
# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be available
echo "Waiting for SQL Server to start..."
sleep 20  # or loop+check to wait for readiness

# Set variables
DB_NAME="HMS"
SA_PASSWORD="Sirajsql4041!"
BAK_FILE="/var/opt/mssql/backup/HMS.bak"

# Create backup folder if it doesn't exist
mkdir -p /var/opt/mssql/backup

# Copy the .bak file into the container (assuming it's baked into the image during build)
cp /HMS.bak $BAK_FILE

# Restore the database using sqlcmd
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" -Q "
RESTORE FILELISTONLY FROM DISK = N'$BAK_FILE';
RESTORE DATABASE [$DB_NAME]
FROM DISK = N'$BAK_FILE'
WITH MOVE '$DB_NAME' TO '/var/opt/mssql/data/$DB_NAME.mdf',
     MOVE '${DB_NAME}_log' TO '/var/opt/mssql/data/${DB_NAME}_log.ldf',
     REPLACE;
"

# Wait on sqlservr process
wait