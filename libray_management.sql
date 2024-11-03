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
SELECT * FROM members;

SELECT * FROM return_status;
SELECT * FROM issued_status;
SELECT * FROM branch;
SELECT * FROM books;
