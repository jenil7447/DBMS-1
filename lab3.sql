CREATE TABLE Departments (
 DepartmentID INT PRIMARY KEY,
 DepartmentName VARCHAR(100) NOT NULL UNIQUE,
 ManagerID INT NOT NULL,
 Location VARCHAR(100) NOT NULL
);
CREATE TABLE Employee (
 EmployeeID INT PRIMARY KEY,
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100) NOT NULL,
 DoB DATETIME NOT NULL,
 Gender VARCHAR(50) NOT NULL,
 HireDate DATETIME NOT NULL,
 DepartmentID INT NOT NULL,
 Salary DECIMAL(10, 2) NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
-- Create Projects Table
CREATE TABLE Projects (
 ProjectID INT PRIMARY KEY,
 ProjectName VARCHAR(100) NOT NULL,
 StartDate DATETIME NOT NULL,
 EndDate DATETIME NOT NULL,
 DepartmentID INT NOT NULL,
 FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID, Location)
VALUES
 (1, 'IT', 101, 'New York'),
 (2, 'HR', 102, 'San Francisco'),
 (3, 'Finance', 103, 'Los Angeles'),
 (4, 'Admin', 104, 'Chicago'),
 (5, 'Marketing', 105, 'Miami');
INSERT INTO Employee (EmployeeID, FirstName, LastName, DoB, Gender, HireDate, DepartmentID,
Salary)
VALUES
 (101, 'John', 'Doe', '1985-04-12', 'Male', '2010-06-15', 1, 75000.00),
 (102, 'Jane', 'Smith', '1990-08-24', 'Female', '2015-03-10', 2, 60000.00),
 (103, 'Robert', 'Brown', '1982-12-05', 'Male', '2008-09-25', 3, 82000.00),
 (104, 'Emily', 'Davis', '1988-11-11', 'Female', '2012-07-18', 4, 58000.00),
 (105, 'Michael', 'Wilson', '1992-02-02', 'Male', '2018-11-30', 5, 67000.00);
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID)
VALUES
 (201, 'Project Alpha', '2022-01-01', '2022-12-31', 1),
 (202, 'Project Beta', '2023-03-15', '2024-03-14', 2),
 (203, 'Project Gamma', '2021-06-01', '2022-05-31', 3),
 (204, 'Project Delta', '2020-10-10', '2021-10-09', 4),
 (205, 'Project Epsilon', '2024-04-01', '2025-03-31', 5);


-- Part – A
--1. Create Stored Procedure for Employee table As User enters either First Name or Last Name and based
--on this you must give EmployeeID, DOB, Gender & Hiredate.
CREATE OR ALTER PROC pr_emp_getbyname
@fname varchar(15) = null,
@lname varchar(14) = null
AS 
BEGIN
	SELECT EmployeeID,DoB,Gender,Hiredate
	FROM Employee
	WHERE FirstName = @fname OR LastName = @lname
END
exec pr_emp_getbyname 'john','smith' 


--2. Create a Procedure that will accept Department Name and based on that gives employees list who
--belongs to that department.

CREATE OR ALTER PROC pr_emplist
@Dname varchar(15)
AS
BEGIN
	SELECT * 
	FROM Employee
	WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = @Dname)
END
EXEC pr_emplist 'IT'

--3. Create a Procedure that accepts Project Name & Department Name and based on that you must give
--all the project related details.

CREATE OR ALTER PROC pr_projectDetails
@Pname varchar(15),
@Dname varchar(15)
AS
BEGIN
	SELECT * 
	FROM Projects
	WHERE projectName = @Pname AND DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = @Dname)
END

EXEC pr_projectDetails 'Project Beta','HR'

--4. Create a procedure that will accepts any integer and if salary is between provided integer, then those
--employee list comes in output.

CREATE OR ALTER PROC pr_emplist
@frange int,
@srange int
AS
BEGIN 
	SELECT * 
	FROM Employee
	WHERE Salary BETWEEN @frange AND @srange
END

EXEC pr_emplist 50000,60000

--5. Create a Procedure that will accepts a date and gives all the employees who all are hired on that date.

CREATE OR ALTER PROC pr_emp_empllist
@Date varchar(15)
AS
BEGIN
	SELECT FirstName 
	FROM Employee
	WHERE HireDate = @Date
END

EXEC pr_emp_empllist '20100615'

--Part – B
--6. Create a Procedure that accepts Gender’s first letter only and based on that employee details will be
--served.

CREATE OR ALTER PROC pr_employee_emplist
@Fletter varchar(1)
AS
BEGIN
	SELECT *
	FROM Employee
	WHERE  Gender like @Fletter+'%'
END

EXEC pr_employee_emplist 'M'

--7. Create a Procedure that accepts First Name or Department Name as input and based on that employee
--data will come.
CREATE OR ALTER PROC pr_empData
@FName varchar(15),
@DName varchar(15)
AS
BEGIN
	SELECT *
	FROM Employee
	WHERE FirstName = @FName AND DepartmentID =(SELECT DepartmentID FROM Departments WHERE DepartmentName = @DName)
END

EXEC pr_empData 'john','IT'

--8. Create a procedure that will accepts location, if user enters a location any characters, then he/she will
--get all the departments with all data.
CREATE OR ALTER PROC pr_deptData
@Loc varchar(15)
AS
BEGIN
	SELECT *
	FROM Departments
	WHERE Location like '%'+@loc+'%'
END

EXEC pr_deptData 'N'

--Part – C
--9. Create a procedure that will accepts From Date & To Date and based on that he/she will retrieve Project
--related data.
CREATE OR ALTER PROC pr_deptData
@Loc varchar(15)
AS
BEGIN
	SELECT *
	FROM Departments
	WHERE Location like '%'+@loc+'%'
END

EXEC pr_deptData 'N'


--10. Create a procedure in which user will enter project name & location and based on that you must
--provide all data with Department Name, Manager Name with Project Name & Starting Ending Dates.
CREATE OR ALTER PROC pr_allData
@PName varchar(15),@loc varchar(15)
AS
BEGIN
	SELECT Departments.DepartmentName,Departments.ManagerID,Projects.ProjectName,Projects.StartDate,Projects.EndDate
	FROM Projects 
	JOIN Departments
	ON Projects.DepartmentID = Departments.DepartmentID
	WHERE Projects.ProjectName = @PName AND Departments.Location = @loc
END
EXEC pr_allData 'PROJECT ALPHA','NEW york'
	
