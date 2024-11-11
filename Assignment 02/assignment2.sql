/*
mysql -h 10.10.14.184 -u te31242 -p
-> te31242

Assignment No 2B

Assignment No 2B (Student Schema)
Consider the following relational Schema.
● Student( s_id,Drive_id,T_id,s_name,CGPA,s_branch,S_dob)
● PlacementDrive( Drive_id,Pcompany_name,package,location)
● Training ( T_id,Tcompany_name,T_Fee,T_year)

Use the tables created in assignment no 2 and execute the following queries:
1. Insert at least 10 records in the Student table and insert other tables accordingly.
2. Display all students details with branch ‘Computer ‘and ‘It’ and student name
starting with 'a' or 'd'.
3. list the number of different companies.(use of distinct)
4. Give 15% increase in fee of the Training whose joining year is 2019.
5. Delete Student details having CGPA score less than 7.
6. Find the names of companies belonging to pune or Mumbai
7. Find the student name who joined training in 1-1-2019 as well as in 1-1-2021
8. Find the student name having maximum CGPA score and names of students
having CGPA score between 7 to 9 .
9. Display all Student name with T_id with decreasing order of Fees
10. Display PCompany name, S_name ,location and Package with Package 30K,
40K and 50k

A2: Guidelines
✔ Synonyms not supported in MySQL. Required to include example from oracle in
write-up or we can use Alias name for table name in query.
✔ Sequence should be implemented with AUTO_INCREMENT. Concept of sequence
from oracle must be included in the write-up.
✔ Simple view, Index (simple, unique, composite and text – show index after
creation)
*/

-- DDL

CREATE TABLE IF NOT EXISTS Branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50) unique NOT NULL
);

-- mysql> DESCRIBE Branch;
-- +-------------+-------------+------+-----+---------+-------+
-- | Field       | Type        | Null | Key | Default | Extra |
-- +-------------+-------------+------+-----+---------+-------+
-- | branch_id   | int(11)     | NO   | PRI | NULL    |       |
-- | branch_name | varchar(50) | NO   | UNI | NULL    |       |
-- +-------------+-------------+------+-----+---------+-------+


CREATE TABLE IF NOT EXISTS PlacementDrive (
    drive_id INT PRIMARY KEY AUTO_INCREMENT,
    pcompany_name VARCHAR(50) NOT NULL,
    package FLOAT NOT NULL,
    plocation VARCHAR(255)
);

-- mysql> DESCRIBE PlacementDrive;
-- +---------------+--------------+------+-----+---------+----------------+
-- | Field         | Type         | Null | Key | Default | Extra          |
-- +---------------+--------------+------+-----+---------+----------------+
-- | drive_id      | int(11)      | NO   | PRI | NULL    | auto_increment |
-- | pcompany_name | varchar(50)  | NO   |     | NULL    |                |
-- | package       | float        | NO   |     | NULL    |                |
-- | plocation     | varchar(255) | YES  |     | NULL    |                |
-- +---------------+--------------+------+-----+---------+----------------+


CREATE TABLE IF NOT EXISTS Training (
    t_id INT PRIMARY KEY AUTO_INCREMENT,
    tcompany_name VARCHAR(50) NOT NULL,
    t_fee INT,
    t_year YEAR
);

-- mysql> DESCRIBE Training;
-- +---------------+-------------+------+-----+---------+----------------+
-- | Field         | Type        | Null | Key | Default | Extra          |
-- +---------------+-------------+------+-----+---------+----------------+
-- | t_id          | int(11)     | NO   | PRI | NULL    | auto_increment |
-- | tcompany_name | varchar(50) | NO   |     | NULL    |                |
-- | t_fee         | int(11)     | YES  |     | NULL    |                |
-- | t_year        | year(4)     | YES  |     | NULL    |                |
-- +---------------+-------------+------+-----+---------+----------------+


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

-- mysql> DESCRIBE Student;
-- +-----------+-------------+------+-----+---------+----------------+
-- | Field     | Type        | Null | Key | Default | Extra          |
-- +-----------+-------------+------+-----+---------+----------------+
-- | s_id      | int(11)     | NO   | PRI | NULL    | auto_increment |
-- | s_name    | varchar(50) | NO   |     | NULL    |                |
-- | cgpa      | float       | YES  |     | NULL    |                |
-- | s_dob     | date        | YES  |     | NULL    |                |
-- | branch_id | int(11)     | YES  | MUL | NULL    |                |
-- | drive_id  | int(11)     | YES  | MUL | NULL    |                |
-- | t_id      | int(11)     | YES  | MUL | NULL    |                |
-- +-----------+-------------+------+-----+---------+----------------+


-- DML

INSERT INTO Branch VALUES
            (1, 'Computer Engineering'),
            (2, 'Information Technology'),
            (3, 'Electronics and Telecommunication');

-- mysql> SELECT * FROM Branch;
-- +-----------+-----------------------------------+
-- | branch_id | branch_name                       |
-- +-----------+-----------------------------------+
-- |         1 | Computer Engineering              |
-- |         3 | Electronics and Telecommunication |
-- |         2 | Information Technology            |
-- +-----------+-----------------------------------+


INSERT INTO PlacementDrive (drive_id, pcompany_name, package, plocation) VALUES 
            (1,'BMC Softwares', 14, 'Pune'),
            (2,'Siemens', 11, 'Pune'),
            (3,'Tiaa India', 10.48, 'Banglore'),
            (4,'Deutsche Bank', 12.75, 'Mumbai'),
            (5,'UBS', 19.63, 'Mumbai'),
            (6,'UBS', 12.50, 'Mumbai'),
            (7,'Mastercard', 33.53, 'Pune'),
            (8,'Mastercard', 21.64, 'Mumbai'),
            (9,'Bajaj Finserv', 20.10, 'Mumbai'),
            (10,'Barclays',13.40, 'Banglore'),
            (11,'Barclays', 22.50, 'Mumbai'),
            (12,'eQ Technologies', 19.60, 'Pune'),
            (13,'eQ Technologies', 12.00, 'Banglore');

-- mysql> SELECT * FROM PlacementDrive;
-- +----------+-----------------+---------+-----------+
-- | drive_id | pcompany_name   | package | plocation |
-- +----------+-----------------+---------+-----------+
-- |        1 | BMC Softwares   |      14 | Pune      |
-- |        2 | Siemens         |      11 | Pune      |
-- |        3 | Tiaa India      |   10.48 | Banglore  |
-- |        4 | Deutsche Bank   |   12.75 | Mumbai    |
-- |        5 | UBS             |   19.63 | Mumbai    |
-- |        6 | UBS             |    12.5 | Mumbai    |
-- |        7 | Mastercard      |   33.53 | Pune      |
-- |        8 | Mastercard      |   21.64 | Mumbai    |
-- |        9 | Bajaj Finserv   |    20.1 | Mumbai    |
-- |       10 | Barclays        |    13.4 | Banglore  |
-- |       11 | Barclays        |    22.5 | Mumbai    |
-- |       12 | eQ Technologies |    19.6 | Pune      |
-- |       13 | eQ Technologies |      12 | Banglore  |
-- +----------+-----------------+---------+-----------+


INSERT INTO Training (t_id, tcompany_name, t_fee, t_year) VALUES
            (1,'Barclays', 3000, '2023'),
            (2,'Barclays', 3000, '2026'),
            (3,'Siemens', 2200, '2024'),
            (4,'Siemens', 2000, '2023'),
            (5,'eQ Technologies', 1000, '2025'),
            (6,'eQ Technologies', 1000, '2026'),
            (7,'ZS Associates', 1000, '2026');

-- mysql> SELECT * FROM Training;
-- +------+-----------------+-------+--------+
-- | t_id | tcompany_name   | t_fee | t_year |
-- +------+-----------------+-------+--------+
-- |    1 | Barclays        |  3000 |   2023 |
-- |    2 | Barclays        |  3450 |   2026 |
-- |    3 | Siemens         |  2200 |   2024 |
-- |    4 | Siemens         |  2000 |   2023 |
-- |    5 | eQ Technologies |  1000 |   2025 |
-- |    6 | eQ Technologies |  1150 |   2026 |
-- |    7 | ZS Associates   |  1150 |   2026 |
-- +------+-----------------+-------+--------+


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
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Bajaj Finserv' AND package = CAST(20.10 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            ),
            (
                'Deo Kulkarni', 
                8.63, 
                '2004-12-29', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Tiaa India' AND package = CAST(10.48 AS FLOAT)),
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
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Tiaa India' AND package = CAST(10.48 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Mayank Ketan', 
                6.99, 
                '2004-03-28', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Electronics and Telecommunication'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Bajaj Finserv' AND package = CAST(20.10 AS FLOAT)),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            );

-- mysql> SELECT * FROM Student;
-- +------+------------------+------+------------+-----------+----------+------+
-- | s_id | s_name           | cgpa | s_dob      | branch_id | drive_id | t_id |
-- +------+------------------+------+------------+-----------+----------+------+
-- |   12 | Tirthraj Mahajan |  9.5 | 2004-06-07 |         1 |        1 |    2 |
-- |   13 | Advait Joshi     | 9.88 | 2004-01-01 |         1 |        2 |    2 |
-- |   14 | Amey Kulkarni    | 9.77 | 2004-01-04 |         1 |        7 |    6 |
-- |   15 | Aditya Mulay     |    9 | 2004-01-26 |         2 |        8 |    6 |
-- |   16 | Arnav Vaidya     | 8.88 | 2004-05-20 |         2 |        5 |    4 |
-- |   17 | Devendra Kumar   | 7.98 | 2004-06-20 |         3 |        9 |    3 |
-- |   18 | Deo Kulkarni     | 8.63 | 2004-12-29 |         2 |        3 |    3 |
-- |   19 | Ninad Palsule    | 8.03 | 2004-09-17 |         1 |        4 |    7 |
-- |   20 | Suvrat Ketkar    | 6.95 | 2004-10-17 |         1 |       11 |    2 |
-- |   21 | Aniket Joshi     | 6.55 | 2004-05-12 |         2 |        3 |    2 |
-- |   22 | Mayank Ketan     | 6.99 | 2004-03-28 |         3 |        9 |    3 |
-- +------+------------------+------+------------+-----------+----------+------+


-- DQL

-- Display all students details with branch ‘Computer ‘and ‘It’ and student name starting with 'a' or 'd'.
SELECT * FROM Student 
    WHERE branch_id IN 
        (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering' OR branch_name = 'Information Technology') 
    AND (s_name LIKE 'A%' OR s_name LIKE 'D%');

/*
+------+---------------+------+------------+-----------+----------+------+
| s_id | s_name        | cgpa | s_dob      | branch_id | drive_id | t_id |
+------+---------------+------+------------+-----------+----------+------+
|    2 | Advait Joshi  | 9.88 | 2004-01-01 |         1 |        2 |    2 |
|    3 | Amey Kulkarni | 9.77 | 2004-01-04 |         1 |        7 |    6 |
|    4 | Aditya Mulay  |    9 | 2004-01-26 |         2 |        8 |    6 |
|    5 | Arnav Vaidya  | 8.88 | 2004-05-20 |         2 |        5 |    4 |
|    7 | Deo Kulkarni  | 8.63 | 2004-12-29 |         2 |        3 |    3 |
|   10 | Aniket Joshi  | 6.55 | 2004-05-12 |         2 |        3 |    2 |
+------+---------------+------+------------+-----------+----------+------+
*/

-- list the number of different companies.(use of distinct)
SELECT DISTINCT pcompany_name FROM PlacementDrive;

/*
+-----------------+
| pcompany_name   |
+-----------------+
| BMC Softwares   |
| Siemens         |
| Tiaa India      |
| Deutsche Bank   |
| UBS             |
| Mastercard      |
| Bajaj Finserv   |
| Barclays        |
| eQ Technologies |
+-----------------+
*/

-- Give 15% increase in fee of the Training whose joining year is 2026.

-- before
SELECT * FROM Training;

-- +------+-----------------+-------+--------+
-- | t_id | tcompany_name   | t_fee | t_year |
-- +------+-----------------+-------+--------+
-- |    1 | Barclays        |  3000 |   2023 |
-- |    2 | Barclays        |  3000 |   2026 |
-- |    3 | Siemens         |  2200 |   2024 |
-- |    4 | Siemens         |  2000 |   2023 |
-- |    5 | eQ Technologies |  1000 |   2025 |
-- |    6 | eQ Technologies |  1000 |   2026 |
-- |    7 | ZS Associates   |  1000 |   2026 |
-- +------+-----------------+-------+--------+


-- update
UPDATE Training SET t_fee = t_fee*(1.15) WHERE t_year = 2026;

-- after
SELECT * FROM Training;

-- +------+-----------------+-------+--------+
-- | t_id | tcompany_name   | t_fee | t_year |
-- +------+-----------------+-------+--------+
-- |    1 | Barclays        |  3000 |   2023 |
-- |    2 | Barclays        |  3450 |   2026 |
-- |    3 | Siemens         |  2200 |   2024 |
-- |    4 | Siemens         |  2000 |   2023 |
-- |    5 | eQ Technologies |  1000 |   2025 |
-- |    6 | eQ Technologies |  1150 |   2026 |
-- |    7 | ZS Associates   |  1150 |   2026 |
-- +------+-----------------+-------+--------+

-- Delete Student details having CGPA score less than 7.
DELETE FROM Student WHERE cgpa < 7;

-- Query OK, 3 rows affected (0.03 sec)

-- Find the names of companies belonging to pune or Mumbai
SELECT pcompany_name FROM PlacementDrive WHERE plocation = 'Pune' OR plocation = 'Mumbai';

-- +-----------------+
-- | pcompany_name   |
-- +-----------------+
-- | BMC Softwares   |
-- | Siemens         |
-- | Deutsche Bank   |
-- | UBS             |
-- | UBS             |
-- | Mastercard      |
-- | Mastercard      |
-- | Bajaj Finserv   |
-- | Barclays        |
-- | eQ Technologies |
-- +-----------------+

-- Find the student name who joined training in 1-1-2019 as well as in 1-1-2021
SELECT s_name FROM Student WHERE t_id IN (SELECT t_id FROM Training WHERE t_year = '2024' OR t_year = '2026');

-- +------------------+
-- | s_name           |
-- +------------------+
-- | Tirthraj Mahajan |
-- | Advait Joshi     |
-- | Amey Kulkarni    |
-- | Aditya Mulay     |
-- | Devendra Kumar   |
-- | Deo Kulkarni     |
-- | Ninad Palsule    |
-- +------------------+


-- Find the student name having maximum CGPA score
SELECT s_name FROM Student ORDER BY cgpa DESC LIMIT 1;

-- +--------------+
-- | s_name       |
-- +--------------+
-- | Advait Joshi |
-- +--------------+


-- names of students having CGPA score between 7 to 9.
SELECT s_name FROM Student WHERE cgpa BETWEEN 7 AND 9;

-- +----------------+
-- | s_name         |
-- +----------------+
-- | Aditya Mulay   |
-- | Arnav Vaidya   |
-- | Devendra Kumar |
-- | Deo Kulkarni   |
-- | Ninad Palsule  |
-- +----------------+


-- Display all Student name with T_id with decreasing order of Fees
SELECT s_name FROM Student WHERE t_id IN (SELECT t_id FROM Training ORDER BY t_fee DESC);

-- +------------------+
-- | s_name           |
-- +------------------+
-- | Tirthraj Mahajan |
-- | Advait Joshi     |
-- | Amey Kulkarni    |
-- | Aditya Mulay     |
-- | Arnav Vaidya     |
-- | Devendra Kumar   |
-- | Deo Kulkarni     |
-- | Ninad Palsule    |
-- +------------------+

-- Average package of companies 
SELECT AVG(package) FROM PlacementDrive;

-- +--------------------+
-- | AVG(package)       |
-- +--------------------+
-- | 17.163845942570614 |
-- +--------------------+


-- Using Alias Name
SELECT branch_id AS "Branch" ,AVG(cgpa) AS "Average CGPA" FROM Student GROUP BY branch_id;

-- +--------+-------------------+
-- | Branch | Average CGPA      |
-- +--------+-------------------+
-- |      1 | 9.295000076293945 |
-- |      2 | 8.836666742960611 |
-- |      3 | 7.980000019073486 |
-- +--------+-------------------+

CREATE UNIQUE INDEX student_name ON Student(s_name);

-- mysql> SHOW INDEXES FROM Student;
-- +---------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- | Table   | Non_unique | Key_name     | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
-- +---------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
-- | Student |          0 | PRIMARY      |            1 | s_id        | A         |          11 |     NULL | NULL   |      | BTREE      |         |               |
-- | Student |          0 | student_name |            1 | s_name      | A         |          11 |     NULL | NULL   |      | BTREE      |         |               |
-- | Student |          1 | branch_id    |            1 | branch_id   | A         |          11 |     NULL | NULL   | YES  | BTREE      |         |               |
-- | Student |          1 | drive_id     |            1 | drive_id    | A         |          11 |     NULL | NULL   | YES  | BTREE      |         |               |
-- | Student |          1 | t_id         |            1 | t_id        | A         |          11 |     NULL | NULL   | YES  | BTREE      |         |               |
-- +---------+------------+--------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
