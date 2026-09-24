-- =============================================================
-- Scenario 1 · Tasks 1.2 – 1.5 — User & Role Management
-- Database : tolldata
-- Schema   : toll
-- Tool     : psql (PostgreSQL CLI)
--
-- Design: privileges are granted to a ROLE (backup), and the
-- role is granted to the USER (backup_operator). New operators
-- can be onboarded with a single GRANT statement.
-- =============================================================

-- Task 1.2 — Create a user
CREATE USER backup_operator;

-- Task 1.3 — Create a role
CREATE ROLE backup;

-- Task 1.4 — Grant privileges to the role
GRANT CONNECT ON DATABASE tolldata TO backup;
GRANT SELECT ON ALL TABLES IN SCHEMA toll TO backup;

-- Task 1.5 — Grant the role to the user
GRANT backup TO backup_operator;

-- -------------------------------------------------------------
-- Optional hardening (beyond the course requirements)
-- -------------------------------------------------------------
-- In PostgreSQL, reading tables in a schema also requires
-- USAGE on that schema:
-- GRANT USAGE ON SCHEMA toll TO backup;
--
-- "ON ALL TABLES" only covers tables that exist right now.
-- To cover tables created in the future as well:
-- ALTER DEFAULT PRIVILEGES IN SCHEMA toll
--     GRANT SELECT ON TABLES TO backup;

-- -------------------------------------------------------------
-- Verification
-- -------------------------------------------------------------
-- \du                       -- list roles and memberships
-- \dp toll.*                -- list table privileges in schema toll
