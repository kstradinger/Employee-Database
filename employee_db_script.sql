-- Database: Employee_info_db

-- DROP DATABASE "Employee_info_db";

CREATE DATABASE "Employee_info_db"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
	-- Create tables & import CSVs
	
CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      VARCHAR(1) 		NOT NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     VARCHAR(4)      NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE   	(dept_name)
);

CREATE TABLE dept_manager (
   dept_no      VARCHAR(4)      NOT NULL,
   emp_no       INT             NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no),
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
   PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE dept_employee (
	emp_no		INT 			NOT NULL,
	dept_no 	VARCHAR(255) 	NOT NULL,
	from_date 	DATE 			NOT NULL,
	to_date 	DATE			NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no 		INT				NOT NULL,
	titles 		VARCHAR 		NOT NULL,
	from_date 	DATE 			NOT NULL,
	to_date 	DATE 			NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE salaries (
	emp_no 		INT				NOT NULL,
	salary 		INT 			NOT NULL,
	from_date 	DATE 			NOT NULL,
	to_date 	DATE 			NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

--List the following details of each employee: employee number, last name, first name, gender, and salary.

	

	SELECT employees.emp_no, employees.last_name, employees.first_name, employees.gender, salaries.salary
	FROM salaries
	INNER JOIN employees ON
	(employees.emp_no = salaries.emp_no);


--List employees who were hired in 1986.

	SELECT first_name, last_name
	FROM employees
	WHERE hire_date >= '1986-01-01'
	AND hire_date <= '1986-12-31';
		
--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

	SELECT departments.dept_name, dept_manager.dept_no, dept_manager.emp_no, employees.first_name, employees.last_name, dept_manager.from_date, dept_manager.to_date
	FROM dept_manager
	NATURAL JOIN departments
	NATURAL JOIN employees;

--List the department of each employee with the following information: employee number, last name, first name, and department name.

	SELECT employees.first_name, employees.last_name, dept_employee.emp_no, departments.dept_name
	FROM employees
	NATURAL JOIN dept_employee
	NATURAL JOIN departments;

--List all employees whose first name is "Hercules" and last names begin with "B."
	
	SELECT first_name, last_name
	FROM employees
	WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%'
	
--List all employees in the Sales department, including their employee number, last name, first name, and department name.

	SELECT employees.first_name, employees.last_name, departments.dept_name, dept_employee.emp_no
	FROM employees
	NATURAL JOIN dept_employee
	NATURAL JOIN departments
	WHERE dept_name = 'Sales'
	
	Select * FROM departments

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

	SELECT employees.first_name, employees.last_name, departments.dept_name, dept_employee.emp_no
	FROM employees
	NATURAL JOIN dept_employee
	NATURAL JOIN departments
	WHERE dept_name = 'Sales'
	OR dept_name = 'Development'

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

	SELECT last_name,COUNT(*) AS "Number of employees" 
	FROM employees 
	GROUP BY last_name 
	ORDER BY "Number of employees" DESC;
