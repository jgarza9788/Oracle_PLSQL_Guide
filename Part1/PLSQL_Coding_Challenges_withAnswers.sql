
ALTER SESSION SET CURRENT_SCHEMA = HR;

--### **Basic PL/SQL Challenges**
--1. **Hello PL/SQL**: Write a simple PL/SQL block that prints "Hello, PL/SQL!" using `DBMS_OUTPUT.PUT_LINE`.

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL');
END;
/

--2. **Declare and Assign Variables**: Declare a variable for an employee’s name and salary, assign values, and print them.
DECLARE
   v_emp_name VARCHAR2(100);
   v_salary NUMBER(10,2);
   v_hire_date DATE;
BEGIN
   -- Assign values
   v_emp_name := 'John Doe';
   v_salary := 50000;
   v_hire_date := SYSDATE;

   DBMS_OUTPUT.PUT_LINE(v_emp_name);
   DBMS_OUTPUT.PUT_LINE(v_salary);
   DBMS_OUTPUT.PUT_LINE(v_hire_date);
END;
/

--3. **IF-THEN-ELSE Control Structure**: Write a PL/SQL block that checks if an employee's salary is greater than 50000. If so, print "High Salary", otherwise "Low Salary".
DECLARE
   v_salary NUMBER(10,2);
BEGIN
   v_salary := 50000;

   IF v_salary > 50000 THEN
        DBMS_OUTPUT.PUT_LINE('High Salary');
   ELSE
        DBMS_OUTPUT.PUT_LINE('Low Salary');
   END IF;
END;
/


--server output mode ... on
-- SET SERVEROUTPUT ON;

--4. **FOR Loop Basics**: Create a PL/SQL block that prints numbers from 1 to 10 using a `FOR LOOP`.
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('NUM: ' || i);
    END LOOP;
END;
/

--5. **WHILE Loop Basics**: Create a PL/SQL block that starts with a salary of 30000 and increases it by 5000 until it reaches 60000.
DECLARE
   v_salary NUMBER(10,2) := 30000;
BEGIN
    WHILE v_salary < 60000 LOOP
        v_salary := v_salary + 5000;
        DBMS_OUTPUT.PUT_LINE('v_salary: ' || v_salary);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('final salary: ' || v_salary);
END;
/

---

--### **Working with Tables (Using PLSQL_Environment_SetUp.sql Tables)**
--6. **Insert Employee**: Write a PL/SQL block that inserts a new employee into the `employees` table.
select * from EMPLOYEES;
DESC employees;


-- Now fetch and print the inserted row
DECLARE
    v_row employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_row
    FROM employees
    WHERE emp_id = 100;

    DELETE FROM employees WHERE emp_id = v_row.emp_id;

    DBMS_OUTPUT.PUT_LINE('deleted: ' || v_row.emp_id || ', ' || v_row.emp_name);
END;
/

DECLARE
    v_emp_id NUMBER;
    v_emp_name VARCHAR2(100);
    v_department_id NUMBER;
    v_salary NUMBER(10,2);
    v_hire_date DATE;
BEGIN
    v_emp_id := 100;
    v_emp_name := 'John Doe';
    v_department_id := 1;
    v_salary := 50000;
    v_hire_date := SYSDATE;


   INSERT INTO employees VALUES 
   (
    v_emp_id,
    v_emp_name,
    v_department_id,
    v_salary,
    v_hire_date
    ); 

   COMMIT;

   DBMS_OUTPUT.PUT_LINE('inserted: ' || v_emp_id || ', ' || v_emp_name);

END;
/

--SELECT * FROM employees WHERE emp_id = 100;

--7. **Update Employee Salary**: Create a PL/SQL block that increases an employee's salary by 10% where the `emp_id` is given.
DECLARE
    v_emp_id NUMBER;
    v_row employees%ROWTYPE;
BEGIN
    v_emp_id := 100;


    SELECT *
    INTO v_row
    FROM employees
    WHERE emp_id = v_emp_id;

    DBMS_OUTPUT.PUT_LINE('before: ' || v_row.emp_id || ', ' || v_row.emp_name || ',' || v_row.salary);

    UPDATE EMPLOYEES
    SET salary = salary * 1.10
    WHERE emp_id = v_emp_id; 

    COMMIT;

    SELECT *
    INTO v_row
    FROM employees
    WHERE emp_id = v_emp_id;

    DBMS_OUTPUT.PUT_LINE('after: ' || v_row.emp_id || ', ' || v_row.emp_name || ',' || v_row.salary);

END;
/



--8. **Delete Employee Record**: Write a PL/SQL block that deletes an employee from the `employees` table based on `emp_id`.
DECLARE
    v_row employees%ROWTYPE;
BEGIN
    SELECT *
    INTO v_row
    FROM employees
    WHERE emp_id = 100;

    DELETE FROM employees WHERE emp_id = v_row.emp_id;

    DBMS_OUTPUT.PUT_LINE('deleted: ' || v_row.emp_id || ', ' || v_row.emp_name);
END;
/


--9. **Retrieve Employee Information**: Create a PL/SQL block that retrieves and prints an employee's name and salary from the `employees` table.

DECLARE
    v_emp_id NUMBER;
    v_row employees%ROWTYPE;
BEGIN
    v_emp_id := 100;

    SELECT *
    INTO v_row
    FROM employees
    WHERE emp_id = v_emp_id;

    DBMS_OUTPUT.PUT_LINE('record: ' || v_row.emp_id || ', ' || v_row.emp_name || ',' || v_row.salary);

END;
/


--10. **Check Employee Department**: Write a PL/SQL block that checks if an employee belongs to a certain department and prints a message accordingly.


DECLARE
    v_emp_id NUMBER;
    v_dep_row departments%ROWTYPE;
    -- v_start TIMESTAMP;
    -- v_end   TIMESTAMP;
    -- v_diff  INTERVAL DAY TO SECOND;
BEGIN
    v_emp_id := 101;

    -- v_start := SYSTIMESTAMP;

    SELECT dep.*
    INTO v_dep_row
    FROM employees emp
    LEFT JOIN departments dep ON emp.department_id = dep.department_id
    WHERE emp.EMP_ID = v_emp_id;

    -- v_end := SYSTIMESTAMP;
    -- v_diff := v_end - v_start;
    -- DBMS_OUTPUT.PUT_LINE('Elapsed time: ' || v_diff);

    DBMS_OUTPUT.PUT_LINE('record: ' || v_emp_id || ' --- ' || v_dep_row.department_id || ', ' || v_dep_row.department_name );

END;
/

---

--### **Cursor and Loop Challenges**
--11. **Explicit Cursor for Employees**: Write a PL/SQL block that uses an explicit cursor to fetch and print all employee names.

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
/


--12. **Implicit Cursor for Salary Update**: Write a PL/SQL block that updates the salary of all employees by 5% and prints how many rows were affected.

BEGIN

    UPDATE employees 
    SET salary = 75000
    Where employees.EMP_ID = 101;

    UPDATE employees 
    SET salary = 60000
    Where employees.EMP_ID = 102;

    UPDATE employees 
    SET salary = 55000
    Where employees.EMP_ID = 103;
END;
/



DECLARE 
    TYPE emp_table IS TABLE OF employees%ROWTYPE;
    v_emp_data emp_table;
BEGIN

    SELECT * BULK COLLECT 
    INTO v_emp_data 
    FROM employees;

    DBMS_OUTPUT.PUT_LINE('before:');
    FOR i IN v_emp_data.FIRST .. v_emp_data.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_data(i).emp_name || ' earns ' || v_emp_data(i).salary);
    END LOOP;

    UPDATE employees SET salary = salary * 1.05;
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Employees updated: ' || SQL%ROWCOUNT);
    END IF;

    SELECT * BULK COLLECT 
    INTO v_emp_data 
    FROM employees;

    DBMS_OUTPUT.PUT_LINE('after:');
    FOR i IN v_emp_data.FIRST .. v_emp_data.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_data(i).emp_name || ' earns ' || v_emp_data(i).salary);
    END LOOP;
END;
/

select * from employees;

--13. **Cursor with Parameters**: Create a cursor that retrieves employees from a specific department.

DECLARE
    v_department_id NUMBER := 1;
    CURSOR emp_cursor (p_department_id NUMBER) IS
        SELECT emp_name
        FROM employees
        WHERE department_id = p_department_id;
    v_emp_name employees.emp_name%TYPE;
BEGIN
    OPEN emp_cursor(v_department_id);
    LOOP
        FETCH emp_cursor INTO v_emp_name;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_emp_name); 
    END LOOP;
    CLOSE emp_cursor;
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_department_id);
END;
/

--14. **Fetch Multiple Rows with BULK COLLECT**: Use `BULK COLLECT` to retrieve multiple employee records at once and print their names.
--DESCRIBE employees;




DECLARE
    TYPE emp_table IS TABLE OF employees%ROWTYPE;
    v_emp_data emp_table;


    FUNCTION format_emp(p_emp employees%ROWTYPE) RETURN VARCHAR2 IS
    BEGIN
    RETURN p_emp.emp_id || ', ' ||
            p_emp.emp_name || ', ' ||
            p_emp.department_id || ', ' ||
            p_emp.salary || ', ' ||
            TO_CHAR(p_emp.hire_date, 'YYYY-MM-DD');
    END;
BEGIN
    SELECT * BULK COLLECT INTO v_emp_data FROM employees;

    FOR i IN v_emp_data.FIRST .. v_emp_data.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(format_emp(v_emp_data(i)));
    END LOOP;

    --good but the function works also
    /*
    FOR i IN v_emp_data.FIRST .. v_emp_data.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_data(i).emp_id || ', ' || v_emp_data(i).emp_name || ', ' || v_emp_data(i).department_id || ', ' || v_emp_data(i).salary || ', ' || v_emp_data(i).HIRE_DATE);
    END LOOP;
    */
END;
/


---

--### **Exception Handling**
--15. **Handle NO_DATA_FOUND Exception**: Write a PL/SQL block that attempts to retrieve an employee with a non-existent `emp_id` and handles the exception.

DECLARE
    v_emp_id NUMBER := 666;
    v_row employees%ROWTYPE;
BEGIN

    SELECT
        *
        INTO v_row
    FROM 
        EMPLOYEES
    WHERE emp_id = v_emp_id;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee found!');

END;
/


--16. **Handle DUP_VAL_ON_INDEX Exception**: Insert a duplicate employee record and handle the unique constraint violation.

DECLARE
    v_emp_id NUMBER := 101;
    v_emp_name VARCHAR2(100) := 'Satan';
    v_dep_id NUMBER := 1;
    v_sal NUMBER(10,2) := 100.00;
    v_hire_date DATE := SYSDATE;

BEGIN

    INSERT INTO EMPLOYEES
    VALUES (v_emp_id,v_emp_name,v_dep_id,v_sal,v_hire_date);

EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('duplicate employee...not updated');

END;
/


--17. **Handle TOO_MANY_ROWS Exception**: Write a PL/SQL block that selects an employee name where multiple rows are returned, and handle the error.


DECLARE
    v_row employees%ROWTYPE;
BEGIN

    SELECT
        *
        INTO v_row
    FROM 
        EMPLOYEES
    WHERE ROWNUM < 100;

EXCEPTION

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('too many rows');

END;
/


--18. **Handle INVALID_NUMBER Exception**: Write a block that tries to insert a non-numeric value into a salary column and handles the exception.

DESCRIBE Salary;


BEGIN

    UPDATE employees SET salary = 'Monies'
    WHERE emp_id = 101;

EXCEPTION

    WHEN INVALID_NUMBER THEN
        DBMS_OUTPUT.PUT_LINE('THAT IS NOT A NUMBER');

END;
/

---

--### **Stored Procedures and Functions**
--19. **Create a Procedure to Update Salary**: Write a stored procedure `update_salary` that takes `emp_id` and `percentage` as input and updates the salary.

CREATE OR REPLACE PROCEDURE update_salary (
   p_emp_id IN employees.emp_id%TYPE,
   p_percentage IN NUMBER
) AS 
    v_row employees%ROWTYPE;
BEGIN

    select 
        * into v_row
    from employees
    WHERE emp_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('before: ' || v_row.EMP_ID || ', ' || v_row.EMP_NAME || ', '|| v_row.SALARY);

    --must be greater than zero
    IF p_percentage <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('percent less than or equal to zero');
        RETURN;
    END IF;

    UPDATE employees
    SET salary = salary * ( (100 + p_percentage) / 100)
    WHERE emp_id = p_emp_id;

    COMMIT;

    select 
        * into v_row
    from employees
    WHERE emp_id = p_emp_id;

    DBMS_OUTPUT.PUT_LINE('after: ' || v_row.EMP_ID || ', ' || v_row.EMP_NAME || ', '|| v_row.SALARY);

END update_salary;
/

EXEC update_salary(101,5);
EXEC update_salary(101,0);



--20. **Create a Function to Get Employee Salary**: Write a function `get_salary` that returns the salary of an employee given `emp_id`.

CREATE or REPLACE FUNCTION get_salary (
    p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER 
AS
    v_salary employees.salary%TYPE;
BEGIN

   SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
   DBMS_OUTPUT.PUT_LINE(v_salary);
   RETURN v_salary;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NOT FOUND');
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
        
END;
/

SELECT get_salary(101) FROM dual;

--21. **Create a Procedure to Hire an Employee**: Create a stored procedure that inserts a new employee into the `employees` table.


CREATE OR REPLACE PROCEDURE hire_person (
    v_emp_name VARCHAR2,
    v_dep_id number,
    v_salary number
) AS 
    v_row employees%ROWTYPE;
    v_hire_date DATE := SYSDATE;
    v_emp_id employees.EMP_ID%TYPE;
BEGIN


    --must be greater than zero
    IF v_salary <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('percent less than or equal to zero');
        RETURN;
    END IF;

    select 
        MAX(employees.EMP_ID) + 1
        INTO v_emp_id
    from EMPLOYEES;


    INSERT INTO EMPLOYEES
    --(emp_id,emp_name,department_id,salary,hire_date)
    VALUES (v_emp_id,v_emp_name,v_dep_id,v_salary,v_hire_date);

    COMMIT;

    select 
        * into v_row
    from employees
    WHERE emp_name = v_emp_name
    and hire_date = v_hire_date;

    DBMS_OUTPUT.PUT_LINE('hired: ' || v_row.EMP_ID || ', ' || v_row.EMP_NAME || ', '|| v_row.SALARY);

END hire_person;
/

EXEC hire_person('Dave',1,100);

select * from EMPLOYEES;


--22. **Function to Count Employees in a Department**: Write a function that takes a `department_id` as input and returns the count of employees in that department.


CREATE or REPLACE FUNCTION dep_count (
    p_dep_id IN NUMBER
) RETURN NUMBER 
AS
    COUNT_ NUMBER;
BEGIN

   SELECT COUNT(*) INTO COUNT_ FROM EMPLOYEES WHERE DEPARTMENT_ID = p_dep_id;
   DBMS_OUTPUT.PUT_LINE(COUNT_);
   RETURN COUNT_;

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('NOT FOUND');
        DBMS_OUTPUT.PUT_LINE('Error message: ' || SQLERRM);
        
END;
/


select dep_count(1) from dual;
select dep_count(2) from dual;

---

--### **Triggers**
--23. **Before Insert Trigger for Employees**: Write a trigger that automatically sets the `hire_date` to `SYSDATE` before inserting a new employee.


SELECT owner, table_name
FROM all_tables
WHERE table_name = 'EMPLOYEES';


CREATE or REPLACE TRIGGER before_insert_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
DECLARE
    --nothing to declare
BEGIN
    :NEW.hire_date := SYSDATE;
END;
/

BEGIN
    INSERT INTO EMPLOYEES
    (emp_id,emp_name,department_id,salary)
    VALUES (666,'new guy',1,100);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting employee: ' || SQLERRM);
END;
/

select * from EMPLOYEES;

--24. **After Insert Trigger for Salary Log**: Create a trigger that logs every new salary change into a `salary_history` table.


SELECT owner, table_name
FROM all_tables
WHERE table_name = 'SALARY_HISTORY';


CREATE or REPLACE TRIGGER trg_salary_history
AFTER UPDATE ON employees
FOR EACH ROW   
DECLARE
    --nothing to declare
BEGIN
    
    INSERT INTO salary_history (
        emp_id,
        salary,
        change_date
    ) VALUES (
        :NEW.emp_id,
        :NEW.salary,
        SYSDATE
    );

    DBMS_OUTPUT.PUT_LINE(:NEW.emp_id || ' ' || :NEW.salary || ' ' || SYSDATE || ' '  );

END;
/

EXEC update_salary(101,5);
select * from SALARY_HISTORY;

--25. **Prevent Deletion of Certain Employees**: Write a trigger that prevents employees from being deleted if they belong to the management department.

select * from DEPARTMENTS;

CREATE or REPLACE TRIGGER trg_prevent_delete
BEFORE DELETE ON employees
FOR EACH ROW 
DECLARE 
    v_department_name VARCHAR2(100);  
BEGIN
    
    SELECT department_name
    INTO v_department_name
    FROM departments
    WHERE department_id = :OLD.department_id;

    if v_department_name = 'Management' then
        RAISE_APPLICATION_ERROR(-20000, 'Cannot delete employee from management department');
    END IF;

END;
/

INSERT INTO employees VALUES (-1, 'Mr.Smith', 4, 75000, SYSDATE);
DELETE FROM employees WHERE emp_id = -1;
select * from EMPLOYEES WHERE emp_id = -1;

---

--### **PL/SQL Collections**
--26. **Use PL/SQL Table (Nested Table)**: Declare a nested table of employee names and print all values.
/
DECLARE
    TYPE emp_name_table IS TABLE OF employees.emp_name%TYPE;
    v_emp_names emp_name_table;
BEGIN   
    v_emp_names := emp_name_table('John Doe', 'Jane Smith', 'Alice Johnson');

    FOR i IN v_emp_names.FIRST .. v_emp_names.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_names(i));
    END LOOP;
END;

--27. **Use VARRAY to Store Employee Bonuses**: Declare a VARRAY to store bonus amounts for employees and print all values.


/
DECLARE
    TYPE bonus_array IS VARRAY(5) OF bonus_type;
    v_bonuses bonus_array := bonus_array(
        bonus_type(101, 1000),
        bonus_type(102, 1500),
        bonus_type(103, 2000)
    );
BEGIN
    FOR i IN v_bonuses.FIRST .. v_bonuses.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonuses(i).emp_id || ' ' || v_bonuses(i).bonus_amount);
    END LOOP;
END;
/
---

--### **Dynamic SQL and Performance Optimization**
--28. **Dynamic SQL for Table Updates**: Write a PL/SQL block that takes a table name and updates all employees' salaries dynamically.

DECLARE
    v_table_name VARCHAR2(100) := 'EMPLOYEES';
    v_sql VARCHAR2(1000);
BEGIN
    v_sql := 'UPDATE ' || v_table_name || ' SET salary = salary * 1.10';
    EXECUTE IMMEDIATE v_sql;

    DBMS_OUTPUT.PUT_LINE('Updated salaries in table: ' || v_table_name);
END;
/

select * from SALARY_HISTORY;
/


--29. **Optimize Bulk Update Using FORALL**: Use `FORALL` to update multiple employee salaries at once.



DECLARE
    TYPE bonus_array IS VARRAY(5) OF bonus_type;
    v_bonuses bonus_array := bonus_array(
        bonus_type(101, 1000),
        bonus_type(102, 1500),
        bonus_type(103, 2000)
    );
BEGIN
    FORALL i IN v_bonuses.FIRST .. v_bonuses.LAST
        UPDATE employees
        SET salary = salary + v_bonuses(i).bonus_amount
        WHERE emp_id = v_bonuses(i).emp_id;

    DBMS_OUTPUT.PUT_LINE('Updated salaries using FORALL');
END;
/


select * from SALARY_HISTORY;

--30. **Use EXPLAIN PLAN to Optimize Query**: Write a PL/SQL block that uses `EXPLAIN PLAN` to analyze the performance of a SELECT query.

---


--'PLAN_TABLE' is the default table for EXPLAIN PLAN
DROP TABLE EXPLAIN_PLAN_TABLE CASCADE CONSTRAINTS PURGE;
COMMIT;

CREATE TABLE EXPLAIN_PLAN_TABLE (
    statement_id    VARCHAR2(30),
    plan_id         NUMBER,
    timestamp       DATE,
    remarks         VARCHAR2(4000),
    operation       VARCHAR2(30),
    options         VARCHAR2(255),
    object_node     VARCHAR2(128),
    object_owner    VARCHAR2(30),
    object_name     VARCHAR2(30),
    object_alias    VARCHAR2(65),
    object_instance NUMBER,
    object_type     VARCHAR2(30),
    optimizer       VARCHAR2(255),
    search_columns  NUMBER,
    id              NUMBER,
    parent_id       NUMBER,
    depth           NUMBER,
    position        NUMBER,
    cost            NUMBER,
    cardinality     NUMBER,
    bytes           NUMBER,
    other_tag       VARCHAR2(255),
    partition_start VARCHAR2(255),
    partition_stop  VARCHAR2(255),
    partition_id    NUMBER,
    other           LONG,
    distribution    VARCHAR2(30),
    cpu_cost        NUMBER,
    io_cost         NUMBER,
    temp_space      NUMBER,
    access_predicates VARCHAR2(4000),
    filter_predicates VARCHAR2(4000),
    projection      VARCHAR2(4000),
    time            NUMBER,
    qblock_name     VARCHAR2(30),
    other_xml       CLOB
);
COMMIT;

DECLARE 
    v_sql VARCHAR2(1000);
    v_plan_table VARCHAR2(100) := 'EXPLAIN_PLAN_TABLE';
BEGIN
    v_sql := 'EXPLAIN PLAN 
                SET STATEMENT_ID = ''TEST00''
                INTO ' || v_plan_table || '
                FOR
                    SELECT * FROM employees WHERE emp_id = 101';
    EXECUTE IMMEDIATE v_sql;

    DBMS_OUTPUT.PUT_LINE('Execution plan generated for query: ' || v_sql);
END;
/


select * from EXPLAIN_PLAN_TABLE 
WHERE statement_id = 'TEST00';
