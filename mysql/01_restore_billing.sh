#!/usr/bin/env bash
# =============================================================
# Scenario 2 · Task 2.2.1 — Restore MySQL server from a backup
# Downloads billingdata.sql and restores it onto the MySQL server.
# =============================================================
set -euo pipefail

BACKUP_URL="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0231EN-SkillsNetwork/labs/Final%20Assignment/billingdata.sql"
BACKUP_FILE="billingdata.sql"
MYSQL_USER="${MYSQL_USER:-root}"

echo "Downloading backup file..."
wget -q -O "${BACKUP_FILE}" "${BACKUP_URL}"

echo "Restoring backup onto MySQL server..."
mysql -u "${MYSQL_USER}" -p < "${BACKUP_FILE}"

echo "Restore completed."

# Alternative from inside the MySQL prompt:
#   mysql> SOURCE billingdata.sql;
