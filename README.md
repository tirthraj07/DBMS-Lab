### TE DBMS Lab

This repo contains all of my assignment during DBMS Laboratory at PICT

#### Table of Contents 

<table>
<thead>
<tr>
<td>Sr No.</td>
<td>Practical Name</td>
<td>Problem Statement</td>
</tr>
</thead>
<tr>
<td>1</td>
<td>ER Modeling and Normalization</td>
<td>
Decide a case study related to real time application in group of 2-3 students and formulate a problem statement for application to be developed. Propose a Conceptual Design using ER features using tools like ERD plus, ER Win etc. (Identifying entities, relationships between entities, attributes, keys, cardinalities, generalization, specialization etc.) Convert the ER diagram into relational tables and normalize Relational data model
</td>
</tr>

<tr>
<td>2</td>
<td>SQL Queries and Views</td>
<td>
Design and Develop SQL DDL statements which demonstrate the use of SQL objects such as Table, View, Index, Sequence, Synonym, different constraints etc.
</td>
</tr>

<tr>
<td>3</td>
<td>SQL Joins</td>
<td>
Write at least 10 SQL queries for a suitable database application using SQL DML statements
</td>
</tr>

<tr>
<td>4</td>
<td>Stored Procedures</td>
<td>
Unnamed PL/SQL code block: Use of Control structure and Exception handling is mandatory. Write a PL/SQL block of code for the following requirements:
Schema: 1. Borrower (Roll, Name, DateofIssue, NameofBook, Status)
2. Fine (Roll, Date, Amt)
Accept Roll & Name of book from the user. Check the number of days (from the date of issue), if days are between 15 to 30 then fine amount will be Rs 5 per day. If the number of days > 30, per day fine will be Rs 50 per day, and for days less than 30, Rs. 5 per day. After submitting the book, status will change from I to R. If the condition of fine is true, then details will be stored into the Fine table. Frame the problem statement for writing PL/SQL block in line with the above statement.
</td>
</tr>

<tr>
<td>5</td>
<td>Stored Functions</td>
<td>
Write a Stored Procedure namely proc_Grade for the categorization of students. If marks scored by students in the examination is <= 1500 and marks >= 990, then the student will be placed in the distinction category. If marks are between 989 and 900, the category is the first class. If marks 899 and 825, the category is Higher Second Class.
Write a PL/SQL block to use the procedure created with the above requirement. Stud_Marks(name, total_marks) Result(Roll, Name, Class)
</td>
</tr>

<tr>
<td>6</td>
<td>Cursors</td>
<td>
Write a PL/SQL block of code using a parameterized Cursor that will merge the data available in the newly created table N_EmpId with the data available in the table O_EmpId. If the data in the first table already exists in the second table, then that data should be skipped.
</td>
</tr>

<tr>
<td>7</td>
<td>Triggers</td>
<td>
Write a database trigger on the Library table. The system should keep track of the records that are being updated or deleted. The old value of updated or deleted records should be added in the Library_Audit table. Frame the problem statement for writing Database Triggers of all types, in line with the above statement. The problem statement should clearly state the requirements.
</td>
</tr>

<tr>
<td>8</td>
<td>MYSQL JDBC</td>
<td>
Write a program to implement MySQL database connectivity with any front end language to implement Database navigation operations (add, delete, edit, etc.)
</td>
</tr>

<tr>
<td>9</td>
<td>MongoDB Queries</td>
<td>
Design and Develop MongoDB Queries using CRUD operations.
</td>
</tr>

<tr>
<td>10</td>
<td>MongoDB Aggregation Pipelines and Indexing</td>
<td>
Design and Develop MongoDB Queries using aggregation and indexing with a suitable example using MongoDB
</td>
</tr>

<tr>
<td>11</td>
<td>MongoDB Map-reduce</td>
<td>
Implement Map reduces operation with a suitable example using MongoDB.
</td>
</tr>

<tr>
<td>12</td>
<td>MongDB JDBC</td>
<td>
Write a program to implement MongoDB database connectivity with any front end language to implement Database navigation operations (add, delete, edit, etc.)
</td>
</tr>
</table>