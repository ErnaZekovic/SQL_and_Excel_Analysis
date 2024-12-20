DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP DATABASE IF EXISTS CompanyProject;


CREATE DATABASE IF NOT EXISTS CompanyProject;
USE CompanyProject;


CREATE TABLE IF NOT EXISTS Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    EmployeeID INT,
    StartDate DATE NOT NULL,
    EndDate DATE,
    Hoursworked INT,
    Status ENUM('Active', 'Completed', 'On Hold') DEFAULT 'Active',
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);


INSERT INTO Departments (DepartmentName)
VALUES ('Sales'), ('IT'), ('Marketing'), ('HR'), ('Finance');


INSERT INTO Employees (EmployeeName, DepartmentID, HireDate, Salary)
VALUES 
('John Doe', 1, '2018-05-11', 50000.00),
('Jane Smith', 2, '2018-06-15', 65000.00),
('Emily Johnson', 3, '2020-07-13', 55000.00),
('Michael Brown', 4, '2018-08-04', 48000.00),
('Sarah Davis', 1, '2019-09-01', 52000.00),
('David Miller', 5, '2021-01-20', 60000.00);


ALTER TABLE Departments AUTO_INCREMENT = 1;
ALTER TABLE Employees AUTO_INCREMENT = 1;
ALTER TABLE Projects AUTO_INCREMENT = 1;


INSERT INTO Projects (ProjectName, EmployeeID, StartDate, EndDate, Hoursworked, Status)
VALUES
('Project A', 1, '2024-01-01', '2024-03-01', 100, 'Completed'),
('Project B', 2, '2024-02-01', NULL, 50, 'Active'),
('Project C', 3, '2024-01-15', '2024-03-15', 120, 'Completed'),
('Project D', 4, '2024-03-01', NULL, NULL, 'On Hold'),
('Project E', 5, '2024-02-01', '2024-04-01', 80, 'Completed');




SELECT 
    Employees.EmployeeName AS 'Employee Name',
    SUM(Projects.Hoursworked) AS 'Total Hours Worked'
FROM Employees
LEFT JOIN Projects ON Employees.EmployeeID = Projects.EmployeeID
GROUP BY Employees.EmployeeName;


SELECT 
    EmployeeName AS 'Employee Without Projects',
    (SELECT DepartmentName FROM Departments WHERE Departments.DepartmentID = Employees.DepartmentID) AS 'Department'
FROM Employees
WHERE EmployeeID NOT IN (SELECT EmployeeID FROM Projects);


SELECT 
    Departments.DepartmentName AS 'Department',
    AVG(Employees.Salary) AS 'Average Salary'
FROM Employees
JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY Departments.DepartmentName;


SELECT 
    Status AS 'Project Status',
    COUNT(ProjectID) AS 'Number of Projects'
FROM Projects
GROUP BY Status;


SELECT 
    EmployeeName AS 'Highest Paid Employee',
    Salary AS 'Salary'
FROM Employees
ORDER BY Salary DESC
LIMIT 1;

SELECT 
    EmployeeName AS 'Lowest Paid Employee',
    Salary AS 'Salary'
FROM Employees
ORDER BY Salary ASC
LIMIT 1;


SELECT 
    Departments.DepartmentName AS 'Department',
    COUNT(Projects.ProjectID) AS 'Number of Projects'
FROM Departments
LEFT JOIN Employees ON Departments.DepartmentID = Employees.DepartmentID
LEFT JOIN Projects ON Employees.EmployeeID = Projects.EmployeeID
GROUP BY Departments.DepartmentName
ORDER BY COUNT(Projects.ProjectID) DESC;


SELECT 
    Projects.ProjectName AS 'Project Name',
    Projects.Status AS 'Status',
    Employees.EmployeeName AS 'Assigned Employee',
    Projects.StartDate AS 'Start Date',
    Projects.EndDate AS 'End Date',
    Projects.Hoursworked AS 'Hours Worked'
FROM Projects
LEFT JOIN Employees ON Projects.EmployeeID = Employees.EmployeeID;
