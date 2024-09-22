/*
Database Trigger (All Types: Row level and Statement level triggers, Before
and After Triggers).
Write a database trigger on Library table. 
The System should keep track of the records that are being updated or deleted. 
The old value of updated or deleted records should be added in Library_ Audit table.

Note: Instructor will Frame the problem statement for writing PL/SQLblock for all
types of Triggers in line with above statement. 
*/


CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(50) NOT NULL,
    count INT NOT NULL DEFAULT 0
);

INSERT INTO Books (book_name, count) VALUES 
('To Kill a Mockingbird', 5),
('1984', 7),
('The Great Gatsby', 3),
('Pride and Prejudice', 6),
('The Catcher in the Rye', 4),
('Brave New World', 8),
('The Hobbit', 9),
('Fahrenheit 451', 1),
('Jane Eyre', 10);

CREATE TABLE IssueTable (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_name VARCHR(50) NOT NULL,
    book_id INT NOT NULL UNIQUE,
    doi DATE,
    status CHAR(1) DEFAULT 'I'

    FOREIGN KEY (book_id) REFERENCES Books (book_id) ON DELETE NO ACTION
);


INSERT INTO IssueTable (person_name, book_id, doi) VALUES 
(
    'Tirthraj Mahajan', 
    (SELECT book_id FROM Books WHERE book_name = 'To Kill a Mockingbird'),
    '2024-08-01'
),
(
    'Ariana Smith', 
    (SELECT book_id FROM Books WHERE book_name = '1984'),
    '2024-08-05'
),
(
    'John Doe', 
    (SELECT book_id FROM Books WHERE book_name = 'The Great Gatsby'),
    '2024-07-20'
),
(
    'Emily Johnson', 
    (SELECT book_id FROM Books WHERE book_name = 'Pride and Prejudice'),
    '2024-06-15'
),
(
    'Michael Brown', 
    (SELECT book_id FROM Books WHERE book_name = 'The Catcher in the Rye'),
    '2024-08-10'
),
(
    'Sarah Davis', 
    (SELECT book_id FROM Books WHERE book_name = 'Brave New World'),
    '2024-05-22'
),
(
    'David Wilson', 
    (SELECT book_id FROM Books WHERE book_name = 'The Hobbit'),
    '2024-08-12'
),
(
    'Sophia Martinez', 
    (SELECT book_id FROM Books WHERE book_name = 'Fahrenheit 451'),
    '2024-07-30'
),
(
    'James Taylor', 
    (SELECT book_id FROM Books WHERE book_name = 'Jane Eyre'),
    '2024-08-01'
),
(
    'Olivia Garcia', 
    (SELECT book_id FROM Books WHERE book_name = 'To Kill a Mockingbird'),
    '2024-08-07'
),
(
    'Liam Anderson', 
    (SELECT book_id FROM Books WHERE book_name = '1984'),
    '2024-06-25'
),
(
    'Emma Thompson', 
    (SELECT book_id FROM Books WHERE book_name = 'The Great Gatsby'),
    '2024-07-15'
),
(
    'Noah Martinez', 
    (SELECT book_id FROM Books WHERE book_name = 'Pride and Prejudice'),
    '2024-08-02'
),
(
    'Isabella Lee', 
    (SELECT book_id FROM Books WHERE book_name = 'The Catcher in the Rye'),
    '2024-08-03'
),
(
    'Ethan Moore', 
    (SELECT book_id FROM Books WHERE book_name = 'Brave New World'),
    '2024-08-09'
);