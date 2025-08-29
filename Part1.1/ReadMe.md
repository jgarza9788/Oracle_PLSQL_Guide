
# README: Monitoring Table Activity and Running Low-Priority Queries in Oracle

## Overview

This guide covers how to check if a table is currently "busy" or locked in Oracle Database and how to run queries in a way that minimizes their impact on other database activities.

## Checking if a Table Is Busy

Oracle doesn't have a direct function to see if a table is "busy," but you can check if it's locked by using dynamic performance views. For example, you can use the `v$locked_object` view to identify if your table is currently locked by any session.

### Example Query

```sql
SELECT lo.object_name, lo.session_id, s.sid, s.serial#, s.status, s.osuser
FROM v$locked_object lo
JOIN v$session s ON lo.session_id = s.sid
WHERE lo.object_name = 'YOUR_TABLE_NAME';
```

This query will list any sessions holding locks on the specified table, giving you insight into whether the table is currently in use.

## Running a Low-Priority Query

While Oracle doesn't have a direct "low priority" option, you can use the Oracle Database Resource Manager to assign a lower priority to a session or a group of sessions. This effectively reduces the resources allocated to that query, making it less likely to interfere with other operations.

### Overview - Steps to Set Up a Low-Priority Consumer Group

1. **Create a Consumer Group**: Define a resource consumer group with lower resource allocation.
2. **Assign the Query Session**: Assign your session or user to this consumer group.
3. **Activate the Plan**: Make sure the resource plan is active so that the prioritization takes effect.

### 🔧 Step 1: Enable Resource Manager (If not already enabled)

Ensure the resource manager is active:

```sql
SHOW PARAMETER resource_manager_plan;
```

If it shows `NULL`, activate a plan:

```sql
ALTER SYSTEM SET RESOURCE_MANAGER_PLAN = 'DEFAULT_PLAN' SCOPE = BOTH;
```

Or create a custom plan and activate that (shown below).

---

### 🏗 Step 2: Create a Resource Plan and Consumer Group

Here’s a minimal example that creates:

* A **resource plan** (`low_priority_plan`)
* A **consumer group** (`low_priority_group`)
* A rule to assign sessions to that group manually

```sql
BEGIN
  -- Create the consumer group
  DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(
    CONSUMER_GROUP => 'low_priority_group',
    COMMENT => 'Group for low-priority queries');

  -- Create a resource plan
  DBMS_RESOURCE_MANAGER.CREATE_PLAN(
    PLAN    => 'low_priority_plan',
    COMMENT => 'Plan for handling low priority workloads');

  -- Add directive to the plan for the low-priority group
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(
    PLAN             => 'low_priority_plan',
    GROUP_OR_SUBPLAN => 'low_priority_group',
    COMMENT          => 'Limit CPU for low-priority group',
    CPU_P1           => 10);  -- allocate 10% CPU

  -- Add directive for OTHER_GROUPS (required)
  DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(
    PLAN             => 'low_priority_plan',
    GROUP_OR_SUBPLAN => 'OTHER_GROUPS',
    COMMENT          => 'Allow other sessions',
    CPU_P1           => 90);

  -- Validate and submit
  DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA;
  DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA;
END;
/
```

---

### 🧩 Step 3: Switch Session to Consumer Group

You can switch the current session or another session to the new consumer group.

#### For current session:

```sql
EXEC DBMS_SESSION.SWITCH_CONSUMER_GROUP('low_priority_group');
```

#### For a specific session (admin only):

```sql
EXEC DBMS_RESOURCE_MANAGER.SWITCH_CONSUMER_GROUP_FOR_SESS(
  SESSION_ID => <SID>,
  SERIAL_NUM => <Serial#>,
  CONSUMER_GROUP => 'low_priority_group');
```

---

### 🔄 Step 4: Use the Group and Run Your Query

Now any queries you run in that session will run under limited CPU share:

```sql
-- Low-priority query
SELECT * FROM large_table WHERE ...;
```

---

### 🔚 Step 5: (Optional) Revert to Original Group

```sql
EXEC DBMS_SESSION.SWITCH_CONSUMER_GROUP('DEFAULT_CONSUMER_GROUP');
```





## Off-Peak Timing

Alternatively, you can simply schedule your queries during times of low database usage. This way, they naturally have less impact on other operations.

