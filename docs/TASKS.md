# 📋 Task Walkthrough

A step-by-step record of every task in the project, the command used, and what it accomplishes.

---

## Scenario 1 — PostgreSQL

**Objectives:** Installation/Provisioning · Configuration · User Management · Backup
**Tools:** `psql` (PostgreSQL CLI), pgAdmin

### Task 1.1 — Find the settings in PostgreSQL
**Goal:** Determine the maximum number of concurrent connections the server allows.

```sql
SHOW max_connections;
```

`max_connections` caps the number of simultaneous client sessions. Each connection consumes server memory, so DBAs check this value when planning capacity or diagnosing "too many connections" errors.

📸 `screenshots/1.1_max_connections.png`

### Task 1.2 — Create a user
```sql
CREATE USER backup_operator;
```
`CREATE USER` is equivalent to `CREATE ROLE ... LOGIN` — it creates a role that is allowed to log in.

📸 `screenshots/1.2_create_user.png`

### Task 1.3 — Create a role
```sql
CREATE ROLE backup;
```
A role without `LOGIN` acts as a **group** that bundles privileges.

📸 `screenshots/1.3_create_role.png`

### Task 1.4 — Grant privileges to the role
```sql
GRANT CONNECT ON DATABASE tolldata TO backup;
GRANT SELECT ON ALL TABLES IN SCHEMA toll TO backup;
```
The role receives only what a backup operator needs: the ability to connect and to **read** data. No write privileges are granted (principle of least privilege).

📸 `screenshots/1.4_grant_privileges.png`

### Task 1.5 — Grant role to a user
```sql
GRANT backup TO backup_operator;
```
`backup_operator` inherits every privilege held by `backup`.

📸 `screenshots/1.5_grant_role.png`

### Task 1.6 — Backup a database (pgAdmin)
**Steps in pgAdmin:**
1. Right-click the `tolldata` database → **Backup…**
2. Filename: `tolldatabackup.tar`
3. Format: **Tar**
4. Click **Backup** and confirm the success notification

CLI equivalent:
```bash
pg_dump -U postgres -h localhost -F t -f tolldatabackup.tar tolldata
```

📸 `screenshots/1.6_backup_tolldata.png`

---

## Scenario 2 — MySQL

**Objectives:** Installing/Provisioning · Configuration · Recovery · Indexing · Storage Engines · Automation of routine tasks
**Tools:** MySQL CLI

### Task 2.2.1 — Restore MySQL server using a previous backup
```bash
wget "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0231EN-SkillsNetwork/labs/Final%20Assignment/billingdata.sql"
mysql -u root -p < billingdata.sql
```
```sql
USE billing;
SHOW TABLES;
```

📸 `screenshots/2.2.1_restore_and_tables.png`

### Task 2.2.2 — Find the table data size
```sql
SHOW TABLE STATUS FROM billing LIKE 'billdata';
```
The `Data_length` column reports the table's data size in bytes (`Index_length` reports index size separately).

📸 `screenshots/2.2.2_table_size.png`

### Task 2.3.1 — Baseline query performance
```sql
SELECT * FROM billdata WHERE billedamount > 19999;
```
Execution time without an index: **0.08 sec**.

📸 `screenshots/2.3.1_baseline_query.png`

### Task 2.3.2 — Create an index
```sql
CREATE INDEX billed_amount_index ON billdata(billedamount);
```
The index is created on the exact column used in the `WHERE` clause.

📸 `screenshots/2.3.2_create_index.png`

### Task 2.3.3 — Document the improvement
Re-running the baseline query: **0.08 sec → 0.00 sec**. Full analysis in [`PERFORMANCE.md`](PERFORMANCE.md).

📸 `screenshots/2.3.3_indexed_query.png`

### Task 2.4.1 — Find supported storage engines
```sql
SHOW ENGINES;
```
The output lists each engine with a `Support` value (`YES`, `NO`, or `DEFAULT`), confirming whether **MyISAM** is available.

📸 `screenshots/2.4.1_show_engines.png`

### Task 2.4.2 — Find the storage engine of a table
```sql
SHOW TABLE STATUS FROM billing LIKE 'billdata';
```
The `Engine` column shows which storage engine `billdata` uses.

📸 `screenshots/2.4.2_table_engine.png`
