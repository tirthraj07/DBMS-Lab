CREATE TABLE stud_marks (
    roll_no INT PRIMARY KEY AUTO_INCREMENT,
    stud_name VARCHAR(50) NOT NULL,
    total_marks INT NOT NULL,
    CHECK((total_marks > 0) AND (total_marks <= 1500))
);

CREATE TABLE result (
    roll_no INT PRIMARY KEY,
    stud_name VARCHAR(50) NOT NULL,
    class VARCHAR(50) NOT NULL,
    CHECK (class IN ('distinction', 'first class', 'higher second class', 'passed'))
);

INSERT INTO stud_marks (roll_no, stud_name, total_marks)
VALUES
(1, 'Tirthraj', 1450),
(2, 'Aditya', 950),
(3, 'Arnav', 845),
(4, 'Ninad', 700);

DELIMITER //

CREATE FUNCTION find_class (marks INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF (marks <= 1500 && marks >= 990) THEN
        RETURN "distinction";
    ELSEIF (marks >= 900) THEN
        RETURN "first class";
    ELSEIF (marks >= 825) THEN
        RETURN "higher second class";
    ELSE
        RETURN "passed";
    END IF;
END //


CREATE PROCEDURE get_result (IN roll_no INT, OUT class VARCHAR(50))
BEGIN
    DECLARE student_name VARCHAR(50);
    DECLARE marks INT;

    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'No student found';
    END;

    START TRANSACTION;
        SELECT stud_name, total_marks INTO student_name, marks
        FROM stud_marks
        WHERE
        stud_marks.roll_no = roll_no;

        SELECT find_class(marks) INTO class;

        IF EXISTS (SELECT '1' FROM result WHERE result.roll_no = roll_no) THEN
            UPDATE result
            SET 
            result.class = class,
            result.stud_name = student_name
            WHERE result.roll_no = roll_no;
        ELSE
            INSERT INTO result (roll_no, stud_name, class) VALUES (roll_no, student_name, class);
        END IF;
    COMMIT;
    
END //

DELIMITER ;