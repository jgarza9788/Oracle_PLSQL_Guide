
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

--16. **Handle DUP_VAL_ON_INDEX Exception**: Insert a duplicate employee record and handle the unique constraint violation.

--17. **Handle TOO_MANY_ROWS Exception**: Write a PL/SQL block that selects an employee name where multiple rows are returned, and handle the error.

--18. **Handle INVALID_NUMBER Exception**: Write a block that tries to insert a non-numeric value into a salary column and handles the exception.

---

--### **Stored Procedures and Functions**
--19. **Create a Procedure to Update Salary**: Write a stored procedure `update_salary` that takes `emp_id` and `percentage` as input and updates the salary.

--20. **Create a Function to Get Employee Salary**: Write a function `get_salary` that returns the salary of an employee given `emp_id`.

--21. **Create a Procedure to Hire an Employee**: Create a stored procedure that inserts a new employee into the `employees` table.

--22. **Function to Count Employees in a Department**: Write a function that takes a `department_id` as input and returns the count of employees in that department.

---

--### **Triggers**
--23. **Before Insert Trigger for Employees**: Write a trigger that automatically sets the `hire_date` to `SYSDATE` before inserting a new employee.

--24. **After Insert Trigger for Salary Log**: Create a trigger that logs every new salary change into a `salary_history` table.

--25. **Prevent Deletion of Certain Employees**: Write a trigger that prevents employees from being deleted if they belong to the management department.

---

--### **PL/SQL Collections**
--26. **Use PL/SQL Table (Nested Table)**: Declare a nested table of employee names and print all values.

--27. **Use VARRAY to Store Employee Bonuses**: Declare a VARRAY to store bonus amounts for employees and print all values.

---

--### **Dynamic SQL and Performance Optimization**
--28. **Dynamic SQL for Table Updates**: Write a PL/SQL block that takes a table name and updates all employees' salaries dynamically.

--29. **Optimize Bulk Update Using FORALL**: Use `FORALL` to update multiple employee salaries at once.

--30. **Use EXPLAIN PLAN to Optimize Query**: Write a PL/SQL block that uses `EXPLAIN PLAN` to analyze the performance of a SELECT query.

---
