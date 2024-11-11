/*
Assignment No 3 (based on Student schema)
● Student (s_id, Drive_id,T_id,s_name,CGPA,s_branch,s_dob)
● Placement Drive( Drive_id, Pcompany_name,package,location)
● Training ( T_id,Tcompany_name,T_Fee,T_date)

Use the tables created in assignment no 2 and execute the following
queries:

1. Find the Student details and Placement details using NATURAL JOIN.
2. Find all the student details with company_name who have conducted in same drive
3. List all the Student name and Student branch of Student having package 5 LPA
4. List all the student names ,company_name having T_fee more than 20000
5. Display all training details attended by “shantanu” in year 2011
6. list the total number of companies who conduct training before 2015
7. List the students name with company ‘Microsoft’ and location ’Thane’
8. Find the names of all Students who have joined ‘Microsoft ‘ training in 2015 .
9. Create a view showing the Student and Training details.
10. Perform Manipulation on simple view-Insert, update, delete, drop view.

A3: Guidelines
Natural Join, Inner Join/Equi Join, Left Outer Join, Right Outer Join, Count Join, 2
queries on Subquery, complex view and manipulation on simple view must be
covered.

*/


-- FROM ASSIGNMENT 2

CREATE TABLE IF NOT EXISTS Branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50) unique NOT NULL
);
CREATE TABLE IF NOT EXISTS PlacementDrive (
    drive_id INT PRIMARY KEY AUTO_INCREMENT,
    pcompany_name VARCHAR(50) NOT NULL,
    package FLOAT NOT NULL,
    plocation VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS Training (
    t_id INT PRIMARY KEY AUTO_INCREMENT,
    tcompany_name VARCHAR(50) NOT NULL,
    t_fee INT,
    t_year YEAR
);
CREATE TABLE IF NOT EXISTS Student (
    s_id INT PRIMARY KEY AUTO_INCREMENT,
    s_name VARCHAR(50) NOT NULL,
    cgpa FLOAT,
    s_dob DATE,
    
    branch_id INT,    
    drive_id INT,
    t_id INT,

    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    FOREIGN KEY (drive_id) REFERENCES PlacementDrive(drive_id),
    FOREIGN KEY (t_id) REFERENCES Training(t_id)
);
INSERT INTO Branch VALUES
            (1, 'Computer Engineering'),
            (2, 'Information Technology'),
            (3, 'Electronics and Telecommunication');

INSERT INTO PlacementDrive (drive_id, pcompany_name, package, plocation) VALUES 
            (1,'BMC Softwares', 14, 'Pune'),
            (2,'Siemens', 11, 'Pune'),
            (3,'Tiaa India', 4.95, 'Banglore'),
            (4,'Deutsche Bank', 12.75, 'Mumbai'),
            (5,'UBS', 19.63, 'Mumbai'),
            (6,'UBS', 12.50, 'Mumbai'),
            (7,'Mastercard', 33.53, 'Pune'),
            (8,'Mastercard', 21.64, 'Mumbai'),
            (9,'Bajaj Finserv', 3.53, 'Mumbai'),
            (10,'Barclays',13.40, 'Banglore'),
            (11,'Barclays', 22.50, 'Mumbai'),
            (12,'eQ Technologies', 19.60, 'Pune'),
            (13,'eQ Technologies', 12.00, 'Banglore');

INSERT INTO Training (t_id, tcompany_name, t_fee, t_year) VALUES
            (1,'Barclays', 3000, '2023'),
            (2,'Barclays', 3000, '2026'),
            (3,'Siemens', 2200, '2024'),
            (4,'Siemens', 2000, '2023'),
            (5,'eQ Technologies', 1000, '2025'),
            (6,'eQ Technologies', 1000, '2026'),
            (7,'ZS Associates', 1000, '2026');

INSERT INTO Student (s_name, cgpa, s_dob, branch_id, drive_id, t_id) VALUES
            (
                'Tirthraj Mahajan', 
                9.5, 
                '2004-06-07', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='BMC Softwares' AND package = CAST(14 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Advait Joshi', 
                9.88, 
                '2004-01-01', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Siemens' AND package = CAST(11 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Amey Kulkarni', 
                9.77, 
                '2004-01-04', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Mastercard' AND package = CAST(33.53 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'eQ Technologies' and t_year = '2026')
            ),
            (
                'Aditya Mulay', 
                9.00, 
                '2004-01-26', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Mastercard' AND package = CAST(21.64 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'eQ Technologies' and t_year = '2026')
            ),
            (
                'Arnav Vaidya', 
                8.88, 
                '2004-05-20', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='UBS' AND package = CAST(19.63 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2023')
            ),
            (
                'Devendra Kumar', 
                7.98, 
                '2004-06-20', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Electronics and Telecommunication'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Bajaj Finserv' AND package = CAST(3.53 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            ),
            (
                'Deo Kulkarni', 
                8.63, 
                '2004-12-29', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Tiaa India' AND package = CAST(4.95 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            ),
            (
                'Ninad Palsule', 
                8.03, 
                '2004-09-17', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Deutsche Bank' AND package = CAST(12.75 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'ZS Associates' and t_year = '2026')
            ),
            (
                'Suvrat Ketkar', 
                6.95, 
                '2004-10-17', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Barclays' AND package = CAST(22.50 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Aniket Joshi', 
                6.55, 
                '2004-05-12', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Tiaa India' AND package = CAST(4.95 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Mayank Ketan', 
                6.99, 
                '2004-03-28', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Electronics and Telecommunication'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Bajaj Finserv' AND package = CAST(3.53 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            );


-- ASSIGNMENT 3

-- Find the Student details and Placement details using NATURAL JOIN
SELECT * FROM Student NATURAL JOIN PlacementDrive;

/* 
mysql> SELECT * FROM Student NATURAL JOIN PlacementDrive;
+----------+------+------------------+------+------------+-----------+------+---------------+---------+-----------+
| drive_id | s_id | s_name           | cgpa | s_dob      | branch_id | t_id | pcompany_name | package | plocation |
+----------+------+------------------+------+------------+-----------+------+---------------+---------+-----------+
|        1 |    1 | Tirthraj Mahajan |  9.5 | 2004-06-07 |         1 |    2 | BMC Softwares |      14 | Pune      |
|        2 |    2 | Advait Joshi     | 9.88 | 2004-01-01 |         1 |    2 | Siemens       |      11 | Pune      |
|        7 |    3 | Amey Kulkarni    | 9.77 | 2004-01-04 |         1 |    6 | Mastercard    |   33.53 | Pune      |
|        8 |    4 | Aditya Mulay     |    9 | 2004-01-26 |         2 |    6 | Mastercard    |   21.64 | Mumbai    |
|        5 |    5 | Arnav Vaidya     | 8.88 | 2004-05-20 |         2 |    4 | UBS           |   19.63 | Mumbai    |
|        9 |    6 | Devendra Kumar   | 7.98 | 2004-06-20 |         3 |    3 | Bajaj Finserv |    3.53 | Mumbai    |
|        3 |    7 | Deo Kulkarni     | 8.63 | 2004-12-29 |         2 |    3 | Tiaa India    |    4.95 | Banglore  |
|        4 |    8 | Ninad Palsule    | 8.03 | 2004-09-17 |         1 |    7 | Deutsche Bank |   12.75 | Mumbai    |
|       11 |    9 | Suvrat Ketkar    | 6.95 | 2004-10-17 |         1 |    2 | Barclays      |    22.5 | Mumbai    |
|        3 |   10 | Aniket Joshi     | 6.55 | 2004-05-12 |         2 |    2 | Tiaa India    |    4.95 | Banglore  |
|        9 |   11 | Mayank Ketan     | 6.99 | 2004-03-28 |         3 |    3 | Bajaj Finserv |    3.53 | Mumbai    |
+----------+------+------------------+------+------------+-----------+------+---------------+---------+-----------+
*/

-- Find all the student details with company_name who have conducted in same drive

SELECT s_name,cgpa,s_dob,branch_name,pcompany_name 
FROM Student 
NATURAL JOIN PlacementDrive 
NATURAL JOIN Branch 
ORDER BY pcompany_name;

/*
+------------------+------+------------+-----------------------------------+---------------+
| s_name           | cgpa | s_dob      | branch_name                       | pcompany_name |
+------------------+------+------------+-----------------------------------+---------------+
| Mayank Ketan     | 6.99 | 2004-03-28 | Electronics and Telecommunication | Bajaj Finserv |
| Devendra Kumar   | 7.98 | 2004-06-20 | Electronics and Telecommunication | Bajaj Finserv |
| Suvrat Ketkar    | 6.95 | 2004-10-17 | Computer Engineering              | Barclays      |
| Tirthraj Mahajan |  9.5 | 2004-06-07 | Computer Engineering              | BMC Softwares |
| Ninad Palsule    | 8.03 | 2004-09-17 | Computer Engineering              | Deutsche Bank |
| Amey Kulkarni    | 9.77 | 2004-01-04 | Computer Engineering              | Mastercard    |
| Aditya Mulay     |    9 | 2004-01-26 | Information Technology            | Mastercard    |
| Advait Joshi     | 9.88 | 2004-01-01 | Computer Engineering              | Siemens       |
| Deo Kulkarni     | 8.63 | 2004-12-29 | Information Technology            | Tiaa India    |
| Aniket Joshi     | 6.55 | 2004-05-12 | Information Technology            | Tiaa India    |
| Arnav Vaidya     | 8.88 | 2004-05-20 | Information Technology            | UBS           |
+------------------+------+------------+-----------------------------------+---------------+
*/

-- List all the Student name and Student branch of Student having package 5 LPA

SELECT s_name AS 'Student Names with Package < 5 LPA', 
branch_name AS 'Branch', 
package AS 'Package' 
FROM Student 
NATURAL JOIN PlacementDrive 
NATURAL JOIN Branch 
WHERE package < 7;

/*
+------------------------------------+-----------------------------------+---------+
| Student Names with Package < 5 LPA | Branch                            | Package |
+------------------------------------+-----------------------------------+---------+
| Devendra Kumar                     | Electronics and Telecommunication |    3.53 |
| Mayank Ketan                       | Electronics and Telecommunication |    3.53 |
| Deo Kulkarni                       | Information Technology            |    4.95 |
| Aniket Joshi                       | Information Technology            |    4.95 |
+------------------------------------+-----------------------------------+---------+
*/

-- List all the student names ,company_name having T_fee more than 2000

SELECT s_name AS 'Student Names with Training Fees > 2000', 
tcompany_name AS 'Training Company', 
t_fee AS 'Training Fee' 
FROM Student NATURAL JOIN Training
WHERE t_fee > 2000;

/*
+-----------------------------------------+------------------+--------------+
| Student Names with Training Fees > 2000 | Training Company | Training Fee |
+-----------------------------------------+------------------+--------------+
| Tirthraj Mahajan                        | Barclays         |         3000 |
| Advait Joshi                            | Barclays         |         3000 |
| Devendra Kumar                          | Siemens          |         2200 |
| Deo Kulkarni                            | Siemens          |         2200 |
| Suvrat Ketkar                           | Barclays         |         3000 |
| Aniket Joshi                            | Barclays         |         3000 |
| Mayank Ketan                            | Siemens          |         2200 |
+-----------------------------------------+------------------+--------------+
*/

-- Display all training details attended by “Tirthraj” in year 2026
SELECT 
tcompany_name AS 'Training Company',
t_fee AS 'Fees',
t_year AS 'Year'
FROM Training
NATURAL JOIN Student
WHERE s_name LIKE 'Tirthraj%';

/*
+------------------+------+------+
| Training Company | Fees | Year |
+------------------+------+------+
| Barclays         | 3000 | 2026 |
+------------------+------+------+
*/

-- list the total number of companies who conduct training before 2026

SELECT 
COUNT(tcompany_name) AS 'Total number of companies who conducted training before 2026' FROM Training 
WHERE t_year < 2026;

-- List the students name with company ‘Deutsche Bank’ and location ’Mumbai’
SELECT s_name AS 'Students who are placed in Deutsche Bank' 
FROM Student
NATURAL JOIN PlacementDrive
WHERE pcompany_name = 'Deutsche Bank'
AND plocation = 'Mumbai';
/*
+------------------------------------------+
| Students who are placed in Deutsche Bank |
+------------------------------------------+
| Ninad Palsule                            |
+------------------------------------------+
*/

-- Find the names of all Students who have joined Mastercard training in 2026.
SELECT 
s_name AS 'Students who have joined Mastercard in 2026'
FROM Student
JOIN PlacementDrive ON Student.drive_id = PlacementDrive.drive_id
JOIN Training ON Student.t_id = Training.t_id
WHERE 
PlacementDrive.pcompany_name = 'Mastercard' 
AND 
Training.t_year = '2026';

/*
+---------------------------------------------+
| Students who have joined Mastercard in 2026 |
+---------------------------------------------+
| Amey Kulkarni                               |
| Aditya Mulay                                |
+---------------------------------------------+
*/

-- Create a view showing the Student and Training details.

SELECT * FROM Student LEFT JOIN Training ON Student.t_id = Training.t_id;

/*
+------+------------------+------+------------+-----------+----------+------+------+-----------------+-------+--------+
| s_id | s_name           | cgpa | s_dob      | branch_id | drive_id | t_id | t_id | tcompany_name   | t_fee | t_year |
+------+------------------+------+------------+-----------+----------+------+------+-----------------+-------+--------+
|    1 | Tirthraj Mahajan |  9.5 | 2004-06-07 |         1 |        1 |    2 |    2 | Barclays        |  3000 |   2026 |
|    2 | Advait Joshi     | 9.88 | 2004-01-01 |         1 |        2 |    2 |    2 | Barclays        |  3000 |   2026 |
|    3 | Amey Kulkarni    | 9.77 | 2004-01-04 |         1 |        7 |    6 |    6 | eQ Technologies |  1000 |   2026 |
|    4 | Aditya Mulay     |    9 | 2004-01-26 |         2 |        8 |    6 |    6 | eQ Technologies |  1000 |   2026 |
|    5 | Arnav Vaidya     | 8.88 | 2004-05-20 |         2 |        5 |    4 |    4 | Siemens         |  2000 |   2023 |
|    6 | Devendra Kumar   | 7.98 | 2004-06-20 |         3 |        9 |    3 |    3 | Siemens         |  2200 |   2024 |
|    7 | Deo Kulkarni     | 8.63 | 2004-12-29 |         2 |        3 |    3 |    3 | Siemens         |  2200 |   2024 |
|    8 | Ninad Palsule    | 8.03 | 2004-09-17 |         1 |        4 |    7 |    7 | ZS Associates   |  1000 |   2026 |
|    9 | Suvrat Ketkar    | 6.95 | 2004-10-17 |         1 |       11 |    2 |    2 | Barclays        |  3000 |   2026 |
|   10 | Aniket Joshi     | 6.55 | 2004-05-12 |         2 |        3 |    2 |    2 | Barclays        |  3000 |   2026 |
|   11 | Mayank Ketan     | 6.99 | 2004-03-28 |         3 |        9 |    3 |    3 | Siemens         |  2200 |   2024 |
+------+------------------+------+------------+-----------+----------+------+------+-----------------+-------+--------+
*/

-- Perform Manipulation on simple view-Insert, update, delete, drop view.

-- Create a view to show min, avg and max cgpa from Students
CREATE VIEW cgpa_statistics AS 
SELECT min(cgpa) AS 'Minimum CGPA', 
avg(cgpa) AS 'Average CGPA', 
max(cgpa) AS 'Highest CGPA' 
FROM Student;

/*
+--------------+-------------------+--------------+
| Minimum CGPA | Average CGPA      | Highest CGPA |
+--------------+-------------------+--------------+
|         6.55 | 8.378181847659024 |         9.88 |
+--------------+-------------------+--------------+
*/

DROP VIEW cgpa_statistics;

-- Create a view to show the number of students placed branchwise that took training in year 2026
CREATE VIEW branchwise_placement_2026 AS 
SELECT 
Branch.branch_name AS 'Branch',
COUNT(StudentPlacements.s_id) AS 'Number of Students placed with CTC > 5 and Training in 2026'
FROM Branch
LEFT JOIN 
(
SELECT Student.s_id, Student.branch_id FROM Student
INNER JOIN Training ON Student.t_id = Training.t_id
INNER JOIN PlacementDrive ON Student.drive_id = PlacementDrive.drive_id
WHERE 
Training.t_year = '2026'
AND 
PlacementDrive.package > 5
) AS StudentPlacements
ON Branch.branch_id = StudentPlacements.branch_id 
GROUP BY Branch.branch_id;

SELECT * FROM branchwise_placement_2026;

/*
+-----------------------------------+-------------------------------------------------------------+
| Branch                            | Number of Students placed with CTC > 5 and Training in 2026 |
+-----------------------------------+-------------------------------------------------------------+
| Computer Engineering              |                                                           5 |
| Information Technology            |                                                           1 |
| Electronics and Telecommunication |                                                           0 |
+-----------------------------------+-------------------------------------------------------------+
*/


CREATE VIEW branchwise_placement_statistics_2026 AS
SELECT
Branch.branch_name AS 'Branch',
package_table.min_pkg AS 'Minimum_Package_in_2026',
package_table.avg_pkg AS 'Average_Package_in_2026',
package_table.max_pkg AS 'Highest_Package_in_2026'
FROM Branch
LEFT JOIN (
    SELECT
    branch_id,
    MIN(PlacementDrive.package) AS min_pkg,
    AVG(PlacementDrive.package) AS avg_pkg,
    MAX(PlacementDrive.package) AS max_pkg
    FROM Student
    INNER JOIN PlacementDrive
    ON Student.drive_id = PlacementDrive.drive_id
    INNER JOIN Training
    ON Student.t_id = Training.t_id
    WHERE Training.t_year = '2026'
    GROUP BY Student.branch_id
) AS package_table
ON Branch.branch_id = package_table.branch_id;

/*
+-----------------------------------+-------------------------+-------------------------+-------------------------+
| Branch                            | Minimum Package in 2026 | Average Package in 2026 | Highest Package in 2026 |
+-----------------------------------+-------------------------+-------------------------+-------------------------+
| Computer Engineering              |                      11 |      18.755999755859374 |                   33.53 |
| Electronics and Telecommunication |                    NULL |                    NULL |                    NULL |
| Information Technology            |                    4.95 |      13.294999599456787 |                   21.64 |
+-----------------------------------+-------------------------+-------------------------+-------------------------+
*/

