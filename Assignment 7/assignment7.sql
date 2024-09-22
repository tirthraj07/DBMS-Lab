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

CREATE TABLE IssueTable (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_name VARCHAR(50) NOT NULL,
    book_id INT NOT NULL UNIQUE,
    doi DATE,
    FOREIGN KEY (book_id) REFERENCES Books (book_id) ON DELETE NO ACTION
);

CREATE TABLE Library_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    book_name VARCHAR(50),
    count INT,
    action VARCHAR(50), -- "UPDATE" or "DELETE"
    person_name VARCHAR(50) NOT NULL DEFAULT "NULL",
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER before_INSERT_on_books
BEFORE INSERT ON Books
FOR EACH ROW
BEGIN
DECLARE new_book_id INT;

INSERT INTO Library_Audit (book_id, book_name, count, action) VALUES (NEW.book_id, NEW.book_name, NEW.count, 'INSERT');

END;
//

CREATE TRIGGER before_delete_on_books
BEFORE DELETE ON Books
FOR EACH ROW
BEGIN

INSERT INTO Library_Audit (book_id, book_name, count, action) VALUES (OLD.book_id, OLD.book_name, OLD.count, 'DELETE');

END;
//

-- Trigger for checking book availability before issuing
CREATE TRIGGER before_insert_in_issue_table
BEFORE INSERT ON IssueTable
FOR EACH ROW
BEGIN
    -- Check if the book count > 0
    DECLARE bookCount INT;
    SELECT count INTO bookCount
    FROM Books
    WHERE book_id = NEW.book_id;

    -- Raise an error if no copies are available
    IF bookCount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot issue book: No copies available';
    END IF;

    -- Insert info into Library Audit for the issuance (before the actual insert)
    INSERT INTO Library_Audit (book_id, book_name, count, action, person_name)
    VALUES (NEW.book_id, (SELECT book_name FROM Books WHERE book_id = NEW.book_id), bookCount, 'BEFORE INSERT', NEW.person_name);
END;
//

CREATE PROCEDURE DecrementBookCount(IN p_book_id INT)
BEGIN
    UPDATE Books SET count = count - 1 WHERE book_id = p_book_id;
END;
//

-- Trigger for decrementing book count after issuing
CREATE TRIGGER after_insert_in_issue_table
AFTER INSERT ON IssueTable
FOR EACH ROW
BEGIN
    DECLARE newBookCount INT;
    DECLARE bookName VARCHAR(255);
    
    -- Decrement book count
    CALL DecrementBookCount(NEW.book_id);

    -- Get the new book count after decrement
    
    SELECT count, book_name INTO newBookCount, bookName
    FROM Books
    WHERE book_id = NEW.book_id;

    -- Insert into Library Audit for the issuance
    INSERT INTO Library_Audit (book_id, book_name, count, action, person_name)
    VALUES (NEW.book_id, bookName, newBookCount, 'AFTER INSERT', NEW.person_name);
END;
//

DELIMITER ;


/*
BEFORE INSERT

mysql> SELECT * FROM Books;
Empty set (0.00 sec)

mysql> SELECT * FROM Library_Audit;
Empty set (0.01 sec)
*/

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

/*
mysql> SELECT * FROM Books;
+---------+------------------------+-------+
| book_id | book_name              | count |
+---------+------------------------+-------+
|       1 | To Kill a Mockingbird  |     5 |
|       2 | 1984                   |     7 |
|       3 | The Great Gatsby       |     3 |
|       4 | Pride and Prejudice    |     6 |
|       5 | The Catcher in the Rye |     4 |
|       6 | Brave New World        |     8 |
|       7 | The Hobbit             |     9 |
|       8 | Fahrenheit 451         |     1 |
|       9 | Jane Eyre              |    10 |
+---------+------------------------+-------+

mysql> SELECT * FROM Library_Audit;
+----------+---------+------------------------+-------+--------+-------------+---------------------+
| audit_id | book_id | book_name              | count | action | person_name | action_timestamp    |
+----------+---------+------------------------+-------+--------+-------------+---------------------+
|        1 |       0 | To Kill a Mockingbird  |     5 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        2 |       0 | 1984                   |     7 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        3 |       0 | The Great Gatsby       |     3 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        4 |       0 | Pride and Prejudice    |     6 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        5 |       0 | The Catcher in the Rye |     4 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        6 |       0 | Brave New World        |     8 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        7 |       0 | The Hobbit             |     9 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        8 |       0 | Fahrenheit 451         |     1 | INSERT | NULL        | 2024-09-21 12:35:40 |
|        9 |       0 | Jane Eyre              |    10 | INSERT | NULL        | 2024-09-21 12:35:40 |
+----------+---------+------------------------+-------+--------+-------------+---------------------+
9 rows in set (0.00 sec)

*/

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
