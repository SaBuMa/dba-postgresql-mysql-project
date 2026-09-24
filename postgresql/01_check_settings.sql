-- =============================================================
-- Scenario 1 · Task 1.1 — Find the settings in PostgreSQL
-- Goal : Find the maximum number of connections allowed
--        on the PostgreSQL server.
-- Tool : psql (PostgreSQL CLI)
-- =============================================================

SHOW max_connections;

-- Optional: view the setting with its context and source
-- SELECT name, setting, context, source
-- FROM pg_settings
-- WHERE name = 'max_connections';
