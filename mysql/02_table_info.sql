-- =============================================================
-- Scenario 2 · Tasks 2.2.1 – 2.2.2 — Tables & data size
-- Database : billing
-- =============================================================

USE billing;

-- Task 2.2.1 — List the tables in the billing database
SHOW TABLES;

-- Task 2.2.2 — Find the data size of the table billdata
-- (see the Data_length column, in bytes)
SHOW TABLE STATUS FROM billing LIKE 'billdata';

-- Alternative: size in MB from information_schema
-- SELECT table_name,
--        ROUND(data_length / 1024 / 1024, 2)  AS data_mb,
--        ROUND(index_length / 1024 / 1024, 2) AS index_mb
-- FROM information_schema.tables
-- WHERE table_schema = 'billing' AND table_name = 'billdata';
