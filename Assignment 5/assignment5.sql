/*
Named PLSQL Block: PL/SQL Stored Procedure and Stored Function.
Write a Stored Procedure namely proc Grade for the categorization of student. 
If marks scored by students in examination is 
  <=1500 and marks>=990 then student will be placed in distinction category 
  between 989 and 900 category is first class
  between 899 and 825 category is Higher Second Class.
  
Write a PUSQLblock to use procedure created with above requirement. 
  Stud Marks(name, total marks) 
  Result(Roll,Name, Class)
*/

CREATE TABLE StudMarks (
  roll INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  total_marks INT NOT NULL
);


CREATE TABLE Result (
  roll INT PRIMARY KEY,
  class VARCHAR(50) CHECK IN ('Distinction', 'First', 'Higher Second Class'),
  FOREIGN KEY (roll) REFERENCES StudMarks (roll)
);

CREATE VIEW StudClass AS
SELECT roll, name, total_marks, class
FROM StudMarks
INNER JOIN Result
ON StudMarks.roll = Result.roll;


INSERT INTO StudMarks 
  (roll, name, total_marks) VALUES
  (31242, 'Tirthraj Mahajan', 1550),
  (31237, 'Amey Kulkarni', 950),
  (31228, 'Advait Joshi', 850),
  (31229, 'Rinit Jain', 980),
  (31230, 'Aniket Joshi', 1600);

delimiter //

-- Create PROCEDURE to calculate the result
CREATE PROCEDURE proc_result(IN marks int, OUT class char(20))
BEGIN
    IF(marks < 1500 && marks > 990) THEN
        SET class = 'Distinction';
    END IF;
    IF(marks < 989 && marks > 890) THEN
        SET class = 'First Class';
    END IF;
    IF(marks < 889 && marks > 825) THEN
        SET class = 'Higher Second Class';
    END IF;
    IF(marks < 824 && marks > 750) THEN
        SET class = 'Second Class';
    END IF;
    IF(marks < 749 && marks > 650) THEN
        SET class = 'Passed';
    END IF;
    IF(marks < 649) THEN
        SET class = 'Fail';
    END IF;
END;


-- Create function to store marks

CREATE FUNCTION final_result(roll_no int)
RETURNS INT

delimiter ;