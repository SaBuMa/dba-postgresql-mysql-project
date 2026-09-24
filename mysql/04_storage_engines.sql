-- =============================================================
-- Scenario 2 · Tasks 2.4.1 – 2.4.2 — Storage Engines
-- =============================================================

-- Task 2.4.1 — Find supported storage engines
-- Look for MyISAM in the Engine column; Support = YES / DEFAULT
SHOW ENGINES;

-- Task 2.4.2 — Find the storage engine of the table billdata
-- (see the Engine column)
SHOW TABLE STATUS FROM billing LIKE 'billdata';

-- Alternative: query information_schema directly
-- SELECT table_name, engine
-- FROM information_schema.tables
-- WHERE table_schema = 'billing' AND table_name = 'billdata';
