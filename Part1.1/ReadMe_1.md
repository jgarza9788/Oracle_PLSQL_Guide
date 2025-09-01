Great question. Deadlocks in Oracle usually come from two sessions taking locks in different orders (or from unindexed FKs). Here’s a practical playbook to update safely.

# 1) Lock rows in a consistent, indexed order

* Always access rows in the **same order** across sessions (e.g., by primary key).
* Make sure your `WHERE` clause uses an **index** so you don’t escalate to lots of row locks.

```sql
-- Example: process tasks in ascending PK order, locking rows as you go
DECLARE
  CURSOR c_jobs IS
    SELECT id
    FROM   job_queue
    WHERE  status = 'PENDING'
    ORDER  BY id
    FOR UPDATE SKIP LOCKED;  -- don't wait on rows another session is using
BEGIN
  FOR r IN c_jobs LOOP
    UPDATE job_queue
    SET    status = 'RUNNING',
           started_at = SYSTIMESTAMP
    WHERE  CURRENT OF c_jobs;

    -- ... do work ...

    UPDATE job_queue
    SET    status = 'DONE',
           finished_at = SYSTIMESTAMP
    WHERE  id = r.id; -- same row, still locked

    COMMIT;  -- keep transactions small to reduce lock time
  END LOOP;
END;
/
```

Notes:

* `FOR UPDATE SKIP LOCKED` lets concurrent workers avoid each other entirely.
* If you prefer to fail fast instead of skipping, use `NOWAIT` and implement retry.

# 2) Keep transactions small

* Update only what you need, commit often (but not **too** often).
* Avoid long app logic between `SELECT ... FOR UPDATE` and `UPDATE`.

# 3) Use deterministic parent→child locking

* If you must touch multiple tables, always lock **parent first, then child** (same order everywhere).
* When iterating multiple keys, lock them **sorted** (e.g., ascending ID) every time.

# 4) Index your foreign keys (critical!)

Unindexed foreign keys can cause table-level (TM) locks and deadlocks when a parent row is updated/deleted.

* Create indexes on **every** FK column used by child tables.

```sql
CREATE INDEX ix_orders_customer_id ON orders(customer_id);
```

# 5) Add retry-on-deadlock with short backoff

If a deadlock still happens (ORA-00060), retry a few times with jitter.

```sql
DECLARE
  e_deadlock EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_deadlock, -60);  -- ORA-00060
  l_attempts PLS_INTEGER := 0;
  l_max_attempts PLS_INTEGER := 5;
BEGIN
  <<retry>>
  BEGIN
    -- Minimal, targeted update
    UPDATE accounts
    SET    balance = balance - :amount
    WHERE  account_id = :id;  -- indexed PK

    COMMIT;
  EXCEPTION
    WHEN e_deadlock THEN
      ROLLBACK;
      l_attempts := l_attempts + 1;
      IF l_attempts <= l_max_attempts THEN
        DBMS_LOCK.SLEEP(0.2 * l_attempts + DBMS_RANDOM.VALUE(0, 0.2)); -- backoff + jitter
        GOTO retry;
      ELSE
        RAISE;
      END IF;
  END;
END;
/
```

# 6) Other tips

* Avoid hidden cross-updates in triggers that change lock order.
* Don’t mix DDL with your transaction (it implicitly commits and can surprise you).
* Consider `SELECT … FOR UPDATE WAIT n` for a bounded wait instead of indefinite blocking.
* If you’re sharding/partitioning, try to keep each transaction within a **single partition**.

---

If you share your table(s), indexes, and the kind of update you’re doing, I can tailor the exact pattern (cursor vs single-statement update, NOWAIT vs SKIP LOCKED, and which FKs to index).
