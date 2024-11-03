CREATE TABLE o_emp (
    e_id INT PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    salary INT NOT NULL
);

CREATE TABLE n_emp (
    e_id INT PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    salary INT NOT NULL
);

INSERT INTO o_emp 
(e_id, fname, lname, salary)
VALUES
(
    1, 'Tirthraj', 'Mahajan', 1000
),
(
    2, 'Petr', 'Cech', 2000
),
(
    3, 'Eden', 'Hazard', 3000
),
(
    4, 'Frank', 'Lampard', 4000
),
(
    5, 'John', 'Terry', 5000
),
(
    6, 'Cole', 'Palmar', 6000
),
(
    7, 'Diego', 'Costa', 7000
),
(
    8, 'Nikolas', 'Jackson', 8000
),
(
    9, 'Harry', 'Kane', 9000
);

INSERT INTO n_emp
(e_id, fname, lname, salary)
VALUES
(
    1, 'Tirthraj', 'Mahajan', 1000
),
(
    2, 'Petr', 'Cech', 2000
),
(
    10, 'Arjen', 'Robben', 3000
),
(
    11, 'Oliver', 'Giroud', 4000
),
(
    12, 'John', 'Terry', 5000
),
(
    13, 'Cesar', 'Azpilicueta', 6000
),
(
    14, 'Alvaro', 'Morata', 7000
),
(
    8, 'Nikolas', 'Jackson', 8000
),
(
    9, 'Harry', 'Kane', 9000
);


-- Copy old into new

DELIMITER //

CREATE PROCEDURE copy_data()
BEGIN

    DECLARE done INT;
    DECLARE old_e_id INT;
    DECLARE old_fname VARCHAR(50);
    DECLARE old_lname VARCHAR(50);
    DECLARE old_salary INT;
    DECLARE cur CURSOR FOR SELECT e_id, fname, lname, salary FROM o_emp;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET done = 1;
    END;


    SET done = 0;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO old_e_id, old_fname, old_lname, old_salary;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF NOT EXISTS (SELECT '1' FROM n_emp WHERE n_emp.e_id = old_e_id) THEN
            INSERT INTO n_emp (e_id, fname, lname, salary) VALUES (old_e_id, old_fname, old_lname, old_salary);
        END IF;

    END LOOP;

    CLOSE cur;
END //


DELIMITER ;

CALL copy_data();

SELECT * FROM n_emp;
/*
+------+----------+-------------+--------+
| e_id | fname    | lname       | salary |
+------+----------+-------------+--------+
|    1 | Tirthraj | Mahajan     |   1000 |
|    2 | Petr     | Cech        |   2000 |
|    3 | Eden     | Hazard      |   3000 |
|    4 | Frank    | Lampard     |   4000 |
|    5 | John     | Terry       |   5000 |
|    6 | Cole     | Palmar      |   6000 |
|    7 | Diego    | Costa       |   7000 |
|    8 | Nikolas  | Jackson     |   8000 |
|    9 | Harry    | Kane        |   9000 |
|   10 | Arjen    | Robben      |   3000 |
|   11 | Oliver   | Giroud      |   4000 |
|   12 | John     | Terry       |   5000 |
|   13 | Cesar    | Azpilicueta |   6000 |
|   14 | Alvaro   | Morata      |   7000 |
+------+----------+-------------+--------+
*/