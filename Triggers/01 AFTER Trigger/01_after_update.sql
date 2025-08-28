USE DB_42;

GO

-- Drop tables if they exist
IF OBJECT_ID('dbo.PupilsAudit', 'U') IS NOT NULL DROP TABLE dbo.PupilsAudit;
IF OBJECT_ID('dbo.Pupils', 'U') IS NOT NULL DROP TABLE dbo.Pupils;
GO

-- Main table
CREATE TABLE dbo.Pupils
(
    PupilID        INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(100) NOT NULL,
    Subject        NVARCHAR(100) NOT NULL,
    Grade          DECIMAL(5,2) NULL,
    CreatedAtUtc   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Audit table
CREATE TABLE dbo.PupilsAudit
(
    AuditID           INT IDENTITY(1,1) PRIMARY KEY,
    PupilID           INT NOT NULL,
    Action            NVARCHAR(10) NOT NULL,
    Snapshot_FullName NVARCHAR(100) NULL,
    Snapshot_Subject  NVARCHAR(100) NULL,
    Snapshot_OldGrade DECIMAL(5,2) NULL,
    Snapshot_NewGrade DECIMAL(5,2) NULL,
    AtUtc             DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    PerformedBy       SYSNAME NULL,
    CONSTRAINT FK_PupilsAudit_Pupils FOREIGN KEY (PupilID) REFERENCES dbo.Pupils(PupilID)
);
GO

-- AFTER UPDATE Trigger
CREATE OR ALTER TRIGGER dbo.trg_Pupils_AfterUpdate
ON dbo.Pupils
AFTER UPDATE
                          AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Grade) -- Checks if the 'Grade' column was part of the update
BEGIN
INSERT INTO dbo.PupilsAudit
(
    PupilID,
    Action,
    Snapshot_FullName,
    Snapshot_Subject,
    Snapshot_OldGrade,
    Snapshot_NewGrade,
    PerformedBy
)
SELECT
    i.PupilID,
    N'UPDATE',
    i.FullName,
    i.Subject,
    d.Grade AS [Snapshot OldGrade],
            i.Grade AS [Snapshot NewGrade],
            ORIGINAL_LOGIN()
FROM inserted i
    INNER JOIN deleted d ON i.PupilID = d.PupilID;
END
END;
GO


-- Test Inserts

INSERT INTO dbo.Pupils (FullName, Subject, Grade)
VALUES 
    (N'Aboubakr Jelloulat', N'IT', 95),
    (N'Sander Boss', N'IT', 88),
    (N'Vini Perira', N'Math', 92);

SELECT * FROM dbo.Pupils;


-- Test Update

UPDATE dbo.Pupils
SET Grade = 97
WHERE FullName = N'Aboubakr Jelloulat';

UPDATE dbo.Pupils
SET Grade = 90
WHERE FullName = N'Sander Boss';



SELECT * FROM dbo.PupilsAudit ORDER BY AuditID;