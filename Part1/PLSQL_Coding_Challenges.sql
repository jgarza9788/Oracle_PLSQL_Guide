
--### **Basic PL/SQL Challenges**
--1. **Hello PL/SQL**: Write a simple PL/SQL block that prints "Hello, PL/SQL!" using `DBMS_OUTPUT.PUT_LINE`.

--2. **Declare and Assign Variables**: Declare a variable for an employee’s name and salary, assign values, and print them.

--3. **IF-THEN-ELSE Control Structure**: Write a PL/SQL block that checks if an employee's salary is greater than 50000. If so, print "High Salary", otherwise "Low Salary".

--4. **FOR Loop Basics**: Create a PL/SQL block that prints numbers from 1 to 10 using a `FOR LOOP`.

--5. **WHILE Loop Basics**: Create a PL/SQL block that starts with a salary of 30000 and increases it by 5000 until it reaches 60000.

---

--### **Working with Tables (Using PLSQL_Environment_SetUp.sql Tables)**
--6. **Insert Employee**: Write a PL/SQL block that inserts a new employee into the `employees` table.

--7. **Update Employee Salary**: Create a PL/SQL block that increases an employee's salary by 10% where the `emp_id` is given.

--8. **Delete Employee Record**: Write a PL/SQL block that deletes an employee from the `employees` table based on `emp_id`.

--9. **Retrieve Employee Information**: Create a PL/SQL block that retrieves and prints an employee's name and salary from the `employees` table.

--10. **Check Employee Department**: Write a PL/SQL block that checks if an employee belongs to a certain department and prints a message accordingly.

---

--### **Cursor and Loop Challenges**
--11. **Explicit Cursor for Employees**: Write a PL/SQL block that uses an explicit cursor to fetch and print all employee names.

--12. **Implicit Cursor for Salary Update**: Write a PL/SQL block that updates the salary of all employees by 5% and prints how many rows were affected.

--13. **Cursor with Parameters**: Create a cursor that retrieves employees from a specific department.

--14. **Fetch Multiple Rows with BULK COLLECT**: Use `BULK COLLECT` to retrieve multiple employee records at once and print their names.

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
