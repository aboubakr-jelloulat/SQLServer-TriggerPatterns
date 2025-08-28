use DB_42;


   -- Comment these DROPs out if you already

IF OBJECT_ID('dbo.DriverAudit', 'U') IS NOT NULL DROP TABLE dbo.DriverAudit;
IF OBJECT_ID('dbo.Drivers',    'U') IS NOT NULL DROP TABLE dbo.Drivers;
GO


   -- STEP 1) Create the main table: Drivers

CREATE TABLE dbo.Drivers
(
    DriverID        INT IDENTITY(1,1) PRIMARY KEY,
    FullName        NVARCHAR(100)   NOT NULL,
    LicenseNumber   NVARCHAR(30)    NOT NULL UNIQUE, -- one license per driver
    LicenseClass    NVARCHAR(10)    NULL,            --  B, C, D...
    City            NVARCHAR(50)    NULL,
    CreatedAtUtc    DATETIME2(0)    NOT NULL 
        CONSTRAINT DF_Drivers_CreatedAtUtc DEFAULT SYSUTCDATETIME()
);

GO


   --STEP 2) Create an audit table: DriverAudit


CREATE TABLE dbo.DriverAudit
(
    AuditID                 INT IDENTITY(1,1) PRIMARY KEY,
    DriverID                INT           NOT NULL,          
    Action                  NVARCHAR(10)  NOT NULL, 
    Snapshot_FullName       NVARCHAR(100) NULL,       
    Snapshot_LicenseNumber  NVARCHAR(30)  NULL,
    Snapshot_City           NVARCHAR(50)  NULL,
    AtUtc                   DATETIME2(0)  NOT NULL 
        CONSTRAINT DF_DriverAudit_AtUtc DEFAULT SYSUTCDATETIME(),
    PerformedBy             SYSNAME       NULL,              -- who did it (login)
    CONSTRAINT FK_DriverAudit_Drivers
        FOREIGN KEY (DriverID) REFERENCES dbo.Drivers(DriverID)
);
GO


   -- STEP 3) Create the AFTER INSERT trigger


CREATE OR ALTER TRIGGER dbo.trg_Drivers_AfterInsert
ON dbo.Drivers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON; -- just tells SQL: Don’t bother printing how many rows were affected by this trigger

    INSERT INTO dbo.DriverAudit
    (
        DriverID, Action, Snapshot_FullName, Snapshot_LicenseNumber,
        Snapshot_City, PerformedBy
    )
    SELECT
        i.DriverID,
        N'INSERT',
        i.FullName,
        i.LicenseNumber,
        i.City,
        ORIGINAL_LOGIN()  -- who initiated the session
    FROM inserted AS i;   -- all newly inserted rows live here
END;

GO

   --STEP 4) Test: insert ONE row


INSERT INTO dbo.Drivers (FullName, LicenseNumber, LicenseClass, City)
VALUES (N'Ali Ben', N'MA-123-456', N'B', N'Casablanca');

-- See results
SELECT * FROM dbo.Drivers;
SELECT * FROM dbo.DriverAudit;



  -- STEP 5) Test: insert MULTIPLE rows at once
 


INSERT INTO dbo.Drivers (FullName, LicenseNumber, LicenseClass, City)
VALUES (N'Fatima Zahra', N'MA-222-333', N'C', N'Rabat'),
       (N'Youssef El',  N'MA-444-555', N'B', N'Marrakesh');



SELECT * FROM dbo.Drivers ORDER BY DriverID;
SELECT * FROM dbo.DriverAudit ORDER BY AuditID;