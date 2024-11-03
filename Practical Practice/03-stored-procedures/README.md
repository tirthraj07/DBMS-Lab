Unnamed PL/SQL code block: Use of Control structure and Exception handling is mandatory. 

Suggested Problem statement: 

Consider Tables: 

1. Borrower(Roll no, Name, Date of Issue, Name of Book, Status)

2. Fine(Roll no, Date, Amt)

Accept Roll no and Name of Book from user. 

Check the  number of days (from date of issue).
If days are between 15 to 30 then:
    fine amount will be Rs 5 per day. 
If no. of days>30:
    per day fine will be Rs 50 per day 
    and for days less than 30, Rs. S per day. 

After submitting the book, status will change from I to R.

If condition of fine is true, then details will be stored into fine table.

Also handles the exception by named exception handler or user define exception handler