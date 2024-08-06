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

    status ENUM('I', 'R') DEFAULT 'I',

    CHECK (status IN ('I', 'R')),
    PRIMARY KEY (roll_no, book)
);


CREATE TABLE Fine (
    roll_no INT PRIMARY KEY,
    dor DATE,
    amount INT,

    FOREIGN KEY (roll_no) REFERENCES Borrower(roll_no) ON DELETE NO ACTION
);



INSERT INTO Borrower 
(roll_no, name, book, doi)
VALUES 
    (31228, 'Advait Joshi', 'Machine Learning for babies', '2024-08-01'),
    (31229, 'Rinit Jain', 'Machine Learning for pros', '2024-07-24'),
    (31230, 'Aniket Joshi', 'ReactJS and Leetcode', '2024-06-01'),
    (31237, 'Amey Kulkarni', 'Flutter Development', '2024-04-13'),
    (31236, 'Mayank Ketan', 'DSA for pros', '2024-08-03'),
    (31235, 'Suvrat Ketkar', 'Dhamdhere', '2024-06-01'),
    (31242, 'Tirthraj Mahajan', 'Webdev and Devops', '2024-05-25');


delimiter //
DECLARE
    roll_no INT;
    

CREATE PROCEDURE proc(IN roll_no int, IN book IN, OUT fine_amount INT)
