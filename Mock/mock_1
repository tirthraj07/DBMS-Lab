/*

Consider an Employee database and write row-level triggers for the same. 
Implement both before & after triggers for the relevant database tables at the time of insertion,
update and deletion. 

Implement triggers using following schema:

EMPLOYEE(Emp_Id, First_Name, Last_Name, Email, Phone_No, Hire_Date, Job_Profile, Salary, HRA)

COMPANY_INFO(Emp_Count, Salary_Expenses)

EMP_LOG(Emp_Id, Old_Salary, New_Salary, Edit_Time, Job_Status)

- Before insert in employee table: Check the column value of FIRST_NAME, LAST_NAME,
JOB_ID for following criteria:
- If there are any spaces before or after the FIRST_NAME, LAST_NAME, use
TRIM() function to remove them.
- The value of the JOB_PROFILE will be converted to upper cases by UPPER()
function.
in mysql, create a trigger

- After insert in employee table: Every time an INSERT happens into EMPLOYEE table, insert
relevant information into the EMP_LOG table. Also update the
COMPANY_INFO table
in mysql, create trigger 
- Before update in employee: Each time the HRA is updated for the EMPLOYEE table,
convert it into decimal value (i.e. for 10%, store 0.1)

- After Update: Each time the HRA is updated, accordingly update the salary in
EMPLOYEE table &amp; keep track of updated salary in EMP_LOG table.


- Before Delete: Every time a DELETE happens on EMPLOYEE table,
accordingly change the JOB_STATUS in EMP_LOG table from ACTIVE to
DELETED &amp; keep track of EDIT_TIME

- After Delete: Keep the COMPANY_INFO table updated

*/




CREATE TABLE IF NOT EXISTS Employee (
    Emp_Id INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(255) NOT NULL,
    Last_Name VARCHAR(255)  NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Phone_No VARCHAR(20) NOT NULL UNIQUE,
    Hire_Date  DATE NOT NULL,
    Job_Profile VARCHAR(255) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HRA DECIMAL(10,4) NOT NULL,

    -- checks
    CHECK (Salary >= 0),
    CHECK (HRA >= 0 AND HRA <= 1)
);


CREATE TABLE IF NOT EXISTS Company_Info (
    Emp_Count INT NOT NULL DEFAULT 0,
    Salary_Expenses DECIMAL(10,2) NOT NULL DEFAULT 0,

    -- checks
    CHECK (Emp_Count >= 0),
    CHECK (Salary_Expenses >= 0)
);
this is the table, i want to drop the foreign key constaint but keey the Emp_Id
CREATE TABLE IF NOT EXISTS Emp_Log (
    Emp_Id INT NOT NULL,
    Old_Salary DECIMAL(10, 2) NOT NULL,
    New_Salary DECIMAL(10, 2) NOT NULL,
    Edit_Time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Job_Status VARCHAR(255) NOT NULL
);

DELIMITER //


CREATE TRIGGER before_insert_in_employee
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    SET NEW.First_Name = TRIM(NEW.First_Name);
    SET NEW.Last_Name = TRIM(NEW.Last_Name);
    SET NEW.Job_Profile = UPPER(NEW.Job_Profile);
END
//


-- Initially assume that HRA is part of the salary
CREATE TRIGGER after_insert_in_employee
AFTER INSERT ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO Emp_Log (Emp_Id, Old_Salary, New_Salary, Job_Status)  VALUES (NEW.Emp_Id, 0, NEW.Salary, 'ACTIVE');

    UPDATE 
    Company_Info 
    SET 
    Emp_Count = Emp_Count + 1,
    Salary_Expenses = Salary_Expenses + NEW.Salary;
END
//

CREATE TRIGGER before_update_in_employee
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    -- fetch current salary
    DECLARE Old_Salary DECIMAL(10, 2);
    
    SELECT Salary INTO Old_Salary FROM Employee WHERE Emp_Id = NEW.Emp_Id;

    -- fetch new salary
    IF NEW.Salary IS NULL THEN
        SET NEW.Salary = 0;
    END IF;

    IF NEW.HRA IS NOT NULL THEN
        SET NEW.HRA = NEW.HRA / 100;
        SET NEW.Salary = NEW.Salary + (NEW.Salary)*NEW.HRA;
    END IF;

    -- update EMP_LOGS
    INSERT INTO  Emp_Log (Emp_Id, Old_Salary, New_Salary, Job_Status)
    VALUES  (NEW.Emp_Id, Old_Salary, NEW.Salary, "ACTIVE");

    -- update Company_Info
    UPDATE Company_Info
    SET Salary_Expenses = Salary_Expenses - Old_Salary + NEW.Salary;
END
//

CREATE TRIGGER before_delete_in_employee
BEFORE DELETE ON Employee
FOR EACH ROW
BEGIN

    INSERT INTO Emp_Log (Emp_Id, Old_Salary, New_Salary, Job_Status)
    VALUES (OLD.Emp_Id, OLD.Salary, 0, 'DELETED');

    UPDATE Company_Info
    SET
    Emp_Count = Emp_Count - 1,
    Salary_Expenses = Salary_Expenses - OLD.Salary;
END
//


DELIMITER ;

INSERT INTO Company_Info (Emp_Count, Salary_Expenses) VALUES (0,0);
/*
SELECT * FROM Company_Info;
+-----------+-----------------+
| Emp_Count | Salary_Expenses |
+-----------+-----------------+
|         0 |            0.00 |
+-----------+-----------------+
*/

INSERT INTO Employee
(First_Name, Last_Name, Email, Phone_No, Hire_Date, Job_Profile, Salary, HRA)
VALUES
('Tirthraj', 'Mahajan', 'tirthraj2004@gmail.com', '8767945245' ,'2024-08-23','Software Developer', 50000, 0.1);

/*
mysql> SELECT * FROM Employee;
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
| Emp_Id | First_Name | Last_Name | Email                  | Phone_No   | Hire_Date  | Job_Profile        | Salary   | HRA    |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
|      1 | Tirthraj   | Mahajan   | tirthraj2004@gmail.com | 8767945245 | 2024-08-23 | SOFTWARE DEVELOPER | 50000.00 | 0.1000 |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+

mysql> SELECT * FROM Emp_Log;
+--------+------------+------------+---------------------+------------+
| Emp_Id | Old_Salary | New_Salary | Edit_Time           | Job_Status |
+--------+------------+------------+---------------------+------------+
|      1 |       0.00 |   50000.00 | 2024-09-23 12:14:58 | ACTIVE     |
+--------+------------+------------+---------------------+------------+

mysql> SELECT * FROM Company_Info;
+-----------+-----------------+
| Emp_Count | Salary_Expenses |
+-----------+-----------------+
|         1 |        50000.00 |
+-----------+-----------------+
*/

INSERT INTO Employee
(First_Name, Last_Name, Email, Phone_No, Hire_Date, Job_Profile, Salary, HRA)
VALUES
('Advait', 'Joshi', 'advait2004@gmail.com', '9850175973' ,'2024-08-23','ML Developer', 60000, 0.2);

/*
mysql> SELECT * FROM Employee;
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
| Emp_Id | First_Name | Last_Name | Email                  | Phone_No   | Hire_Date  | Job_Profile        | Salary   | HRA    |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
|      1 | Tirthraj   | Mahajan   | tirthraj2004@gmail.com | 8767945245 | 2024-08-23 | SOFTWARE DEVELOPER | 50000.00 | 0.1000 |
|      2 | Advait     | Joshi     | Advait2004@gmail.com   | 9850175973 | 2024-08-23 | ML DEVELOPER       | 60000.00 | 0.2000 |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+

mysql> SELECT * FROM Emp_Log;
+--------+------------+------------+---------------------+------------+
| Emp_Id | Old_Salary | New_Salary | Edit_Time           | Job_Status |
+--------+------------+------------+---------------------+------------+
|      1 |       0.00 |   50000.00 | 2024-09-23 12:14:58 | ACTIVE     |
|      2 |       0.00 |   60000.00 | 2024-09-23 12:17:37 | ACTIVE     |
+--------+------------+------------+---------------------+------------+

mysql> SELECT * FROM Company_Info;
+-----------+-----------------+
| Emp_Count | Salary_Expenses |
+-----------+-----------------+
|         2 |       110000.00 |
+-----------+-----------------+
*/

INSERT INTO Employee
(First_Name, Last_Name, Email, Phone_No, Hire_Date, Job_Profile, Salary, HRA)
VALUES
('  Suvrat  ', '  Ketkar  ', 'suvrat2004@gmail.com', '4524587679' ,'2024-08-23','software developer', 70000, 0.3);

/*
mysql> SELECT * FROM Employee;
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
| Emp_Id | First_Name | Last_Name | Email                  | Phone_No   | Hire_Date  | Job_Profile        | Salary   | HRA    |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
|      1 | Tirthraj   | Mahajan   | tirthraj2004@gmail.com | 8767945245 | 2024-08-23 | SOFTWARE DEVELOPER | 50000.00 | 0.1000 |
|      2 | Advait     | Joshi     | Advait2004@gmail.com   | 9850175973 | 2024-08-23 | ML DEVELOPER       | 60000.00 | 0.2000 |
|      4 | Suvrat     | Ketkar    | suvrat2004@gmail.com   | 4524587679 | 2024-08-23 | SOFTWARE DEVELOPER | 70000.00 | 0.3000 |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+

mysql> SELECT * FROM Emp_Log;
+--------+------------+------------+---------------------+------------+
| Emp_Id | Old_Salary | New_Salary | Edit_Time           | Job_Status |
+--------+------------+------------+---------------------+------------+
|      1 |       0.00 |   50000.00 | 2024-09-23 12:14:58 | ACTIVE     |
|      2 |       0.00 |   60000.00 | 2024-09-23 12:17:37 | ACTIVE     |
|      4 |       0.00 |   70000.00 | 2024-09-23 12:21:12 | ACTIVE     |
+--------+------------+------------+---------------------+------------+

mysql> SELECT * FROM Company_Info;
+-----------+-----------------+
| Emp_Count | Salary_Expenses |
+-----------+-----------------+
|         3 |       180000.00 |
+-----------+-----------------+
*/

-- increase hra from 10% to 20% for Emp_Id = 1
UPDATE Employee
SET HRA = 20
WHERE Emp_Id = 1;

/*
mysql> SELECT * FROM Employee;
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
| Emp_Id | First_Name | Last_Name | Email                  | Phone_No   | Hire_Date  | Job_Profile        | Salary   | HRA    |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+
|      1 | Tirthraj   | Mahajan   | tirthraj2004@gmail.com | 8767945245 | 2024-08-23 | SOFTWARE DEVELOPER | 60120.00 | 0.2000 |
|      2 | Advait     | Joshi     | Advait2004@gmail.com   | 9850175973 | 2024-08-23 | ML DEVELOPER       | 60000.00 | 0.2000 |
|      4 | Suvrat     | Ketkar    | suvrat2004@gmail.com   | 4524587679 | 2024-08-23 | SOFTWARE DEVELOPER | 70000.00 | 0.3000 |
+--------+------------+-----------+------------------------+------------+------------+--------------------+----------+--------+

mysql> SELECT * FROM Emp_Log;
+--------+------------+------------+---------------------+------------+
| Emp_Id | Old_Salary | New_Salary | Edit_Time           | Job_Status |
+--------+------------+------------+---------------------+------------+
|      1 |       0.00 |   50000.00 | 2024-09-23 12:14:58 | ACTIVE     |
|      2 |       0.00 |   60000.00 | 2024-09-23 12:17:37 | ACTIVE     |
|      4 |       0.00 |   70000.00 | 2024-09-23 12:21:12 | ACTIVE     |
|      1 |   50000.00 |   60000.00 | 2024-09-23 12:25:17 | ACTIVE     |
+--------+------------+------------+---------------------+------------+

mysql> SELECT * FROM Company_Info;
+-----------+-----------------+
| Emp_Count | Salary_Expenses |
+-----------+-----------------+
|         3 |       190000.00 |
+-----------+-----------------+
*/

DELETE FROM Employee
WHERE Emp_Id = 1;

/*
mysql> SELECT * FROM Employee;
+--------+------------+-----------+----------------------+------------+------------+--------------------+----------+--------+
| Emp_Id | First_Name | Last_Name | Email                | Phone_No   | Hire_Date  | Job_Profile        | Salary   | HRA    |
+--------+------------+-----------+----------------------+------------+------------+--------------------+----------+--------+
|      2 | Advait     | Joshi     | Advait2004@gmail.com | 9850175973 | 2024-08-23 | ML DEVELOPER       | 60000.00 | 0.2000 |
|      4 | Suvrat     | Ketkar    | suvrat2004@gmail.com | 4524587679 | 2024-08-23 | SOFTWARE DEVELOPER | 70000.00 | 0.3000 |
+--------+------------+-----------+----------------------+------------+------------+--------------------+----------+--------+

mysql> SELECT * FROM Emp_Log;
+--------+------------+------------+---------------------+------------+
| Emp_Id | Old_Salary | New_Salary | Edit_Time           | Job_Status |
+--------+------------+------------+---------------------+------------+
|      1 |       0.00 |   50000.00 | 2024-09-23 12:14:58 | ACTIVE     |
|      2 |       0.00 |   60000.00 | 2024-09-23 12:17:37 | ACTIVE     |
|      4 |       0.00 |   70000.00 | 2024-09-23 12:21:12 | ACTIVE     |
|      1 |   50000.00 |   50100.00 | 2024-09-23 12:24:05 | ACTIVE     |
|      1 |   50100.00 |   60120.00 | 2024-09-23 12:25:17 | ACTIVE     |
|      1 |   60120.00 |       0.00 | 2024-09-23 12:43:08 | DELETED    |
+--------+------------+------------+---------------------+------------+

mysql> SELECT * FROM Company_Info;
+-----------+-----------------+
| Emp_Count | Salary_Expenses |
+-----------+-----------------+
|         2 |       130000.00 |
+-----------+-----------------+
*/
