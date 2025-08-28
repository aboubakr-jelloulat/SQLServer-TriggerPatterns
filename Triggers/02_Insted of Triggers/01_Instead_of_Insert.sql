USE DB_42;


CREATE TABLE dbo.PersonalInfo
(
    DeveloperID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100)
);

GO


CREATE TABLE dbo.DeveloperProfile
(
    DeveloperID INT PRIMARY KEY,
    Skill NVARCHAR(50),
    ExperienceYears INT,
    FOREIGN KEY (DeveloperID) REFERENCES dbo.PersonalInfo(DeveloperID)
);

GO

--  Create the view
CREATE VIEW dbo.DeveloperView AS
SELECT
    P.DeveloperID,
    P.FullName,
    P.Email,
    D.Skill,
    D.ExperienceYears
FROM dbo.PersonalInfo P
         JOIN dbo.DeveloperProfile D ON P.DeveloperID = D.DeveloperID;


GO
-- Create INSTEAD OF INSERT trigger

CREATE TRIGGER trg_InsertDeveloperView
    ON dbo.DeveloperView
    INSTEAD OF INSERT
AS
BEGIN
INSERT INTO dbo.PersonalInfo (FullName, Email)
SELECT FullName, Email
FROM inserted;

INSERT INTO dbo.DeveloperProfile (DeveloperID, Skill, ExperienceYears)
SELECT P.DeveloperID, I.Skill, I.ExperienceYears
FROM inserted I
         JOIN dbo.PersonalInfo P ON P.FullName = I.FullName AND P.Email = I.Email;
END;

GO

--  Insert test data via the view

INSERT INTO dbo.DeveloperView (FullName, Email, Skill, ExperienceYears)
VALUES

('Aboubakr Jelloulat', 'aboubakr@email.com', 'C#', 5),
('Sander Bos', 'sander@email.com', 'C/C++', 3),
('Vini Perira', 'vini@email.com', 'Python', 4);


SELECT * FROM dbo.PersonalInfo;
SELECT * FROM dbo.DeveloperProfile;
SELECT * FROM dbo.DeveloperView;