-- 1. Find the Student details and Placement details using NATURAL JOIN.

SELECT s.*, p.*
FROM
student s
NATURAL JOIN placementdrive p;
/*
+------+--------+------+----------+------------+----------+------+----------+---------------+----------+-----------+
| s_id | s_name | cgpa | s_branch | s_dob      | drive_id | t_id | drive_id | pcompany_name | package  | plocation |
+------+--------+------+----------+------------+----------+------+----------+---------------+----------+-----------+
|   12 | Advait | 8.89 | Computer | 2004-01-01 |        4 |    6 |        4 | General Mills | 30000.00 | Mumbai    |
|   13 | Aniket | 8.09 | Computer | 2004-08-07 |        2 |    7 |        2 | Mastercard    | 40000.00 | Pune      |
|   14 | Rinit  | 7.80 | Computer | 2004-08-07 |        7 |    9 |        7 | Siemens       | 30000.00 | Pune      |
|   15 | Maynak | 7.52 | Computer | 2004-03-07 |       10 |    5 |       10 | IBM           | 30000.00 | Nashik    |
|   16 | Arnav  | 8.59 | It       | 2004-05-07 |       11 |    8 |       11 | Intel         | 40000.00 | Kolhapur  |
|   18 | Prabhu | 7.02 | Entc     | 2004-10-07 |       11 |    6 |       11 | Intel         | 40000.00 | Kolhapur  |
|   20 | Arya   | 8.95 | It       | 2004-09-07 |        8 |    3 |        8 | BNY Mellon    | 50000.00 | Mumbai    |
+------+--------+------+----------+------------+----------+------+----------+---------------+----------+-----------+
*/


-- 2. Find all the student details with company_name who have conducted in same drive

SELECT s.*, p.pcompany_name
FROM
student s
INNER JOIN
placementdrive p
ON s.drive_id = p.drive_id
ORDER BY s.drive_id;

/*
+------+--------+------+----------+------------+----------+------+---------------+
| s_id | s_name | cgpa | s_branch | s_dob      | drive_id | t_id | pcompany_name |
+------+--------+------+----------+------------+----------+------+---------------+
|   13 | Aniket | 8.09 | Computer | 2004-08-07 |        2 |    7 | Mastercard    |
|   12 | Advait | 8.89 | Computer | 2004-01-01 |        4 |    6 | General Mills |
|   14 | Rinit  | 7.80 | Computer | 2004-08-07 |        7 |    9 | Siemens       |
|   20 | Arya   | 8.95 | It       | 2004-09-07 |        8 |    3 | BNY Mellon    |
|   15 | Maynak | 7.52 | Computer | 2004-03-07 |       10 |    5 | IBM           |
|   16 | Arnav  | 8.59 | It       | 2004-05-07 |       11 |    8 | Intel         |
|   18 | Prabhu | 7.02 | Entc     | 2004-10-07 |       11 |    6 | Intel         |
+------+--------+------+----------+------------+----------+------+---------------+
*/

-- 3. List all the Student name and Student branch of Student having package 50k

SELECT s.s_name AS 'student with package = 50k'
FROM student s
INNER JOIN placementdrive p
ON s.drive_id = p.drive_id
WHERE
p.package = 50000;

/*
+----------------------------+
| student with package = 50k |
+----------------------------+
| Arya                       |
+----------------------------+
*/


-- 4. List all the student names ,company_name having T_fee more than 20000

SELECT s.s_name, t.tcompany_name
FROM student s
LEFT JOIN training t
ON s.t_id = t.t_id
WHERE
t.t_fee > 20000;

-- 5. Display all training details attended by “shantanu” in year 2011

SELECT s.s_name, t.*
FROM
student s,
training t
WHERE
s.t_id = t.t_id
AND
s.s_name = "Arya";

/*
+--------+------+---------------+----------+--------+
| s_name | t_id | tcompany_name | t_fee    | t_year |
+--------+------+---------------+----------+--------+
| Arya   |    3 | Barclays      | 20000.00 |   2021 |
+--------+------+---------------+----------+--------+
*/

-- 6. list the total number of companies who conduct training before 2015

SELECT COUNT(tcompany_name) FROM
training
WHERE
t_year < 2020;

-- 7. List the students name with company ‘Microsoft’ and location ’Thane’

SELECT s_name, p.*
FROM
student s
LEFT JOIN
placementdrive p
ON s.drive_id = p.drive_id
WHERE
pcompany_name = 'Mastercard'
AND
plocation = 'Pune';

-- 8. Find the names of all Students who have joined ‘Microsoft ‘ training in 2015 .

SELECT s.s_name
FROM
student s
LEFT JOIN training t
ON s.t_id = t.t_id
WHERE
t.tcompany_name = 'Barclays'
AND
t.t_year = '2021';

-- 9. Create a view showing the Student and Training details.

CREATE VIEW student_training_details AS
SELECT *
FROM
student s
NATURAL JOIN
training t;


-- 10. Perform Manipulation on simple view-Insert, update, delete, drop view.