/*
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
write-up or we can use Alice name for table name in query.
✔ Sequence should be implemented with AUTO_INCREMENT. Concept of sequence
from oracle must be included in the write-up.
✔ Simple view, Index (simple, unique, composite and text – show index after
creation)
*/

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
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='BMC Softwares' AND package = 14),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Advait Joshi', 
                9.88, 
                '2004-01-01', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Siemens' AND package = 11),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Amey Kulkarni', 
                9.77, 
                '2004-01-04', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Mastercard' AND package = 33.53),
                (SELECT t_id FROM Training WHERE tcompany_name = 'eQ Technologies' and t_year = '2026')
            ),
            (
                'Aditya Mulay', 
                9.00, 
                '2004-01-26', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Mastercard' AND package = 21.64),
                (SELECT t_id FROM Training WHERE tcompany_name = 'eQ Technologies' and t_year = '2026')
            ),
            (
                'Arnav Vaidya', 
                8.88, 
                '2004-05-20', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='UBS' AND package = 19.63),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2023')
            ),
            (
                'Devendra Kumar', 
                7.98, 
                '2004-06-20', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Electronics and Telecommunication'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Bajaj Finserv' AND package = 20.10),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            ),
            (
                'Deo Kulkarni', 
                8.63, 
                '2004-12-29', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Tiaa India' AND package = 10.48),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            ),
            (
                'Ninad Palsule', 
                8.03, 
                '2004-09-17', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Deutsche Bank' AND package = 12.75),
                (SELECT t_id FROM Training WHERE tcompany_name = 'ZS Associates' and t_year = '2026')
            ),
            (
                'Suvrat Ketkar', 
                6.95, 
                '2004-10-17', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Barclays' AND package = 22.50),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Aniket Joshi', 
                6.55, 
                '2004-05-12', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Information Technology'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Tiaa India' AND package = 10.48),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Barclays' and t_year = '2026')
            ),
            (
                'Mayank Ketan', 
                6.99, 
                '2004-03-28', 
                (SELECT branch_id FROM Branch WHERE branch_name = 'Electronics and Telecommunication'), 
                (SELECT drive_id FROM PlacementDrive WHERE pcompany_name='Bajaj Finserv' AND package = 20.10),
                (SELECT t_id FROM Training WHERE tcompany_name = 'Siemens' and t_year = '2024')
            );
            
SELECT * FROM Student 
    WHERE branch_id IN 
        (SELECT branch_id FROM Branch WHERE branch_name = 'Computer Engineering' OR branch_name = 'Information Technology') 
    AND (s_name LIKE 'A%' OR s_name LIKE 'D%');

SELECT DISTINCT pcompany_name FROM PlacementDrive;

DELETE FROM Student WHERE cgpa < 7;

SELECT pcompany_name FROM PlacementDrive WHERE plocation = 'Pune' OR plocation = 'Mumbai';

SELECT s_name FROM Student WHERE t_id IN (SELECT t_id FROM Training WHERE t_year = '2024' OR t_year = '2026');

SELECT s_name FROM Student ORDER BY cgpa DESC LIMIT 1;

SELECT s_name FROM Student WHERE cgpa BETWEEN 7 AND 9;

SELECT s_name FROM Student WHERE t_id IN (SELECT t_id FROM Training ORDER BY t_fee DESC);