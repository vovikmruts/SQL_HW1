USE master;

IF EXISTS(
	SELECT * FROM sys.databases
	WHERE name='education'
	)
	DROP DATABASE education;
GO

CREATE DATABASE education;
GO

USE education;
GO

---Creating synonyms for all 4 tables, made in previous tasks
CREATE SYNONYM dbo.edu_user FOR V_MRUTS.dbo.[user]
CREATE SYNONYM dbo.edu_place FOR V_MRUTS.dbo.[place]
CREATE SYNONYM dbo.edu_car FOR V_MRUTS.dbo.[car]
CREATE SYNONYM dbo.edu_s_car FOR V_MRUTS.dbo.[second_car]

SELECT * FROM dbo.edu_user;
SELECT * FROM dbo.edu_place;
SELECT * FROM dbo.edu_car;
SELECT * FROM dbo.edu_s_car;