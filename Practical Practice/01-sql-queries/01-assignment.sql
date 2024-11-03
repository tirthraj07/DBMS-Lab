CREATE TABLE placementdrive(
    drive_id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- Not null constraints
    pcompany_name VARCHAR(100) NOT NULL,
    package DECIMAL(10,2) NOT NULL,
    plocation TEXT
);

CREATE TABLE training(
    t_id INT PRIMARY KEY AUTO_INCREMENT,

    -- NOT NULL Constraints
    tcompany_name VARCHAR(100) NOT NULL,
    t_fee DECIMAL(10,2) NOT NULL,
    t_year YEAR,

    -- UNIQUE Constrains
    UNIQUE(tcompany_name,t_year)

);

CREATE TABLE student (
    s_id INT PRIMARY KEY AUTO_INCREMENT,

    -- NOT NULL Constraints

    s_name VARCHAR(100) NOT NULL, 
    cgpa DECIMAL(10,2) NOT NULL,
    s_branch VARCHAR(50) NOT NULL,
    s_dob DATE NOT NULL,

    -- FOREIGN KEY DECLARATIONS
    drive_id INT,
    t_id INT,

    -- FOREIGN KEY DEPENDENCIES
    FOREIGN KEY (drive_id) REFERENCES placementdrive(drive_id) ON DELETE NO ACTION,
    FOREIGN KEY (t_id) REFERENCES training(t_id) ON DELETE NO ACTION
);

-- INSERTION DEPENDENCIES
/*
1. Branch should contain Computer and It
2. Student names should start with a and d
3. Training -> year is 2019.
4. CGPA -> less than 7
5. Companies to belong to Pune and Mumbai
6. Training years -> 2019 to 2021
7. CGPA -> 7 to 9
8. packages -> 30k, 40k, 50k
*/


INSERT INTO placementdrive 
    (drive_id, pcompany_name, package, plocation)
    VALUES
    (
        1,'Barclays', 75000, 'Pune'
    ),
    (
        2,'Mastercard', 40000, 'Pune'
    ),
    (
        3,'Dell', 50000, 'Bangalore'
    ),
    (
        4,'General Mills', 30000, 'Mumbai'
    ),
    (
        5,'Deutsche Bank', 75000, 'Pune'
    ),
    (
        6,'NICE', 40000, 'Mumbai'
    ),
    (
        7,'Siemens', 30000, 'Pune'
    ),
    (
        8,'BNY Mellon', 50000, 'Mumbai'
    ),
    (
        9,'Arista Network', 30000, 'Pune'
    ),
    (
        10,'IBM', 30000, 'Nashik'
    ),
    (
        11,'Intel', 40000, 'Kolhapur'
    ),
    (
        12,'Goldman Sachs', 50000, 'Hyderabad'
    );

INSERT INTO training
    ( t_id, tcompany_name, t_fee, t_year )
    VALUES
    (1,'Barclays', 15000, '2020'),
    (2,'Barclays', 10000, '2019'),
    (3,'Barclays', 20000, '2021'),
    (4,'Mastercard', 5000, '2019'),
    (5,'Mastercard', 5000, '2020'),
    (6,'Mastercard', 5000, '2021'),
    (7,'BMC', 7000, '2019'),
    (8,'BMC', 10000, '2020'),
    (9,'BMC', 12000, '2021');



INSERT INTO student
    ( s_name, cgpa, s_branch, s_dob, drive_id, t_id )
    VALUES
    (
        'Tirthraj', 6.69, 'Computer', '2004-06-07', 1, 1
    ),
    (
        'Advait', 8.89, 'Computer', '2004-01-01', 4, 6
    ),
    (
        'Aniket', 8.09, 'Computer', '2004-08-07', 2, 7
    ),
    (
        'Rinit', 7.80, 'Computer', '2004-08-07', 7, 9
    ),
    (
        'Maynak', 7.52, 'Computer', '2004-03-07', 10, 5
    ),
    (
        'Arnav', 8.59, 'It', '2004-05-07', 11, 8
    ),
    (
        'Aditya', 6.69, 'It', '2004-01-07', 9, 5
    ),
    (
        'Prabhu', 7.02, 'Entc', '2004-10-07', 11, 6
    ),
    (
        'Vardhan', 6.02, 'It', '2004-07-07', 3, 2
    ),
    (
        'Arya', 8.95, 'It', '2004-09-07', 8, 3
    );




-- Display all students details with branch ‘Computer ‘and ‘It’ and student name
SELECT * FROM student
WHERE
(s_branch = 'Computer' OR s_branch = 'It')
AND
( s_name LIKE 'a%' OR s_name LIKE 'd' );

/*
+------+--------+------+----------+------------+----------+------+
| s_id | s_name | cgpa | s_branch | s_dob      | drive_id | t_id |
+------+--------+------+----------+------------+----------+------+
|   12 | Advait | 8.89 | Computer | 2004-01-01 |        4 |    6 |
|   13 | Aniket | 8.09 | Computer | 2004-08-07 |        2 |    7 |
|   16 | Arnav  | 8.59 | It       | 2004-05-07 |       11 |    8 |
|   17 | Aditya | 6.69 | It       | 2004-01-07 |        9 |    5 |
|   20 | Arya   | 8.95 | It       | 2004-09-07 |        8 |    3 |
+------+--------+------+----------+------------+----------+------+
*/

-- 3. list the number of different companies.(use of distinct)
SELECT COUNT(DISTINCT(pcompany_name)) AS 'no_of_companies' FROM placementdrive;

SELECT DISTINCT(pcompany_name) AS 'companies' FROM placementdrive;

/*
+----------------+
| companies      |
+----------------+
| Barclays       |
| Mastercard     |
| Dell           |
| General Mills  |
| Deutsche Bank  |
| NICE           |
| Siemens        |
| BNY Mellon     |
| Arista Network |
| IBM            |
| Intel          |
| Goldman Sachs  |
+----------------+
*/


-- Give 15% increase in fee of the Training whose joining year is 2019.

UPDATE training
SET t_fee = t_fee * (1.05)
WHERE t_year = '2019';

/*
BEFORE
+------+---------------+----------+--------+
| t_id | tcompany_name | t_fee    | t_year |
+------+---------------+----------+--------+
|    1 | Barclays      | 15000.00 |   2020 |
|    2 | Barclays      | 10000.00 |   2019 |
|    3 | Barclays      | 20000.00 |   2021 |
|    4 | Mastercard    |  5000.00 |   2019 |
|    5 | Mastercard    |  5000.00 |   2020 |
|    6 | Mastercard    |  5000.00 |   2021 |
|    7 | BMC           |  7000.00 |   2019 |
|    8 | BMC           | 10000.00 |   2020 |
|    9 | BMC           | 12000.00 |   2021 |
+------+---------------+----------+--------+
AFTER
+------+---------------+----------+--------+
| t_id | tcompany_name | t_fee    | t_year |
+------+---------------+----------+--------+
|    1 | Barclays      | 15000.00 |   2020 |
|    2 | Barclays      | 10500.00 |   2019 |
|    3 | Barclays      | 20000.00 |   2021 |
|    4 | Mastercard    |  5250.00 |   2019 |
|    5 | Mastercard    |  5000.00 |   2020 |
|    6 | Mastercard    |  5000.00 |   2021 |
|    7 | BMC           |  7350.00 |   2019 |
|    8 | BMC           | 10000.00 |   2020 |
|    9 | BMC           | 12000.00 |   2021 |
+------+---------------+----------+--------+
*/

-- 5. Delete Student details having CGPA score less than 7.
DELETE FROM student WHERE cgpa < 7;

/*
before:

+------+----------+------+----------+------------+----------+------+
| s_id | s_name   | cgpa | s_branch | s_dob      | drive_id | t_id |
+------+----------+------+----------+------------+----------+------+
|   11 | Tirthraj | 6.69 | Computer | 2004-06-07 |        1 |    1 |
|   17 | Aditya   | 6.69 | It       | 2004-01-07 |        9 |    5 |
|   19 | Vardhan  | 6.02 | It       | 2004-07-07 |        3 |    2 |
+------+----------+------+----------+------------+----------+------+

after:
Empty set (0.00 sec)
*/

-- Find the names of companies belonging to pune or Mumbai
SELECT * FROM placementdrive WHERE (plocation = 'Pune') or (plocation = 'Mumbai');

/*
+----------+----------------+----------+-----------+
| drive_id | pcompany_name  | package  | plocation |
+----------+----------------+----------+-----------+
|        1 | Barclays       | 75000.00 | Pune      |
|        2 | Mastercard     | 40000.00 | Pune      |
|        4 | General Mills  | 30000.00 | Mumbai    |
|        5 | Deutsche Bank  | 75000.00 | Pune      |
|        6 | NICE           | 40000.00 | Mumbai    |
|        7 | Siemens        | 30000.00 | Pune      |
|        8 | BNY Mellon     | 50000.00 | Mumbai    |
|        9 | Arista Network | 30000.00 | Pune      |
+----------+----------------+----------+-----------+
*/

-- Find the student name who joined training in 1-1-2019 as well as in 1-1-2021
-- We need to do this without using JOIN keyword. So this is how we are going to do the following

SELECT s_name
FROM student s, training t
WHERE 
s.t_id = t.t_id
AND
t.t_year BETWEEN '2019' and '2021';

/*
+--------+
| s_name |
+--------+
| Arya   |
| Aniket |
| Arnav  |
| Rinit  |
| Maynak |
| Advait |
| Prabhu |
+--------+
*/

-- Find the student name having maximum and second max CGPA score and names of students having CGPA score between 7 to 9 .
SELECT s_name, cgpa
FROM student
WHERE cgpa = (
    SELECT MAX(cgpa)
    FROM student
);

SELECT s_name, cgpa
FROM student
WHERE cgpa = (
    SELECT cgpa
    FROM student
    ORDER BY cgpa DESC
    LIMIT 1
    OFFSET 1
);


SELECT s_name, cgpa
FROM student
WHERE cgpa BETWEEN 7 AND 9
ORDER BY cgpa DESC;

/*
+--------+------+
| s_name | cgpa |
+--------+------+
| Arya   | 8.95 |
+--------+------+

+--------+------+
| s_name | cgpa |
+--------+------+
| Advait | 8.89 |
+--------+------+

+--------+------+
| s_name | cgpa |
+--------+------+
| Arya   | 8.95 |
| Advait | 8.89 |
| Arnav  | 8.59 |
| Aniket | 8.09 |
| Rinit  | 7.80 |
| Maynak | 7.52 |
| Prabhu | 7.02 |
+--------+------+
*/

--  Display all Student name with T_id with decreasing order of Fees
SELECT s_name, t_fee
FROM
student s,
training t
WHERE
s.t_id = t.t_id
ORDER BY
t_fee DESC;

/*
+--------+----------+
| s_name | t_fee    |
+--------+----------+
| Arya   | 20000.00 |
| Rinit  | 12000.00 |
| Arnav  | 10000.00 |
| Aniket |  7350.00 |
| Advait |  5000.00 |
| Maynak |  5000.00 |
| Prabhu |  5000.00 |
+--------+----------+
*/

-- Display PCompany name, S_name ,location and Package with Package 30K,40K and 50k

SELECT 
s.s_name, p.pcompany_name, p.plocation, p.package
FROM
student s,
placementdrive p
WHERE
s.drive_id = p.drive_id
AND
(
p.package = 30000
OR p.package = 40000
OR p.package = 50000
)
ORDER BY p.package;

/*

+--------+---------------+-----------+----------+
| s_name | pcompany_name | plocation | package  |
+--------+---------------+-----------+----------+
| Advait | General Mills | Mumbai    | 30000.00 |
| Rinit  | Siemens       | Pune      | 30000.00 |
| Maynak | IBM           | Nashik    | 30000.00 |
| Aniket | Mastercard    | Pune      | 40000.00 |
| Arnav  | Intel         | Kolhapur  | 40000.00 |
| Prabhu | Intel         | Kolhapur  | 40000.00 |
| Arya   | BNY Mellon    | Mumbai    | 50000.00 |
+--------+---------------+-----------+----------+
*/
