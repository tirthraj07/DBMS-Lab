/*
Database Trigger (All Types: Row level and Statement level triggers, Before
and After Triggers).
Write a database trigger on Library table. 
The System should keep track of the records that are being updated or deleted. 
The old value of updated or deleted records should be added in Library_ Audit table.

Note: Instructor will Frame the problem statement for writing PL/SQLblock for all
types of Triggers in line with above statement. 
*/

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    book_name VARCHAR(50) NOT NULL,
    author VARCHAR(50)
);

CREATE TABLE library (
    book_id INT PRIMARY KEY,
    quantity INT DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,

    -- CHECKS
    CHECK(quantity>=0),
    CHECK(price>=0),

    -- FOREIGN KEY REFERENCES
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

CREATE TABLE book_issuers (
    issuer_id INT PRIMARY KEY AUTO_INCREMENT,
    issuer_name VARCHAR(50) NOT NULL,
    issued_quantity INT DEFAULT 1,
    issued_price INT,
    
    -- FOREIGN KEY DECLARATIONS
    book_id INT,

    -- FOREIGN KEY REFERENCES
    FOREIGN KEY (book_id) REFERENCES library(book_id)
);

CREATE TABLE library_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT,
    book_name VARCHAR(50),
    quantity INT,
    price INT,
    action VARCHAR(100),
    issuer_name VARCHAR(50) DEFAULT "NULL",
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE VIEW book_details AS
SELECT * FROM books 
NATURAL JOIN library;

INSERT INTO books (book_id, book_name, author)
VALUES
(1, 'Let us C', 'XYZ'),
(2, 'Let us C++', 'ABC'),
(3, 'Python Programming', 'BCD'),
(4, 'Java Programming', 'CDE');

DELIMITER //

CREATE TRIGGER new_library_book
AFTER INSERT ON library
FOR EACH ROW
BEGIN
    DECLARE new_book_name VARCHAR(50);

    SELECT book_name INTO new_book_name
    FROM books
    WHERE book_id = NEW.book_id;

    INSERT INTO library_audit (book_id, book_name, quantity, price, action)
    VALUES
    (NEW.book_id, new_book_name, NEW.quantity, NEW.price, "NEW BOOK AVAILABLE");

END //

DELIMITER ;


INSERT INTO library (book_id, quantity, price)
VALUES
(1, 100, 250),
(2, 200, 300),
(3, 150, 200),
(4, 50, 100);

/*
SELECT * FROM library_audit;
+----------+---------+--------------------+----------+-------+--------------------+-------------+---------------------+
| audit_id | book_id | book_name          | quantity | price | action             | issuer_name | action_timestamp    |
+----------+---------+--------------------+----------+-------+--------------------+-------------+---------------------+
|        1 |       1 | Let us C           |      100 |   250 | NEW BOOK AVAILABLE | NULL        | 2024-11-04 08:31:47 |
|        2 |       2 | Let us C++         |      200 |   300 | NEW BOOK AVAILABLE | NULL        | 2024-11-04 08:31:47 |
|        3 |       3 | Python Programming |      150 |   200 | NEW BOOK AVAILABLE | NULL        | 2024-11-04 08:31:47 |
|        4 |       4 | Java Programming   |       50 |   100 | NEW BOOK AVAILABLE | NULL        | 2024-11-04 08:31:47 |
+----------+---------+--------------------+----------+-------+--------------------+-------------+---------------------+
*/

DELIMITER //

CREATE TRIGGER update_library_books
BEFORE UPDATE ON library
FOR EACH ROW
BEGIN
    DECLARE action VARCHAR(100);
    DECLARE book_name VARCHAR(50);

    IF NEW.quantity IS NULL THEN
        SET NEW.quantity = OLD.quantity;
    END IF;

    IF NEW.price IS NULL THEN
        SET NEW.price = OLD.price;
    END IF;

    IF NEW.quantity != OLD.quantity THEN
        SET action = "Changes in book quantity";
    ELSEIF NEW.price != OLD.price THEN
        SET action = "Changes in book price";
    ELSE
        SET action = "Changes in book data";
    END IF;

    SELECT books.book_name INTO book_name
    FROM books
    WHERE books.book_id = NEW.book_id;

    INSERT INTO library_audit (book_id, book_name, quantity, price, action)
    VALUES
    (NEW.book_id, book_name, NEW.quantity, NEW.price, action);

END //

DELIMITER ;


UPDATE library
SET quantity = 200
WHERE book_id = 1;

UPDATE library
SET price = 200
WHERE book_id = 2;

/*
+----------+---------+--------------------+----------+-------+--------------------------+-------------+---------------------+
| audit_id | book_id | book_name          | quantity | price | action                   | issuer_name | action_timestamp    |
+----------+---------+--------------------+----------+-------+--------------------------+-------------+---------------------+
|        1 |       1 | Let us C           |      100 |   250 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        2 |       2 | Let us C++         |      200 |   300 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        3 |       3 | Python Programming |      150 |   200 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        4 |       4 | Java Programming   |       50 |   100 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        5 |       1 | Let us C           |      200 |   250 | Changes in book quantity | NULL        | 2024-11-04 08:49:37 |
|        6 |       2 | Let us C++         |      200 |   200 | Changes in book price    | NULL        | 2024-11-04 08:50:38 |
+----------+---------+--------------------+----------+-------+--------------------------+-------------+---------------------+
*/

DELIMITER //

CREATE TRIGGER before_book_removal
BEFORE DELETE ON books
FOR EACH ROW
BEGIN
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "entry not found";
    END;

    INSERT INTO library_audit (book_id, book_name, quantity, price, action)
    VALUES
    (OLD.book_id, OLD.book_name, 0, 0, "Book Deletion");
END //

DELIMITER ;

DELETE FROM books
WHERE book_id = 4;

/*
+----------+---------+--------------------+----------+-------+--------------------------+-------------+---------------------+
| audit_id | book_id | book_name          | quantity | price | action                   | issuer_name | action_timestamp    |
+----------+---------+--------------------+----------+-------+--------------------------+-------------+---------------------+
|        1 |       1 | Let us C           |      100 |   250 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        2 |       2 | Let us C++         |      200 |   300 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        3 |       3 | Python Programming |      150 |   200 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        4 |       4 | Java Programming   |       50 |   100 | NEW BOOK AVAILABLE       | NULL        | 2024-11-04 08:31:47 |
|        5 |       1 | Let us C           |      200 |   250 | Changes in book quantity | NULL        | 2024-11-04 08:49:37 |
|        6 |       2 | Let us C++         |      200 |   200 | Changes in book price    | NULL        | 2024-11-04 08:50:38 |
|        7 |       4 | Java Programming   |        0 |     0 | Book Deletion            | NULL        | 2024-11-04 09:01:03 |
+----------+---------+--------------------+----------+-------+--------------------------+-------------+---------------------+
*/

DELIMITER //

CREATE TRIGGER before_insert_in_book_issuers
BEFORE INSERT ON book_issuers
FOR EACH ROW
BEGIN
    DECLARE book_name VARCHAR(50);
    DECLARE book_price DECIMAL(10,2);

    IF EXISTS (SELECT '1' FROM library WHERE library.book_id = NEW.book_id AND library.quantity >= NEW.issued_quantity) THEN
        SELECT books.book_name INTO book_name
        FROM books
        WHERE book_id = NEW.book_id;

        SELECT price INTO book_price
        FROM library
        WHERE book_id = NEW.book_id;

        UPDATE library
        SET quantity = quantity - NEW.issued_quantity
        WHERE book_id = NEW.book_id;

        SET NEW.issuer_name = UPPER(TRIM(NEW.issuer_name));
        SET NEW.issued_price = NEW.issued_quantity * book_price;

        INSERT INTO library_audit (book_id, book_name, quantity, price, action, issuer_name)
        VALUES
        (NEW.book_id, book_name, NEW.issued_quantity, NEW.issued_price, "Issued Book(s)", NEW.issuer_name);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Couldn't proceed with the book issue";    
    END IF;

END //

DELIMITER ;


INSERT INTO book_issuers (issuer_name, book_id, issued_quantity)
VALUES 
(
    'Tirthraj Mahajan', 2, 3
);

/*
mysql> SELECT * FROM book_issuers;
+-----------+------------------+-----------------+--------------+---------+
| issuer_id | issuer_name      | issued_quantity | issued_price | book_id |
+-----------+------------------+-----------------+--------------+---------+
|         1 | TIRTHRAJ MAHAJAN |               3 |          600 |       2 |
+-----------+------------------+-----------------+--------------+---------+
1 row in set (0.00 sec)

mysql> SELECT * FROM book_details;
+---------+--------------------+--------+----------+--------+
| book_id | book_name          | author | quantity | price  |
+---------+--------------------+--------+----------+--------+
|       1 | Let us C           | XYZ    |      200 | 250.00 |
|       2 | Let us C++         | ABC    |      197 | 200.00 |
|       3 | Python Programming | BCD    |      150 | 200.00 |
+---------+--------------------+--------+----------+--------+
3 rows in set (0.00 sec)

mysql> SELECT * FROM library_audit;
+----------+---------+--------------------+----------+-------+--------------------------+------------------+---------------------+
| audit_id | book_id | book_name          | quantity | price | action                   | issuer_name      | action_timestamp    |
+----------+---------+--------------------+----------+-------+--------------------------+------------------+---------------------+
|        1 |       1 | Let us C           |      100 |   250 | NEW BOOK AVAILABLE       | NULL             | 2024-11-04 08:31:47 |
|        2 |       2 | Let us C++         |      200 |   300 | NEW BOOK AVAILABLE       | NULL             | 2024-11-04 08:31:47 |
|        3 |       3 | Python Programming |      150 |   200 | NEW BOOK AVAILABLE       | NULL             | 2024-11-04 08:31:47 |
|        4 |       4 | Java Programming   |       50 |   100 | NEW BOOK AVAILABLE       | NULL             | 2024-11-04 08:31:47 |
|        5 |       1 | Let us C           |      200 |   250 | Changes in book quantity | NULL             | 2024-11-04 08:49:37 |
|        6 |       2 | Let us C++         |      200 |   200 | Changes in book price    | NULL             | 2024-11-04 08:50:38 |
|        7 |       4 | Java Programming   |        0 |     0 | Book Deletion            | NULL             | 2024-11-04 09:01:03 |
|        8 |       2 | Let us C++         |      197 |   200 | Changes in book quantity | NULL             | 2024-11-04 09:25:18 |
|        9 |       2 | Let us C++         |        3 |   600 | Issued Book(s)           | TIRTHRAJ MAHAJAN | 2024-11-04 09:25:18 |
+----------+---------+--------------------+----------+-------+--------------------------+------------------+---------------------+
9 rows in set (0.00 sec)
*/