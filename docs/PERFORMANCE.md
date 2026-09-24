# ⚡ Indexing & Query Performance Analysis

## The problem

The customer reported that the following query was slow:

```sql
SELECT * FROM billdata WHERE billedamount > 19999;
```

Without an index on `billedamount`, MySQL must perform a **full table scan** — it reads every row in `billdata` and checks the condition one row at a time.

## The fix

```sql
CREATE INDEX billed_amount_index ON billdata(billedamount);
```

This creates a **B-tree index** (the default for InnoDB and MyISAM). Because a B-tree keeps values sorted, MySQL can jump directly to the first value greater than `19999` and read forward — an **index range scan** — instead of examining the whole table.

## Results

| Measurement | Execution time |
|---|---|
| Baseline (no index) | **0.08 sec** |
| After creating `billed_amount_index` | **0.00 sec** |

The query went from a measurable delay to completing below the MySQL client's timing resolution (reported as `0.00 sec`, i.e. under 5 ms).

## How to verify with `EXPLAIN`

```sql
EXPLAIN SELECT * FROM billdata WHERE billedamount > 19999;
```

| Column | Before index | After index |
|---|---|---|
| `type` | `ALL` (full table scan) | `range` (index range scan) |
| `key` | `NULL` | `billed_amount_index` |
| `rows` | ≈ all rows in the table | ≈ only the matching rows |

## Trade-offs to keep in mind

- **Storage:** the index takes extra disk space (visible in `Index_length` from `SHOW TABLE STATUS`).
- **Write cost:** every `INSERT`, `UPDATE`, or `DELETE` on `billedamount` must also update the index.
- **Selectivity:** an index helps most when the filter returns a small fraction of the table. If most rows matched `billedamount > 19999`, the optimizer might still choose a full scan.

For a column that is filtered frequently and selectively, like `billedamount` here, the read benefit clearly outweighs these costs.
