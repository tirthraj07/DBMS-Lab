/*
Unnamed PL/SQL code block: Use of Control structure and Exception handling is mandatory. 

Suggested Problem statement: 

Consider Tables: 

1. Borrower(Roll no, Name, Date of Issue, Name of Book, Status)

2. Fine(Roll no, Date, Amt)

Accept Roll no and Name of Book from user. 

Check the  number of days (from date of issue).
If days are betwecn 15 to 30 then:
    fine amount will be Rs 5 per day. 
If no. of days>30:
    pcr day fine will be Rs 50 per day 
    and for days less than 30, Rs. S per day. 

After submitting the book, status will change from I to R.

If condition of fine is true, then details will be stored into fine table.

Also handles the exception by named exception handler or user define exception handler
*/

CREATE TABLE Borrower (
    roll_no INT,
    name VARCHAR(50),
    book VARCHAR(50),
    doi DATE,

    status CHAR(1) DEFAULT 'I',

    CHECK (status IN ('I', 'R')),
    PRIMARY KEY (roll_no, book)
);


CREATE TABLE Fine (
    roll_no INT,
    dor DATE,
    amount INT,
    PRIMARY KEY (roll_no, dor),
    FOREIGN KEY (roll_no) REFERENCES Borrower(roll_no) ON DELETE NO ACTION
);



INSERT INTO Borrower 
(roll_no, name, book, doi)
VALUES 
    (31228, 'Advait Joshi', 'Machine Learning basics', '2024-08-15'),
    (31229, 'Rinit Jain', 'Machine Learning advanced', '2024-07-24'),
    (31230, 'Aniket Joshi', 'ReactJS and Leetcode', '2024-06-01'),
    (31237, 'Amey Kulkarni', 'Flutter Development', '2024-04-13'),
    (31236, 'Mayank Ketan', 'DSA for pros', '2024-08-03'),
    (31235, 'Suvrat Ketkar', 'Dhamdhere', '2024-06-01'),
    (31242, 'Tirthraj Mahajan', 'Webdev and Devops', '2024-05-25');


CREATE VIEW borrower_data AS 
SELECT 
Borrower.roll_no, 
Borrower.name, 
Borrower.book, 
Borrower.status, 
Borrower.doi, 
CURDATE(), 
DATEDIFF(CURDATE(),Borrower.doi) AS DATE_DIFF 
FROM Borrower;

/*
+---------+------------------+---------------------------+--------+------------+------------+-----------+
| roll_no | name             | book                      | status | doi        | CURDATE()  | DATE_DIFF |
+---------+------------------+---------------------------+--------+------------+------------+-----------+
|   31228 | Advait Joshi     | Machine Learning basics   | I      | 2024-08-15 | 2024-08-20 |         5 |
|   31229 | Rinit Jain       | Machine Learning advanced | I      | 2024-07-24 | 2024-08-20 |        27 |
|   31230 | Aniket Joshi     | ReactJS and Leetcode      | I      | 2024-06-01 | 2024-08-20 |        80 |
|   31235 | Suvrat Ketkar    | Dhamdhere                 | I      | 2024-06-01 | 2024-08-20 |        80 |
|   31236 | Mayank Ketan     | DSA for pros              | I      | 2024-08-03 | 2024-08-20 |        17 |
|   31237 | Amey Kulkarni    | Flutter Development       | I      | 2024-04-13 | 2024-08-20 |       129 |
|   31242 | Tirthraj Mahajan | Webdev and Devops         | I      | 2024-05-25 | 2024-08-20 |        87 |
+---------+------------------+---------------------------+--------+------------+------------+-----------+
*/

CREATE VIEW total_fines AS 
SELECT Borrower.roll_no, 
Borrower.name, 
SUM(Fine.amount) AS 'Total Fine' 
FROM Borrower 
LEFT JOIN Fine 
ON Borrower.roll_no = Fine.roll_no 
GROUP BY roll_no ORDER BY roll_no;


delimiter //

CREATE PROCEDURE proc(IN roll INT, IN book VARCHAR(50), OUT fine_amount INT)

BEGIN
    
    -- Number of days between the date of return (dor) and the date of issue (doi)
    DECLARE x INT;

    -- Declare custom exceptions
    DECLARE already_returned_exception CONDITION FOR SQLSTATE '45001';

    -- Declare Handlers

    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        ROLLBACK;  
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No matching record found.';
    END;

    DECLARE EXIT HANDLER FOR already_returned_exception
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Book already returned';
    END;

    -- Start Transaction
    START TRANSACTION;

    -- Calculate the number of overdue days
    SELECT  DATEDIFF(curdate(), Borrower.doi) INTO x
    FROM Borrower
    WHERE Borrower.roll_no = roll AND Borrower.book = book;

    SET fine_amount = 0;

    IF x < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Calculated fine amount is negative.';
    END IF;

    IF (x > 15 && x <= 30) then
        -- First 15 days free then 15-30 5 rs
        SET fine_amount = ((x - 15) * 5);
    END IF;

    IF ( x > 30 ) then
        -- First 15 days free then 15-30 5 rs => 15*5 = 75 and 30+ days = 50 rs per day
        SET fine_amount = ((x - 30) * 50 ) + 15*5;
    END IF;

    -- Check for negative fine_amount (should not happen, but just in case)
    IF fine_amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Calculated fine amount is negative.';
    END IF;

    UPDATE Borrower
    SET Borrower.status = 'R'
    WHERE Borrower.roll_no = roll AND Borrower.book = book;

    -- Check if the book was already returned
    IF ROW_COUNT() = 0 THEN
        SIGNAL already_returned_exception SET MESSAGE_TEXT = 'Book has already been returned.';
    END IF;

    IF EXISTS (SELECT 1 FROM Fine WHERE roll_no = roll AND dor = CURDATE()) THEN
        UPDATE Fine
        SET amount = amount + fine_amount
        WHERE roll_no = roll AND dor = CURDATE();
    ELSE
        INSERT INTO Fine (roll_no, dor, amount) VALUES (roll, CURDATE(), fine_amount);
    END IF;

    -- End Transaction
    COMMIT;

END //
delimiter ;

CALL proc(31228, 'Machine Learning basics', @fine_advait);
CALL proc(31229, 'Machine Learning advanced', @fine_rinit);
CALL proc(31230, 'ReactJS and Leetcode', @fine_aniket);
CALL proc(31236, 'DSA for pros', @fine_mayank);
CALL proc(31237, 'Flutter Development', @fine_amey);
CALL proc(31235, 'Dhamdhere', @fine_suvrat);
CALL proc(31242, 'Webdev and Devops', @fine_tirthraj);

SELECT * FROM borrower_data;

/*
+---------+------------------+---------------------------+--------+------------+------------+-----------+
| roll_no | name             | book                      | status | doi        | CURDATE()  | DATE_DIFF |
+---------+------------------+---------------------------+--------+------------+------------+-----------+
|   31228 | Advait Joshi     | Machine Learning basics   | R      | 2024-08-15 | 2024-08-20 |         5 |
|   31229 | Rinit Jain       | Machine Learning advanced | R      | 2024-07-24 | 2024-08-20 |        27 |
|   31230 | Aniket Joshi     | ReactJS and Leetcode      | R      | 2024-06-01 | 2024-08-20 |        80 |
|   31235 | Suvrat Ketkar    | Dhamdhere                 | R      | 2024-06-01 | 2024-08-20 |        80 |
|   31236 | Mayank Ketan     | DSA for pros              | R      | 2024-08-03 | 2024-08-20 |        17 |
|   31237 | Amey Kulkarni    | Flutter Development       | R      | 2024-04-13 | 2024-08-20 |       129 |
|   31242 | Tirthraj Mahajan | Webdev and Devops         | R      | 2024-05-25 | 2024-08-20 |        87 |
+---------+------------------+---------------------------+--------+------------+------------+-----------+
*/


SELECT * FROM Fine;

/*
+---------+------------+--------+
| roll_no | dor        | amount |
+---------+------------+--------+
|   31228 | 2024-08-20 |      0 |
|   31229 | 2024-08-20 |     60 |
|   31230 | 2024-08-20 |   2575 |
|   31235 | 2024-08-20 |   2575 |
|   31236 | 2024-08-20 |     10 |
|   31237 | 2024-08-20 |   5025 |
|   31242 | 2024-08-20 |   2925 |
+---------+------------+--------+
*/

SELECT * FROM total_fines;

/*
+---------+------------------+------------+
| roll_no | name             | Total Fine |
+---------+------------------+------------+
|   31228 | Advait Joshi     |          0 |
|   31229 | Rinit Jain       |         60 |
|   31230 | Aniket Joshi     |       2575 |
|   31235 | Suvrat Ketkar    |       2575 |
|   31236 | Mayank Ketan     |         10 |
|   31237 | Amey Kulkarni    |       5025 |
|   31242 | Tirthraj Mahajan |       2925 |
+---------+------------------+------------+
*/

/*

    * * * * * * * * Checking Exception Handling * * * * * * * * 

*/

-- Check if book already returned

CALL proc(31228, 'Machine Learning basics', @fine_advait);
-- ERROR 1643 (02000): Book already returned

-- Checking if book doesn't exist

CALL proc(31228, 'Java Full Stack', @fine_advait);
-- ERROR 1643 (02000): No matching record found.

-- Checking if doi > dor

INSERT INTO Borrower (roll_no, name, book, doi) VALUES (31242,'Tirthraj Mahajan', 'Machine Learning', '2024-08-21');
-- +---------+------------------+---------------------------+--------+------------+------------+-----------+
-- | roll_no | name             | book                      | status | doi        | CURDATE()  | DATE_DIFF |
-- +---------+------------------+---------------------------+--------+------------+------------+-----------+
-- |   31242 | Tirthraj Mahajan | Machine Learning          | I      | 2024-08-21 | 2024-08-20 |        -1 |
-- +---------+------------------+---------------------------+--------+------------+------------+-----------+

CALL proc(31242, 'Machine Learning', @fine_tirthraj);

-- ERROR 1644 (45000): Calculated fine amount is negative.
