#!/usr/bin/env bash
# =============================================================
# Scenario 1 · Task 1.6 — Backup the tolldata database
#
# In the lab, this task was completed with the pgAdmin GUI:
#   Right-click tolldata → Backup… → Filename: tolldatabackup.tar
#   Format: Tar → Backup
#
# This script is the command-line equivalent of that operation.
# =============================================================
set -euo pipefail

DB_NAME="tolldata"
DB_USER="${PGUSER:-postgres}"
DB_HOST="${PGHOST:-localhost}"
OUTPUT_FILE="tolldatabackup.tar"

echo "Backing up '${DB_NAME}' to '${OUTPUT_FILE}' (Tar format)..."

pg_dump -U "${DB_USER}" -h "${DB_HOST}" -F t -f "${OUTPUT_FILE}" "${DB_NAME}"

echo "Backup completed: $(du -h "${OUTPUT_FILE}" | cut -f1)"

# To restore:
# pg_restore -U postgres -h localhost -d tolldata --clean --if-exists tolldatabackup.tar
