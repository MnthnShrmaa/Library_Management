# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

![](https://github.com/MnthnShrmaa/Library_Management/blob/main/library-wallpapers.jpg)

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/MnthnShrmaa/Library_Management/blob/main/library_EER.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Creating the Branch Table

DROP TABLE IF EXISTS branch;
Create Table branch
(
	branch_id VARCHAR(20) PRIMARY KEY,
	manager_id VARCHAR(20),
	branch_address VARCHAR(150),
	contact_no VARCHAR(20)
);

-- creating the books table

DROP TABLE IF EXISTS books;
Create Table books
(
	isbn varchar(30) PRIMARY KEY,
	book_title varchar(60),
	category varchar(30),
	rental_price FLOAT,	
    status varchar(30),
	author varchar(30),
	publisher varchar(30)

);

-- creating the return_status table

DROP TABLE IF EXISTS return_status;
Create Table return_status
(
	return_id varchar(30) PRIMARY KEY,
	issued_id varchar(30),
	return_book_name varchar(50),
	return_date DATE,
    return_book_isbn varchar(30)

);

-- creating the employees table

DROP TABLE IF EXISTS employees;
Create Table employees
(
	emp_id varchar(30) PRIMARY KEY,
	emp_name varchar(30),
	position varchar(30),
	salary INT,
	branch_id varchar(30) -- FK_BRANCH
);

-- creating the issued_status table

DROP TABLE IF EXISTS issued_status;
Create Table issued_status
(
	issued_id varchar(30) PRIMARY KEY,
	issued_member_id varchar(30), -- FK_MEMBER
	issued_book_name varchar(60), 
	issued_date DATE,
	issued_book_isbn varchar(30), -- FK_BOOKS
	issued_emp_id varchar(30) -- FK_EMPLOYEES
);

-- creating the members table

DROP TABLE IF EXISTS members;
Create Table members
(
	member_id varchar(30) PRIMARY KEY,
	member_name varchar(30),
	member_address varchar(150),
	reg_date DATE
);

-- Adding the foreign keys

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C101','Alice Johnson','123 Main St','2021-05-15'),
('C102','Bob Smith','456 Elm St','2021-06-20'),
('C103','Carol Davis','789 Oak St','2021-07-10'),
('C104','Dave Wilson','567 Pine St','2021-08-05'),
('C105','Eve Brown','890 Maple St','2021-09-25'),
('C106','Frank Thomas','234 Cedar St','2021-10-15'),
('C107','Grace Taylor','345 Walnut St','2021-11-20'),
('C108','Henry Anderson','456 Birch St','2021-12-10'),
('C109','Ivy Martinez','567 Oak St','2022-01-05'),
('C110','Jack Wilson','678 Pine St','2022-02-25'),
('C118','Sam','133 Pine St','2024-06-01'),
('C119','John','143 Main St','2024-05-01');

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
SELECT * FROM books;
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```
**Task 2: Update an Existing Member's Address**

```sql
SELECT * FROM members;
UPDATE members
SET member_address = 'bhai ka bageecha'
WHERE member_id = 'C109';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
SELECT * FROM issued_status;
SELECT * FROM issued_status
where issued_id = 'IS121';
DELETE FROM issued_status
where issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT issued_member_id,
COUNT(issued_book_name) AS no_of_books_issued 
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_book_name)>1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE book_issued_table AS
SELECT b.isbn,
b.book_title,
count(st.issued_member_id) AS book_issued_cnt
FROM books as b
JOIN issued_status AS st
ON b.isbn = st.issued_book_isbn
GROUP BY b.isbn, b.book_title;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

**Task 7: Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

**Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
	b.category,
	SUM(b.rental_price)	as total_income
FROM books as b
JOIN issued_status as sb
ON b.isbn = sb.issued_book_isbn
GROUP BY b.category;
```

**Task 9: List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= date_sub(current_date(), INTERVAL 180 DAY);
```

**Task 10: List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
	e1.emp_name,
    e1.branch_id,
    b.branch_address,
    e1.salary,
    e2.emp_name as managers_name
FROM branch as b
JOIN employees as e1
ON b.branch_id=e1.branch_id
JOIN employees as e2
on e2.emp_id = b.manager_id;
```

**Task 11: Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE books_above_4
AS SELECT * 
FROM books
WHERE rental_price>4;
SELECT * FROM books_above_4;
```

**Task 12: Retrieve the List of Books Not Yet Returned**
```sql
SELECT 
            s.issued_id,
    s.issued_member_id,
    s.issued_book_name,
    s.issued_date,
    s.issued_book_isbn,
    s.issued_emp_id
FROM return_status as r
RIGHT JOIN issued_status as s
ON r.issued_id = s.issued_id
WHERE r.return_id IS NULL;

```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
	m.member_id,
    m.member_name,
    b.book_title,
    s.issued_date,
    r.return_date,
    (current_date()-s.issued_date) AS overdue_days
FROM members as m
JOIN issued_status as s
	ON m.member_id = s.issued_member_id
JOIN books as b
	ON b.isbn = s.issued_book_isbn
LEFT JOIN return_status as r
	ON r.issued_id = s.issued_id
WHERE 
	r.return_date IS NULL
    AND
    (current_date()-s.issued_date) > 650
ORDER BY m.member_id;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

DELIMITER $$

CREATE PROCEDURE add_return_book(return_idp VARCHAR(30), issued_idp VARCHAR(30))

BEGIN
	DECLARE v_isbn VARCHAR(30);
    
	INSERT INTO return_status(return_id, issued_id, return_date)
    VALUES
		(return_idp, issued_idp, CURRENT_DATE());
        
	SELECT issued_book_isbn 
		INTO v_isbn
    FROM issued_status
    WHERE issued_id = issued_idp;
    
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;
    
    SELECT 'THANK YOU FOR RETURNING THE BOOK' as message;
END $$

DELIMITER ;

-- calling procedure
CALL add_return_book('RS119', 'IS126');
CALL add_return_book('RS120', 'IS135');

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
-- employees -> issued_status -> return_status -> books

CREATE TABLE branch_report
AS
SELECT 
	e.branch_id,
	COUNT(e.emp_id) as books_issued_count,
    COUNT(r.return_id) as returned_books_count,
    SUM(b.rental_price) AS total_revenue
FROM employees as e
	JOIN 
    issued_status as st
		ON e.emp_id = st.issued_emp_id
	LEFT JOIN 
    return_status as r
		ON st.issued_id = r.issued_id
	JOIN 
    books as b
		ON b.isbn = st.issued_book_isbn
	GROUP BY e.branch_id
	ORDER BY e.branch_id;
    
SELECT * FROM branch_report;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

CREATE TABLE active_member1
AS
SELECT 
	m.member_id,
    m.member_name,
    COUNT(st.issued_book_isbn) AS issued_books_cnt
FROM members as m
LEFT JOIN issued_status as st
ON m.member_id = st.issued_member_id
WHERE 
	issued_date >= current_date() - interval 7 month
GROUP BY 
	m.member_id,
    m.member_name;

-- ALTERNATIVE

CREATE TABLE active_member2
AS
SELECT * FROM members
WHERE member_id IN (
					SELECT issued_member_id
                    FROM issued_status
                    WHERE 
                    issued_date >= current_date()- INTERVAL 7 month
                    )
                    ;

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
-- issued_status -> employees -> branch
SELECT 
	e.branch_id,
	e.emp_name,
    COUNT(issued_book_isbn) AS book_processed_cnt
FROM issued_status as st
JOIN 
	employees as e
    ON st.issued_emp_id = e.emp_id
GROUP BY e.emp_name,e.branch_id
ORDER BY COUNT(issued_book_isbn) DESC
LIMIT 3;
```



**Task 18: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql

DELIMITER $$

CREATE PROCEDURE issue_book(p_issued_id VARCHAR(30), p_issued_member_id VARCHAR(30), 
							p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(30))
                            
BEGIN
	DECLARE v_status varchar(30);
    
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;
    
	IF v_status = 'yes' THEN

		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, current_date(), p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        SELECT 'Book records added successfully for book isbn : ' AS message, p_issued_book_isbn;
		
        ELSE
        SELECT 'Sorry to inform you the book you have requested is unavailable book_isbn: ' AS message, p_issued_book_isbn;
		END IF;
        
END $$

DELIMITER ;

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

```

## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

Thank you for your interest in this project!
