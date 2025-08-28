use DB_42;


-- Find any foreign keys referencing Drivers
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id))
    + ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('dbo.Drivers');

-- Execute the drop statements if any exist
IF (@sql <> '') EXEC sp_executesql @sql;

-- Now safely drop the Drivers table
IF OBJECT_ID('dbo.Drivers','U') IS NOT NULL DROP TABLE dbo.Drivers;



-- 2. Recreate Drivers table

CREATE TABLE dbo.Drivers
(
    DriverID       INT IDENTITY(1,1) PRIMARY KEY,
    FullName       NVARCHAR(100) NOT NULL,
    LicenseNumber  NVARCHAR(50)  NOT NULL,
    City           NVARCHAR(100) NOT NULL,
    IsActive       BIT NOT NULL DEFAULT 1
);
GO



INSERT INTO dbo.Drivers (FullName, LicenseNumber, City) VALUES
(N'Aboubakr Jelloulat', 'ABC123', 'Casablanca'),
(N'Sander Boss',        'XYZ789', 'Amsterdam'),
(N'Maria Lopez',        'LMN456', 'Sao Peolo');
GO



-- 3. Recreate trigger

CREATE OR ALTER TRIGGER dbo.trg_Drivers_InsteadOfDelete
ON dbo.Drivers
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Error: Direct delete is not allowed. Driver marked as inactive instead.';

UPDATE d
SET IsActive = 0
    FROM dbo.Drivers d
    INNER JOIN deleted x ON d.DriverID = x.DriverID;
END;
GO



SELECT * FROM dbo.Drivers;
GO




DELETE FROM dbo.Drivers WHERE DriverID = 2;
GO


SELECT * FROM dbo.Drivers;
GO