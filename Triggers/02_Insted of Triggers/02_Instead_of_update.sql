USE DB_42
GO

CREATE TABLE dbo.EmployeeDetails
(
    EmployeeID INT PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(150),
    Department NVARCHAR(50)
);
GO

CREATE TABLE dbo.JobRecords
(
    EmployeeID INT PRIMARY KEY,
    Position NVARCHAR(100),
    Salary DECIMAL(10,2),
    HireDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES dbo.EmployeeDetails(EmployeeID)
);
GO


INSERT INTO dbo.EmployeeDetails (EmployeeID, FullName, Email, Department) VALUES
(1, 'Alice Johnson', 'alice.johnson@company.com', 'Engineering'),
(2, 'Bob Smith', 'bob.smith@company.com', 'Marketing'),
(3, 'Charlie Davis', 'charlie.davis@company.com', 'Finance');

GO

INSERT INTO dbo.JobRecords (EmployeeID, Position, Salary, HireDate) VALUES
(1, 'Software Engineer', 85000, '2022-03-15'),
(2, 'Marketing Specialist', 60000, '2021-07-20'),
(3, 'Financial Analyst', 72000, '2020-11-01');

GO

CREATE VIEW dbo.EmployeeJobView AS
SELECT ED.EmployeeID, ED.FullName, ED.Email, ED.Department,
       JR.Position, JR.Salary, JR.HireDate
FROM dbo.EmployeeDetails ED
         JOIN dbo.JobRecords JR ON ED.EmployeeID = JR.EmployeeID;


GO


-- UPDATE Trigger

CREATE TRIGGER trg_UpdateEmployeeJobView
    ON dbo.EmployeeJobView
    INSTEAD OF UPDATE
                   AS
BEGIN
UPDATE ED
SET ED.FullName = I.FullName,
    ED.Email = I.Email,
    ED.Department = I.Department
    FROM dbo.EmployeeDetails ED
    INNER JOIN inserted I ON ED.EmployeeID = I.EmployeeID;

UPDATE JR
SET JR.Position = I.Position,
    JR.Salary = I.Salary,
    JR.HireDate = I.HireDate
    FROM dbo.JobRecords JR
    INNER JOIN inserted I ON JR.EmployeeID = I.EmployeeID;
END;

GO








SELECT * FROM dbo.EmployeeJobView;
GO

UPDATE dbo.EmployeeJobView
SET FullName = 'Alice J. Johnson',
    Position = 'Senior Software Engineer',
    Salary = 95000
WHERE EmployeeID = 1;
GO


SELECT * FROM dbo.EmployeeJobView;