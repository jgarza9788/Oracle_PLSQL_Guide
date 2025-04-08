# Oracle PL/SQL 19.0 Guide

## **Table of Contents**
1. **Introduction to PL/SQL**
2. **PL/SQL Architecture**
3. **PL/SQL Block Structure**
4. **Variables and Data Types**
5. **Control Structures**
6. **Cursors**
7. **Exception Handling**
8. **Stored Procedures and Functions**
9. **Triggers**
10. **Packages**
11. **Collections and Records**
12. **Dynamic SQL**
13. **Performance Optimization in PL/SQL**
14. **PL/SQL Best Practices**
15. **PL/SQL Enhancements in Oracle 19c**

---

## 1. Introduction to PL/SQL
PL/SQL (Procedural Language/Structured Query Language) is Oracle's procedural extension to SQL. It enables developers to write complex scripts and programs that include procedural logic, control structures, error handling, and database interactions.

### Key Features of PL/SQL:
- Block-structured programming language
- Tight integration with SQL
- Support for procedural constructs like loops and conditionals
- Exception handling mechanisms
- Support for stored procedures, functions, and triggers
- Performance optimization through bulk operations and caching

## 2. PL/SQL Architecture
PL/SQL operates in the Oracle Database environment and consists of the following components:

- **PL/SQL Engine**: Executes procedural logic
- **SQL Engine**: Executes embedded SQL statements
- **PL/SQL Compiler**: Converts PL/SQL code into P-code (intermediate code) for execution
- **PL/SQL Runtime**: Manages program execution and memory allocation

## 3. PL/SQL Block Structure
A PL/SQL block is the fundamental unit of PL/SQL code, which consists of:

```plsql
DECLARE  -- Optional
   -- Variable declarations
BEGIN  -- Mandatory
   -- Executable statements
EXCEPTION  -- Optional
   -- Exception handling code
END;
```

## 4. Variables and Data Types
### Declaring Variables:
```plsql
DECLARE
   v_emp_name VARCHAR2(100);
   v_salary NUMBER(10,2);
   v_hire_date DATE;
BEGIN
   -- Assign values
   v_emp_name := 'John Doe';
   v_salary := 50000;
   v_hire_date := SYSDATE;
END;
```

### Common Data Types:
- **Scalar Data Types**: NUMBER, VARCHAR2, DATE, BOOLEAN
- **Composite Data Types**: RECORD, TABLE, VARRAY
- **Reference Data Types**: CURSOR, REF CURSOR
- **LOB Data Types**: BLOB, CLOB

## 5. Control Structures
PL/SQL supports conditional statements and loops:

### IF-THEN-ELSE:
```plsql
IF v_salary > 100000 THEN
   DBMS_OUTPUT.PUT_LINE('High salary');
ELSE
   DBMS_OUTPUT.PUT_LINE('Moderate salary');
END IF;
```

### LOOP Structures:
- **FOR LOOP**
```plsql
FOR i IN 1..10 LOOP
   DBMS_OUTPUT.PUT_LINE(i);
END LOOP;
```

- **WHILE LOOP**
```plsql
WHILE v_salary < 100000 LOOP
   v_salary := v_salary + 1000;
END LOOP;
```

## 6. Cursors
### Explicit Cursor:
```plsql
DECLARE
   CURSOR emp_cursor IS SELECT emp_name FROM employees;
   v_emp_name employees.emp_name%TYPE;
BEGIN
   OPEN emp_cursor;
   LOOP
      FETCH emp_cursor INTO v_emp_name;
      EXIT WHEN emp_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_emp_name);
   END LOOP;
   CLOSE emp_cursor;
END;
```

### Implicit Cursor:
```plsql
BEGIN
   UPDATE employees SET salary = salary * 1.1;
   IF SQL%ROWCOUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('Employees updated: ' || SQL%ROWCOUNT);
   END IF;
END;
```

## 7. Exception Handling
```plsql
BEGIN
   -- Some operation that might cause an error
   UPDATE employees SET salary = -100 WHERE emp_id = 101;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
```

## 8. Stored Procedures and Functions
### Creating a Stored Procedure:
```plsql
CREATE OR REPLACE PROCEDURE raise_salary (
   p_emp_id IN employees.emp_id%TYPE,
   p_percentage IN NUMBER
) AS
BEGIN
   UPDATE employees
   SET salary = salary * (1 + p_percentage / 100)
   WHERE emp_id = p_emp_id;
END raise_salary;
```

### Creating a Function:
```plsql
CREATE OR REPLACE FUNCTION get_salary (
   p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER AS
   v_salary employees.salary%TYPE;
BEGIN
   SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
   RETURN v_salary;
END get_salary;
```

## 9. Triggers
Triggers are automatically executed when certain conditions are met.

### Example of a Trigger:
```plsql
CREATE OR REPLACE TRIGGER before_insert_employee
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
   :NEW.hire_date := SYSDATE;
END;
```

## 10. Packages
Packages group related procedures, functions, and variables together.

### Package Specification:
```plsql
CREATE OR REPLACE PACKAGE emp_pkg AS
   PROCEDURE hire_employee;
   FUNCTION get_employee_count RETURN NUMBER;
END emp_pkg;
```

### Package Body:
```plsql
CREATE OR REPLACE PACKAGE BODY emp_pkg AS
   PROCEDURE hire_employee IS
   BEGIN
      -- Implementation
   END;

   FUNCTION get_employee_count RETURN NUMBER IS
      v_count NUMBER;
   BEGIN
      SELECT COUNT(*) INTO v_count FROM employees;
      RETURN v_count;
   END;
END emp_pkg;
```

## 11. Collections and Records
PL/SQL supports composite data structures like collections and records.

### Example of a Collection:
```plsql
DECLARE
   TYPE NumList IS TABLE OF NUMBER;
   v_numbers NumList := NumList(1, 2, 3, 4, 5);
BEGIN
   FOR i IN v_numbers.FIRST .. v_numbers.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(v_numbers(i));
   END LOOP;
END;
```

## 12. Dynamic SQL
Dynamic SQL allows execution of SQL statements that are built at runtime.

```plsql
DECLARE
   v_sql VARCHAR2(1000);
BEGIN
   v_sql := 'UPDATE employees SET salary = salary * 1.1 WHERE department_id = 10';
   EXECUTE IMMEDIATE v_sql;
END;
```

## **13. Performance Optimization in PL/SQL**

Optimizing PL/SQL code is crucial for improving database performance and reducing resource consumption. Here are some key techniques:

---

### **13.1 Use BULK COLLECT for Large Data Operations**
When dealing with large amounts of data, using `BULK COLLECT` can significantly improve performance by reducing context switching between SQL and PL/SQL engines.

#### **Example: Using BULK COLLECT to Fetch Data Efficiently**
```plsql
DECLARE
   TYPE emp_table IS TABLE OF employees%ROWTYPE;
   v_emp_data emp_table;
BEGIN
   SELECT * BULK COLLECT INTO v_emp_data FROM employees WHERE department_id = 10;
   
   FOR i IN v_emp_data.FIRST .. v_emp_data.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(v_emp_data(i).emp_name || ' earns ' || v_emp_data(i).salary);
   END LOOP;
END;
/
```
- **Advantage:** Instead of fetching rows one by one, this retrieves all rows at once, reducing context switches.

---

### **13.2 Use FORALL for Bulk DML Operations**
The `FORALL` statement improves performance by executing bulk inserts, updates, or deletes in a single step.

#### **Example: Using FORALL to Perform Bulk Updates**
```plsql
DECLARE
   TYPE emp_table IS TABLE OF employees.emp_id%TYPE;
   v_emp_ids emp_table := emp_table(101, 102, 103);
BEGIN
   FORALL i IN v_emp_ids.FIRST .. v_emp_ids.LAST
      UPDATE employees SET salary = salary * 1.1 WHERE emp_id = v_emp_ids(i);
   COMMIT;
END;
/
```
- **Advantage:** Instead of updating records one by one in a loop, `FORALL` executes the operation in bulk.

---

### **13.3 Use EXPLAIN PLAN to Optimize Queries**
Use `EXPLAIN PLAN` to analyze query performance and determine if indexing or other optimizations are needed.

#### **Example: Checking Query Execution Plan**
```plsql
EXPLAIN PLAN FOR 
SELECT * FROM employees WHERE department_id = 10;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```
- **Advantage:** Helps identify slow queries and optimize them with indexes or better query structures.

---

## **14. PL/SQL Best Practices**

Following best practices ensures maintainability, performance, and security in PL/SQL development.

---

### **14.1 Use Meaningful Variable Names**
Avoid using generic variable names like `v1`, `x`, `y`, and instead use descriptive names.

#### **Bad Practice**
```plsql
DECLARE
   v1 NUMBER;
BEGIN
   v1 := 100;
END;
/
```
#### **Good Practice**
```plsql
DECLARE
   v_employee_salary NUMBER;
BEGIN
   v_employee_salary := 100000;
END;
/
```
- **Advantage:** Improves readability and reduces confusion.

---

### **14.2 Always Handle Exceptions**
Handling exceptions prevents runtime errors from causing application failures.

#### **Example: Proper Exception Handling**
```plsql
BEGIN
   SELECT salary INTO v_salary FROM employees WHERE emp_id = 999; -- Assume no such ID
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No employee found!');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
```
- **Advantage:** Provides meaningful error messages instead of unhandled failures.

---

### **14.3 Use %TYPE and %ROWTYPE Instead of Hardcoding Data Types**
Hardcoding data types leads to maintenance issues if the table structure changes.

#### **Bad Practice (Hardcoded Data Types)**
```plsql
DECLARE
   v_emp_name VARCHAR2(50);
BEGIN
   SELECT emp_name INTO v_emp_name FROM employees WHERE emp_id = 101;
END;
/
```
#### **Good Practice (Using %TYPE)**
```plsql
DECLARE
   v_emp_name employees.emp_name%TYPE;
BEGIN
   SELECT emp_name INTO v_emp_name FROM employees WHERE emp_id = 101;
END;
/
```
- **Advantage:** Makes the code adaptable to changes in database schema.

---

### **14.4 Optimize Loops with BULK COLLECT**
Instead of fetching rows one by one, use `BULK COLLECT` for better performance.

#### **Inefficient Loop**
```plsql
DECLARE
   v_name employees.emp_name%TYPE;
   v_salary employees.salary%TYPE;
   CURSOR emp_cursor IS SELECT emp_name, salary FROM employees;
BEGIN
   OPEN emp_cursor;
   LOOP
      FETCH emp_cursor INTO v_name, v_salary;
      EXIT WHEN emp_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(v_name || ' earns ' || v_salary);
   END LOOP;
   CLOSE emp_cursor;
END;
/
```
#### **Optimized with BULK COLLECT**
```plsql
DECLARE
   TYPE emp_table IS TABLE OF employees%ROWTYPE;
   v_emp_data emp_table;
BEGIN
   SELECT * BULK COLLECT INTO v_emp_data FROM employees;
   
   FOR i IN v_emp_data.FIRST .. v_emp_data.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(v_emp_data(i).emp_name || ' earns ' || v_emp_data(i).salary);
   END LOOP;
END;
/
```
- **Advantage:** Fetches all rows in one go, improving efficiency.

---

## **15. PL/SQL Enhancements in Oracle 19c**
Oracle 19c introduced several enhancements to PL/SQL, improving performance, security, and JSON handling.

---

### **15.1 PL/SQL-only Standalone Functions**
Oracle 19c allows the creation of PL/SQL-only standalone functions, which are accessible only from PL/SQL.

#### **Example**
```plsql
CREATE FUNCTION get_salary_19c(p_emp_id NUMBER) RETURN NUMBER
IS
   v_salary NUMBER;
BEGIN
   SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
   RETURN v_salary;
END;
/
```
- **Advantage:** These functions are optimized for PL/SQL execution and are not exposed to SQL.

---

### **15.2 Enhanced JSON Support**
Oracle 19c improves handling of JSON data in PL/SQL.

#### **Example: Parsing JSON Data in 19c**
```plsql
DECLARE
   v_json_data CLOB;
   v_employee_name VARCHAR2(100);
BEGIN
   v_json_data := '{"name": "John Doe", "salary": 50000}';
   SELECT JSON_VALUE(v_json_data, '$.name') INTO v_employee_name FROM dual;
   DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_employee_name);
END;
/
```
- **Advantage:** Efficiently handles JSON parsing within PL/SQL.

---

### **15.3 Persistent Memory Store (PMEM) for Performance**
Oracle 19c introduced Persistent Memory Store (PMEM) to improve performance by reducing disk I/O.

#### **Example: Using PMEM Optimized Data Access**
```plsql
ALTER SYSTEM SET USE_PMEM_FOR_STORAGE = TRUE;
```
- **Advantage:** Reduces latency by using persistent memory instead of traditional storage.

---

### **15.4 Security Enhancements**
Oracle 19c introduced additional security controls to protect PL/SQL program units.

#### **Example: Controlling Privileges on PL/SQL Objects**
```plsql
GRANT EXECUTE ON my_secure_procedure TO specific_user;
REVOKE EXECUTE ON my_secure_procedure FROM public;
```
- **Advantage:** Enhances security by limiting execution permissions.

---
