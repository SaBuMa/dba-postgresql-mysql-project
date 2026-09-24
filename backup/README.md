# 💾 Backup Artifacts

This folder is reserved for the `tolldatabackup.tar` file produced in **Task 1.6** (Tar-format backup of the `tolldata` PostgreSQL database).

Backup files are excluded from version control via `.gitignore`, since database dumps can be large and may contain data that shouldn't be published. To regenerate the backup, run:

```bash
bash postgresql/03_backup_tolldata.sh
```

To restore it:

```bash
pg_restore -U postgres -h localhost -d tolldata --clean --if-exists tolldatabackup.tar
```
