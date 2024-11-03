CREATE TABLE borrower (
    roll_no INT NOT NULL,
    borrower_name VARCHAR(50) NOT NULL,
    doi DATE DEFAULT (CURDATE()),
    book_name VARCHAR(50) NOT NULL,
    borrow_status CHAR(1) NOT NULL DEFAULT 'I',
    PRIMARY KEY (roll_no, book_name, doi),
    CHECK (borrow_status IN ('I', 'R'))
);

CREATE TABLE fine (
    roll_no INT,
    fine_date DATE DEFAULT (CURDATE()),
    amount INT NOT NULL,
    FOREIGN KEY (roll_no) REFERENCES borrower(roll_no) ON DELETE NO ACTION,
    CHECK (amount >= 0)
);

INSERT INTO borrower
    (roll_no, borrower_name, doi, book_name)
    VALUES
    (
        1, 'Tirthraj Mahajan', '2024-11-01', 'C++ Programming'
    ),
    (
        1, 'Tirthraj Mahajan', '2024-11-02', 'Python Programming'
    ),
    (
        1, 'Tirthraj Mahajan', '2024-10-15', 'Java Programming'
    ),
    (
        1, 'Tirthraj Mahajan', '2024-10-01', 'Rust Programming'
    ),
    (
        2, 'Advait Joshi', '2024-10-23', 'ML Engineering'
    ),
    (
        2, 'Advait Joshi', '2024-10-23', 'Java Programming'
    ),
    (
        3, 'Suvrat Ketkar', '2023-07-01', 'DSA'
    ),
    (
        4, 'Vardhan Dongre', '2024-06-15', 'Cracking Coding Interviews'
    ),
    (
        5, 'Aditya Mulay', '2024-10-20', 'Java Programming'
    ),
    (
        6, 'Arnav Vaidya', '2024-07-01', 'Cybersecurity'
    );

DELIMITER //

CREATE PROCEDURE return_book (IN student_roll_no INT, IN borrowed_book VARCHAR(50), OUT fine_amount INT)
BEGIN
    DECLARE x INT;

    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No matching record found';
    END;

    SET fine_amount = 0;

    START TRANSACTION;

        SELECT DATEDIFF(CURDATE(), doi) INTO x
        FROM borrower
        WHERE borrower.roll_no = student_roll_no
        AND borrower.book_name = borrowed_book;

        -- if not found then raise a not found exception

        IF (x < 0) THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'invalid fine amount';
        END IF;

        IF (x < 15) THEN
            SET fine_amount = 0;
        END IF;

        IF (x >= 15 && x <= 30) THEN
            SET fine_amount = 5 * (x-14);
        END IF;

        IF (x > 30) THEN
            SET fine_amount = 15*5 + ((x-30)*50);
        END IF;

        UPDATE borrower
        SET borrow_status = 'R'
        WHERE roll_no = student_roll_no
        AND borrow_status = 'I'
        AND book_name = borrowed_book;

        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'book already returned';
        END IF;

        IF (fine_amount = 0) THEN
            COMMIT;
        
        ELSE

            IF EXISTS (SELECT 1 FROM fine WHERE roll_no = student_roll_no AND fine_date = CURDATE())
            THEN
                UPDATE fine
                SET amount = fine_amount + amount
                WHERE
                roll_no = student_roll_no AND fine_date = CURDATE();
            ELSE
                INSERT INTO fine
                (roll_no, amount)
                VALUES
                (student_roll_no, fine_amount);
            END IF;

            COMMIT;
        END IF;

END // 


DELIMITER ;

-- SELECT borrower.*, DATEDIFF(CURDATE(), doi) FROM borrower;
CALL return_book (1, 'C++ Programming', @fine_amount);