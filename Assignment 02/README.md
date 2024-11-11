### Assignment No 2B

### Assignment No 2B (Student Schema)
Consider the following relational Schema.
● Student( s_id,Drive_id,T_id,s_name,CGPA,s_branch,S_dob)
● PlacementDrive( Drive_id,Pcompany_name,package,location)
● Training ( T_id,Tcompany_name,T_Fee,T_year)

Use the tables created in assignment no 2 and execute the following queries:
1. Insert at least 10 records in the Student table and insert other tables accordingly.
2. Display all students details with branch ‘Computer ‘and ‘It’ and student name
starting with 'a' or 'd'.
3. list the number of different companies.(use of distinct)
4. Give 15% increase in fee of the Training whose joining year is 2019.
5. Delete Student details having CGPA score less than 7.
6. Find the names of companies belonging to pune or Mumbai 
7. Find the student name who joined training in 1-1-2019 as well as in 1-1-2021
8. Find the student name having maximum CGPA score and names of students
having CGPA score between 7 to 9 .
9. Display all Student name with T_id with decreasing order of Fees
10. Display PCompany name, S_name ,location and Package with Package 30K,
40K and 50k

A2: Guidelines
✔ Synonyms not supported in MySQL. Required to include example from oracle in
write-up or we can use Alias name for table name in query.
✔ Sequence should be implemented with AUTO_INCREMENT. Concept of sequence from oracle must be included in the write-up.
✔ Simple view, Index (simple, unique, composite and text – show index after
creation)


Here's a detailed explanation of each of the topics, along with Oracle examples and MySQL alternatives:

---

### 1. Synonyms in Oracle (Not Supported in MySQL)
In Oracle, **synonyms** are aliases for database objects like tables, views, or procedures. They allow access to an object without needing to specify the schema name, enhancing convenience and security.

- **Oracle Synonym Example**:
    ```sql
    CREATE SYNONYM emp_synonym FOR hr.employee;
    ```
    This creates a synonym `emp_synonym` for the `hr.employee` table, allowing access with:
    ```sql
    SELECT * FROM emp_synonym;
    ```

**In MySQL**: Synonyms are not supported, but you can use **table aliases** within queries for similar functionality.
- **MySQL Table Alias Example**:
    ```sql
    SELECT * FROM employee AS emp_alias;
    ```
    This query uses `emp_alias` as an alias for the `employee` table for the duration of the query.

---

### 2. Sequences in Oracle vs. AUTO_INCREMENT in MySQL
In Oracle, **sequences** generate unique numbers, commonly used to create primary keys. They are separate objects from tables, making them reusable across different tables and customizable in terms of increment value, starting point, and caching options.

- **Oracle Sequence Example**:
    ```sql
    CREATE SEQUENCE emp_seq
        START WITH 1
        INCREMENT BY 1
        CACHE 20;
    ```

    To use the sequence in an `INSERT`:
    ```sql
    INSERT INTO employee (emp_id, name) VALUES (emp_seq.NEXTVAL, 'John Doe');
    ```

**In MySQL**: **AUTO_INCREMENT** on a column serves a similar purpose and is simpler to use since it’s directly tied to a table column.

- **MySQL AUTO_INCREMENT Example**:
    ```sql
    CREATE TABLE employee (
        emp_id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(100)
    );
    ```
    Here, `emp_id` auto-increments with each new row insertion.

---

### 3. Simple View in Oracle and MySQL
A **view** is a virtual table based on a SQL query, allowing users to save complex queries as objects and simplifying access to data.

- **Oracle View Example**:
    ```sql
    CREATE VIEW emp_view AS
    SELECT emp_id, name, department
    FROM employee
    WHERE department = 'Sales';
    ```
    - You can then query the view as a table:
      ```sql
      SELECT * FROM emp_view;
      ```

- **MySQL View Example** (identical syntax):
    ```sql
    CREATE VIEW emp_view AS
    SELECT emp_id, name, department
    FROM employee
    WHERE department = 'Sales';
    ```

---

### 4. Indexes in MySQL
An **index** speeds up data retrieval in a table. MySQL supports different types of indexes, including **simple**, **unique**, **composite**, and **full-text** indexes.

#### 4.1 Simple Index
A **simple index** is a basic index on a single column.
- **MySQL Simple Index Example**:
    ```sql
    CREATE INDEX idx_name ON employee (name);
    ```

#### 4.2 Unique Index
A **unique index** ensures all values in the indexed column(s) are unique, adding a constraint.
- **MySQL Unique Index Example**:
    ```sql
    CREATE UNIQUE INDEX idx_unique_name ON employee (name);
    ```

#### 4.3 Composite Index
A **composite index** is an index on multiple columns, improving query performance on combined column searches.
- **MySQL Composite Index Example**:
    ```sql
    CREATE INDEX idx_composite ON employee (department, name);
    ```

#### 4.4 Full-Text Index
A **full-text index** is used for full-text searches on large text fields.
- **MySQL Full-Text Index Example** (only for `CHAR`, `VARCHAR`, or `TEXT` columns):
    ```sql
    CREATE FULLTEXT INDEX idx_text_description ON employee (description);
    ```

#### Viewing Indexes After Creation
In MySQL, you can view all indexes on a table using:
```sql
SHOW INDEX FROM employee;
```

--- 

### Summary
- **Synonyms** in Oracle provide aliases for database objects but are unsupported in MySQL, where **table aliases** are used instead.
- **Sequences** in Oracle are replaced by **AUTO_INCREMENT** in MySQL.
- **Views** work similarly in both Oracle and MySQL.
- **Indexes** in MySQL come in various forms, each tailored to improve performance for different use cases.