#----------SELECT----------
SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name, last_name, birth_date, age, (age + 10) + 5 AS 'age after calc'
FROM parks_and_recreation.employee_demographics;

# To add comment

SELECT DISTINCT GENDER
FROM parks_and_recreation.employee_demographics;		

SELECT DISTINCT first_name, gender # Select unique combination of First name & Gender
FROM parks_and_recreation.employee_demographics;	

#------------WHERE--------------
SELECT *
FROM employee_salary
WHERE first_name = 'Leslie';

SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_demographics
WHERE gender != 'Female';    # NOT equal to !=

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-12-24'; 

#------------AND OR NOT: LOGICAL OPERATORS---------------
SELECT *
FROM employee_demographics
WHERE (birth_date > '1985-12-24' AND NOT gender = 'Male' AND NOT AGE = 29) OR AGE > 55;


#-------------LIKE STATEMENT-----------------------
# %: anything
# _: specific value
SELECT *
FROM employee_demographics
WHERE first_name LIKE '_er%';

SELECT *
FROM employee_demographics
WHERE birth_Date LIKE '1989%';

#------------HAVING--------------HAVING is only used to filter in GROUP BY. W/o GROUP BY, it cant be used
SELECT gender, AVG(AGE)
FROM employee_demographics
WHERE AVG(age) > 40
GROUP BY gender;   #This wont work. WHERE happens BEFORE the grouping is performed, hence, it doesnt make sense

#As the above statement doesnt work, we use HAVING instead
SELECT gender, AVG(AGE)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;    #HAVING happens AFTER the grouping is performed

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;   # To filter aggregate function column, Have to use HAVING clause


#-----LIMIT--------
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 5;  #Top 5 the oldest

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 3;   # Order by age desc first then start from row 2, get the 3 rows after row 2

#-----ALIASING--------
SELECT gender, AVG(age) AS 'avg_age'
FROM employee_demographics
GROUP BY gender
HAVING AVG(Age) > 40;

SELECT gender, AVG(age) 'avg_age'    #It still works if we get rid of AS
FROM employee_demographics
GROUP BY gender
HAVING AVG(Age) > 40;


#-----------GROUP BY--------------
SELECT gender
FROM employee_demographics
GROUP BY gender;

# The above statement will have same result with DISTINCT as below
SELECT DISTINCT gender
FROM employee_demographics;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

SELECT DISTINCT occupation, salary
FROM employee_salary;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

#-----------ORDER BY--------------
SELECT *
FROM employee_demographics
ORDER BY first_name;  #by default: ASCENDING order

SELECT *
FROM employee_demographics
ORDER BY first_name ASC;

SELECT *
FROM employee_demographics
ORDER BY first_name DESC;


SELECT *
FROM employee_demographics
ORDER BY gender ASC, age DESC;  # Order by gender first, then by age

SELECT *
FROM employee_demographics
ORDER BY age, gender;  #The order of columns to order is important. If age is put first, since age do not have duplicated value, gender does not sort

# Can use column position in ORDER BY instead of column name, but this is NOT RECOMMENDED
SELECT *
FROM employee_demographics
ORDER BY 5, 4; 


#--------------JOIN------------------------Combine comlumns together
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

# INNER JOIN - only bring over the rows having the same value in 2 columns in 2 tables. Those missing will be left out.
SELECT *
FROM employee_demographics
INNER JOIN employee_salary		#By default, JOIN = INNER JOIN
	ON employee_demographics.employee_id = employee_salary.employee_id
;

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal	
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal	
	ON dem.employee_id = sal.employee_id
;

SELECT dem.employee_id, age, occupation #if 1 column having a same name in 2 tables, need to indicate the table name
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal	
	ON dem.employee_id = sal.employee_id
;


# OUTER JOIN - includes LEFT JOIN and RIGHT JOIN
# LEFT JOIN: bring everything from the left table
# RIGHT JOIN: bring everything from the right table

SELECT *
FROM employee_demographics AS dem
LEFT OUTER JOIN employee_salary AS sal		#Can use LEFT OUTER JOIN or LEFT JOIN
	ON dem.employee_id = sal.employee_id
;

SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal	
	ON dem.employee_id = sal.employee_id
;

SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal	
	ON dem.employee_id = sal.employee_id
;


# SELF JOIN - to tie the table to itself
SELECT emp1.employee_id AS emp_santa, 
	   emp1.first_name AS first_name_santa, 
       emp1.last_name AS last_name_santa,
       emp2.employee_id AS emp_name, 
	   emp2.first_name AS first_name_emp, 
       emp2.last_name AS last_name_emp
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id 
;

# JOINING MULTIPLE TABLES TOGETHER
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
	ON sal.dept_id = pd.department_id
;

SELECT * 
FROM parks_departments;

#------------UNIONS------------Combine rows together
SELECT age, gender
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name
FROM employee_demographics
UNION                 # By default, it is a UNION DISTINCT - only get unique value
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name
FROM employee_demographics
UNION ALL      # Instead of DISTINCT, use all to show all value even they are duplicated.
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name, 'Old'
FROM employee_demographics
WHERE age > 40;

SELECT first_name, last_name, 'Old' AS Label
FROM employee_demographics
WHERE age > 40;

SELECT first_name, last_name, 'Old' AS Label
FROM employee_demographics
WHERE age > 40
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000;


SELECT first_name, last_name, 'Old man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;


#----------------STRING function---------------
SELECT LENGTH('sky');

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY LENGTH(first_name);

SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT TRIM('         Sky            ');   #Remove space before and after
SELECT LTRIM('         Sky            ');   #Remove space in the left 
SELECT RTRIM('         Sky            ');   #Remove space in the right 

SELECT first_name, 
		LEFT(first_name, 4),
		RIGHT(first_name, 4),
        SUBSTRING(first_name, 3, 2),
        birth_date,
        SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

SELECT LOCATE('y', 'Nguyen My Duyen');

SELECT first_name, LOCATE('An', first_name)
FROM employee_demographics;

SELECT first_name, 
		last_name,
		CONCAT(first_name, ' ',last_name) AS 'Full_Name'
FROM employee_demographics;


#-----------------CASE STATEMENTS--------------------
SELECT first_name,
	   last_name,
       age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN 'Too old haha'
END AS 'age_comment'
FROM employee_demographics;

#-----Pay increase & Bonus----------
#---- < 50000 then 5% increase
#---- > 50000 then 7% increase
#---- work in Finance dept -> 10% Bonus

SELECT first_name,
	   last_name,
       salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary;


SELECT first_name,
	   last_name,
       salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
END AS new_salary,
	   dept.department_name,
CASE
	WHEN dept.department_name = 'Finance' THEN salary * .10
END AS bonus
FROM employee_salary
JOIN parks_departments AS dept
	ON employee_salary.dept_id = dept.department_id
;


#---------------SUBQUERIES----------------
SELECT *
FROM employee_demographics
WHERE employee_id IN 
	(SELECT employee_id
	FROM employee_salary
	WHERE dept_id = 1
	)
;


SELECT *
FROM employee_demographics
WHERE employee_id IN 
	(SELECT employee_id, dept_id  #This wont work as it has 2 columns. Only 1 column is allowed here
	FROM employee_salary
	WHERE dept_id = 1
	)
;

#----Calculate average of salary among the entire employee
SELECT first_name, salary,
(SELECT AVG(salary) 
FROM employee_salary) AS avg_salary
FROM employee_salary;


SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;


SELECT gender, AVG(`MAX(age)`)   # Need to use `` instead of ''
FROM 
(SELECT gender, AVG(age), MAX(age) , MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Aggregated_table
GROUP BY gender	
;

SELECT AVG(max_age)   
FROM 
(SELECT gender, AVG(age), MAX(age) AS max_age, MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Aggregated_table
;


#-----------WINDOW FUNCTIONS----------Similar as GROUP BY 
SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender;

SELECT gender, AVG(salary) OVER()       # AVG(salary) OVER() is to calculate avg of salary of everybody, not by gender
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
SELECT gender, AVG(salary) OVER(PARTITION BY gender)        #PARTITION BY is kind of grouping
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;    
    

SELECT DISTINCT gender, AVG(salary) OVER(PARTITION BY gender)     
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;  

SELECT dem.first_name, dem.last_name, gender, AVG(salary) OVER(PARTITION BY gender)     
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;  


SELECT dem.first_name, dem.last_name, gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name, gender;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
	   SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
	   SUM(salary) OVER(ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary, ROW_NUMBER() OVER()
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary, ROW_NUMBER() OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary, 
	   ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary, 
	   ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,  #No duplication within a partition even if value of ORDER BY is same
       RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,		#There is a duplication if value of ORDER BY is same. The next order number is position number, not the subsequent number
	   DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num #There is a duplication if value of ORDER BY is same. The next order number is subsequent number
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


#----------------CTEs (COMMON TABLE EXPRESSION)-----------------------
#Instead of using subqueries, we use CTE for easier reading query, writing complicated query etc.

#Example of subquery
SELECT AVG(avg_sal)
FROM
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) AS example_subquery
;

#Start of CTE
WITH CTE_Example AS
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
#End of CTE
# Can use CTE only after creating it
SELECT AVG(avg_sal)
FROM CTE_Example
;

#This will NOT work because CTE can only be used right after creating it.
SELECT AVG(avg_sal)
FROM CTE_Example;

#Can create multiple CTE within 1 query
WITH CTE_Example1 AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example1 eg1
JOIN CTE_Example2 eg2
	ON eg1.employee_id = eg2.employee_id
;


WITH CTE_Example (Gender, Avg_sal, Max_sal, Min_sal, Count_sal) AS   #The column names here become default, they override all the names defined in the CTE 
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example
;


#-----------TEMPORARY TABLES-------------------
# 1 benefit of temp table is that it lasts as long as you are still within that session. You can open another SQL window to use temp table.
# But if you exit MySQL and comeback in, the temp table is no longer working.
# Same as CTE but it is mainly used for more advanced data transformation. It can also be used for stored procedures.

# 1st way to create a temporary table
CREATE TEMPORARY TABLE temp_table		#If remove TEMPORARY table, it will create a fixed table together with employee_salary etc.
(first_name varchar(50),
 last_name varchar(50),
 favorite_movie varchar(100)
)
;

SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES('Alex','Freberg','Queen of tears'),
	  ('Duyen','Nguyen','abc');

SELECT *
FROM temp_table;


# 2nd way to create a temporary table
CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;


#-----------------------STORED PROCEDURES-----------------------
#This is a way to save SQL code that can reuse in the future

# One of the way to create a stored procedure, but this is not BEST practice
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();


# This is a BEST practice to create a stored procedures
# $$ is a delimiter that we select to end all the subsequent statements. It can be anything e.g. //
DELIMITER $$   
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$   # End the statement with the delimiter selected on the top
DELIMITER ; 	# Need to set delimiter back to ; else $$ will be applied for all subsequent statements as a delimiter

CALL large_salaries3();

# Stored procedures using parameters
DELIMITER $$   
CREATE PROCEDURE large_salaries4(employee_id_param INT)
BEGIN
	SELECT first_name, salary
	FROM employee_salary
	WHERE employee_id = employee_id_param;
END $$  
DELIMITER ; 

CALL large_salaries4(1);


#-----------------------TRIGGERS AND EVENTS-----------------------
# Trigger is a block of code that is executed automatically when an event takes place on a specific table

# If 1 new emp is added in table employee_salary, emp_id, first name & last name will also be added to table emp_demographics
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary		#Can use BEFORE instead of AFTER depending on scenarios
    FOR EACH ROW 						#FOR EACH ROW: if there are 4 new emp added, this will be triggered 4 times
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);				#Can use NEW/OLD depending on scenarios
END $$
DELIMITER ;


INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13,'Duyen','Nguyen','Manager',1000000,NULL); 

SELECT *
FROM employee_salary;

SELECT *
FROM employee_demographics;


#-------------------EVENTS-------------------
#Events take place when it is scheduled

SELECT *
FROM employee_demographics;

#If emp is over 60, it is going to be deleted every 30 seconds
DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 50;
END $$
DELIMITER ;

#In case Events do not work:
SHOW VARIABLES LIKE 'event%';   #After executing this, if Value = OFF, need to update to ON
#Or sometimes you canNOT delete data from a table, go to Édit -> Preferences -> SQL Editor -> untick the checkbox at the bottom



