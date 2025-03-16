CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(100) NOT NULL,
    department_id NUMBER,
    salary NUMBER(10,2),
    hire_date DATE DEFAULT SYSDATE
);

CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL
);

CREATE TABLE projects (
    project_id NUMBER PRIMARY KEY,
    project_name VARCHAR2(100) NOT NULL,
    start_date DATE,
    end_date DATE
);

CREATE TABLE employee_projects (
    emp_id NUMBER,
    project_id NUMBER,
    role VARCHAR2(50),
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE challenges (
    challenge_id NUMBER PRIMARY KEY,
    challenge_name VARCHAR2(100) NOT NULL,
    difficulty_level VARCHAR2(20) CHECK (difficulty_level IN ('Easy', 'Medium', 'Hard')),
    description CLOB
);

CREATE TABLE solutions (
    solution_id NUMBER PRIMARY KEY,
    challenge_id NUMBER,
    emp_id NUMBER,
    submission_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) CHECK (status IN ('Pending', 'Accepted', 'Rejected')),
    FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Insert sample data for testing challenges
INSERT INTO departments VALUES (1, 'IT');
INSERT INTO departments VALUES (2, 'HR');
INSERT INTO departments VALUES (3, 'Finance');

INSERT INTO employees VALUES (101, 'Alice Smith', 1, 75000, SYSDATE);
INSERT INTO employees VALUES (102, 'Bob Johnson', 2, 60000, SYSDATE);
INSERT INTO employees VALUES (103, 'Charlie Brown', 3, 55000, SYSDATE);

INSERT INTO projects VALUES (201, 'Project Alpha', SYSDATE, NULL);
INSERT INTO projects VALUES (202, 'Project Beta', SYSDATE, NULL);

INSERT INTO employee_projects VALUES (101, 201, 'Developer');
INSERT INTO employee_projects VALUES (102, 202, 'Manager');
INSERT INTO employee_projects VALUES (103, 201, 'Tester');

INSERT INTO challenges VALUES (301, 'Basic SQL Query', 'Easy', 'Write a query to list all employees.');
INSERT INTO challenges VALUES (302, 'Join Challenge', 'Medium', 'Write a query to list employees and their project roles.');
INSERT INTO challenges VALUES (303, 'Aggregate Functions', 'Hard', 'Find the total salary of employees by department.');

COMMIT;
