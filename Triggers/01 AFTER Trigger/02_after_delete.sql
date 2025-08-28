USE DB_42;
GO

-- Drop tables if they already exist

IF OBJECT_ID('dbo.Staff', 'U') IS NOT NULL DROP TABLE dbo.Staff;
IF OBJECT_ID('dbo.StaffDeleteLog', 'U') IS NOT NULL DROP TABLE dbo.StaffDeleteLog;
GO

-- Main table
CREATE TABLE dbo.Staff
(
    StaffID       INT IDENTITY(1,1) PRIMARY KEY,
    FullName      NVARCHAR(100) NOT NULL,
    Position      NVARCHAR(50) NOT NULL,
    Department    NVARCHAR(50) NULL,
    Salary        DECIMAL(10,2) NULL,
    CreatedAtUtc  DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Delete log table
CREATE TABLE dbo.StaffDeleteLog
(
    LogID         INT IDENTITY(1,1) PRIMARY KEY,
    StaffID       INT NOT NULL,
    FullName      NVARCHAR(100) NULL,
    Position      NVARCHAR(50) NULL,
    Department    NVARCHAR(50) NULL,
    Salary        DECIMAL(10,2) NULL,
    DeletedAtUtc  DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    PerformedBy   SYSNAME NULL
);
GO

-- AFTER DELETE trigger
CREATE OR ALTER TRIGGER dbo.trg_Staff_AfterDelete
ON dbo.Staff
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

INSERT INTO dbo.StaffDeleteLog
(
    StaffID,
    FullName,
    Position,
    Department,
    Salary,
    DeletedAtUtc,
    PerformedBy
)
SELECT
    d.StaffID,
    d.FullName,
    d.Position,
    d.Department,
    d.Salary,
    SYSUTCDATETIME(),
    ORIGINAL_LOGIN()
FROM deleted d;
END;
GO


-- Test Inserts


INSERT INTO dbo.Staff (FullName, Position, Department, Salary)
VALUES 
    (N'Aboubakr Jelloulat', N'Manager', N'Operations', 75000),
    (N'Sander Boss', N'Team Lead', N'Sales', 60000),
    (N'Vini Perira', N'Analyst', N'Finance', 55000);

SELECT * FROM dbo.Staff;


-- Test Delete

DELETE FROM dbo.Staff WHERE StaffID = 2; -- delete Sander Boss


SELECT * FROM dbo.StaffDeleteLog ORDER BY LogID;