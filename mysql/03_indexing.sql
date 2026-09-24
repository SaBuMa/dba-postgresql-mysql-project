-- =============================================================
-- Scenario 2 · Tasks 2.3.1 – 2.3.3 — Indexing & Query Performance
-- Database : billing
-- Table    : billdata
-- =============================================================

USE billing;

-- Task 2.3.1 — Baseline query performance
-- Result without index: 0.08 sec
SELECT * FROM billdata WHERE billedamount > 19999;

-- Optional: inspect the plan (expect type = ALL → full table scan)
-- EXPLAIN SELECT * FROM billdata WHERE billedamount > 19999;

-- Task 2.3.2 — Create an index on the filtered column
CREATE INDEX billed_amount_index ON billdata(billedamount);

-- Task 2.3.3 — Re-run the baseline query
-- Result with index: 0.00 sec
SELECT * FROM billdata WHERE billedamount > 19999;

-- Optional: confirm the index is used (expect type = range,
-- key = billed_amount_index)
-- EXPLAIN SELECT * FROM billdata WHERE billedamount > 19999;

-- Verify the index exists
SHOW INDEX FROM billdata;
