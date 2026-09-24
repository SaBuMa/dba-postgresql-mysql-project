# 🗄️ Database Administration Project — PostgreSQL & MySQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=databricks&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

The project covers the day-to-day responsibilities of a Database Administrator across two relational database systems: **user and role management**, **backup and recovery**, **configuration checks**, **query performance tuning with indexes**, and **storage engine analysis**.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Skills Demonstrated](#-skills-demonstrated)
- [Repository Structure](#-repository-structure)
- [Scenario 1 — PostgreSQL](#-scenario-1--postgresql-administration)
- [Scenario 2 — MySQL](#-scenario-2--mysql-administration)
- [Results](#-results)
- [How to Reproduce](#-how-to-reproduce)
- [Key Takeaways](#-key-takeaways)
- [Author](#-author)

---

## 🧭 Project Overview

| Scenario | RDBMS | Database | DBA Areas Covered |
|---|---|---|---|
| **1** | PostgreSQL | `tolldata` | Configuration · User Management · Role-Based Access Control · Backup |
| **2** | MySQL | `billing` | Recovery · Table Sizing · Indexing & Query Tuning · Storage Engines |

All tasks were performed using the **PostgreSQL CLI (`psql`)**, the **MySQL CLI**, and **pgAdmin** in the IBM Skills Network (Theia) lab environment.

---

## 🛠️ Skills Demonstrated

- **Server configuration inspection** — reading runtime parameters such as `max_connections`
- **Access control** — creating users and roles, applying the *principle of least privilege* through role-based grants
- **Backup** — producing a portable Tar-format archive of a production database
- **Recovery** — restoring a full database from a SQL dump file
- **Capacity monitoring** — measuring table data size from server metadata
- **Performance tuning** — establishing a query baseline, adding a B-tree index, and measuring the improvement
- **Storage engine analysis** — identifying supported engines and the engine used by a given table

---

## 📁 Repository Structure

```
dba-postgresql-mysql-project/
├── README.md
├── LICENSE
├── .gitignore
├── postgresql/
│   ├── 01_check_settings.sql        # Task 1.1 – server configuration
│   ├── 02_user_role_management.sql  # Tasks 1.2–1.5 – users, roles, grants
│   └── 03_backup_tolldata.sh        # Task 1.6 – CLI equivalent of the pgAdmin backup
├── mysql/
│   ├── 01_restore_billing.sh        # Task 2.2.1 – download & restore backup
│   ├── 02_table_info.sql            # Tasks 2.2.1–2.2.2 – tables & data size
│   ├── 03_indexing.sql              # Tasks 2.3.1–2.3.3 – baseline, index, re-test
│   └── 04_storage_engines.sql       # Tasks 2.4.1–2.4.2 – engine analysis
├── docs/
│   ├── TASKS.md                     # Detailed task-by-task walkthrough
│   └── PERFORMANCE.md               # Indexing analysis & results
├── backup/
│   └── README.md                    # Notes on the tolldatabackup.tar artifact
└── screenshots/
    └── README.md                    # Evidence screenshots for each task
```

---

## 🐘 Scenario 1 — PostgreSQL Administration

> *You have assumed the role of database administrator for the PostgreSQL server and will perform the user management tasks and handle the backup of the databases.*

| Task | Description | Script |
|---|---|---|
| 1.1 | Find the maximum number of connections allowed | [`01_check_settings.sql`](postgresql/01_check_settings.sql) |
| 1.2 | Create user `backup_operator` | [`02_user_role_management.sql`](postgresql/02_user_role_management.sql) |
| 1.3 | Create role `backup` | [`02_user_role_management.sql`](postgresql/02_user_role_management.sql) |
| 1.4 | Grant `CONNECT` on `tolldata` and `SELECT` on all tables in schema `toll` | [`02_user_role_management.sql`](postgresql/02_user_role_management.sql) |
| 1.5 | Grant role `backup` to `backup_operator` | [`02_user_role_management.sql`](postgresql/02_user_role_management.sql) |
| 1.6 | Back up `tolldata` to `tolldatabackup.tar` (Tar format) | pgAdmin GUI · CLI equivalent in [`03_backup_tolldata.sh`](postgresql/03_backup_tolldata.sh) |

**Access-control design:** privileges are granted to the **role**, and the role is granted to the **user**. This means new backup operators can be onboarded with a single `GRANT backup TO ...` statement, and permissions are managed in one place.

```sql
CREATE USER backup_operator;
CREATE ROLE backup;

GRANT CONNECT ON DATABASE tolldata TO backup;
GRANT SELECT ON ALL TABLES IN SCHEMA toll TO backup;

GRANT backup TO backup_operator;
```

---

## 🐬 Scenario 2 — MySQL Administration

> *You have assumed the role of database administrator for the MySQL server and will perform tasks like configuration checks and data recovery, use indexing to improve database performance, and identify the storage engines supported by the server.*

| Task | Description | Script |
|---|---|---|
| 2.2.1 | Restore the `billing` database from `billingdata.sql` and list its tables | [`01_restore_billing.sh`](mysql/01_restore_billing.sh) · [`02_table_info.sql`](mysql/02_table_info.sql) |
| 2.2.2 | Find the data size of table `billdata` | [`02_table_info.sql`](mysql/02_table_info.sql) |
| 2.3.1 | Baseline query: rows with `billedamount > 19999` | [`03_indexing.sql`](mysql/03_indexing.sql) |
| 2.3.2 | Create an index to speed up the query | [`03_indexing.sql`](mysql/03_indexing.sql) |
| 2.3.3 | Re-run the query and document the improvement | [`03_indexing.sql`](mysql/03_indexing.sql) · [`PERFORMANCE.md`](docs/PERFORMANCE.md) |
| 2.4.1 | Check whether the server supports **MyISAM** | [`04_storage_engines.sql`](mysql/04_storage_engines.sql) |
| 2.4.2 | Find the storage engine of table `billdata` | [`04_storage_engines.sql`](mysql/04_storage_engines.sql) |

---

## 📊 Results

### Query performance before vs. after indexing

| Query | Without index | With `billed_amount_index` |
|---|---|---|
| `SELECT * FROM billdata WHERE billedamount > 19999;` | **0.08 sec** | **0.00 sec** |

Adding a B-tree index on `billedamount` lets MySQL perform an **index range scan** instead of a **full table scan**, so only the matching rows are read. See [`docs/PERFORMANCE.md`](docs/PERFORMANCE.md) for the full analysis and how to verify it with `EXPLAIN`.

---

## ▶️ How to Reproduce

### PostgreSQL

```bash
# Task 1.1
psql -U postgres -f postgresql/01_check_settings.sql

# Tasks 1.2 – 1.5 (run against the tolldata database)
psql -U postgres -d tolldata -f postgresql/02_user_role_management.sql

# Task 1.6 (CLI alternative to the pgAdmin backup)
bash postgresql/03_backup_tolldata.sh
```

### MySQL

```bash
# Task 2.2.1 – download and restore the billing database
bash mysql/01_restore_billing.sh

# Tasks 2.2 – 2.4
mysql -u root -p billing < mysql/02_table_info.sql
mysql -u root -p billing < mysql/03_indexing.sql
mysql -u root -p billing < mysql/04_storage_engines.sql
```

> 💡 To observe execution times like the ones in the Results table, run the queries in an **interactive** MySQL session — the client prints the elapsed time after each statement.

---

## 💡 Key Takeaways

- **Role-based access control scales better than per-user grants** — permissions live in one role that can be assigned to any number of users.
- **Least privilege matters for backup accounts** — a backup operator needs to *read* data, not modify it.
- **Tar-format backups** are portable archives that can be restored selectively with `pg_restore`.
- **Always measure before and after tuning** — a baseline makes the effect of an index verifiable instead of assumed.
- **Indexes are a trade-off** — they speed up reads but add storage and write overhead, so they belong on columns used in frequent filters.

---

## 👤 Author

**Santiago Burgos**
Electronics Engineer · Aspiring Data Engineer

[![GitHub](https://img.shields.io/badge/GitHub-SaBuMa-181717?style=flat&logo=github)](https://github.com/SaBuMa)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-santiagoburgosm-0A66C2?style=flat&logo=linkedin)](https://www.linkedin.com/in/santiagoburgosm)

---

*This project was completed as part of the IBM Data Engineering Professional Certificate. Lab environment and datasets provided by IBM Skills Network.*
