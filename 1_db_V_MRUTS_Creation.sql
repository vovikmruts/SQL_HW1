USE master;

IF EXISTS(
	SELECT * FROM sys.databases
	WHERE name='V_MRUTS'
	)
	DROP DATABASE V_MRUTS;
GO

CREATE DATABASE V_MRUTS;
GO

USE V_MRUTS;
GO

------------Creating tables

CREATE TABLE [place]		(place_id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
							country VARCHAR(30),
							region VARCHAR(50),
							city VARCHAR(30),
							street VARCHAR(35),
							build_no VARCHAR(5),
							corpus VARCHAR(1),
							room_no VARCHAR(5),
							inserted_date DATE NOT NULL DEFAULT GETDATE(),
							updated_date DATE);

CREATE TABLE [user]			(user_id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
							fname VARCHAR(30),
							lname VARCHAR(30),
							place_ID INTEGER,
							phone varchar(15) UNIQUE,
							email VARCHAR(50),
							reg_date DATE NOT NULL DEFAULT GETDATE(),
							birth_date DATE,
							inserted_date DATE NOT NULL DEFAULT GETDATE(),
							updated_date DATE,
							CONSTRAINT FK_User_To_Place FOREIGN KEY (place_ID)  REFERENCES [place](place_id),
							CONSTRAINT check_email CHECK (email LIKE '%@%')
							);

------------Inserting data in tables
INSERT INTO [place](country, region, city, street, build_no, corpus, room_no) VALUES
('Ukraine', 'lviv oblast`', 'Lviv', 'Naukova', '234', 'C', '369' );

INSERT INTO [user](fname, lname, place_ID, phone, email, birth_date) VALUES
('Volodymyr', 'Mruts', 1, '0672717999', 'volodymyr.mruts@gmail.com', '2001-06-07');--all ok. Insert doesn`t violates any constraint
INSERT INTO [user](fname, lname, place_ID, phone, email, birth_date) VALUES
('Bad', 'Insert', 1, '0672719539', 'no email symbol gmail.com', '2001-06-07');-- Check constraint fails transaction beacause of missing @ symbol. Check constraint works normally
GO
---------Creating update trigger
CREATE TRIGGER user_U ON [user]
AFTER UPDATE
AS
update [user]
set updated_date = GETDATE();
GO
---------Cheching if trigger is working 
UPDATE [user] 
SET phone = '0672717936'
WHERE user_id = 1

SELECT * FROM [user]
GO
---------Creating views for each table
CREATE VIEW user_temp
AS
SELECT * FROM [user]
GO

CREATE VIEW place_temp
AS
SELECT * FROM [place]
GO
---------View with check option
CREATE VIEW user_check
AS
SELECT * FROM [user]
WHERE place_ID = 1
WITH CHECK OPTION
GO
---------Checking if check option is working
INSERT INTO user_check(fname, lname, place_ID, phone, email, birth_date) VALUES
('Volodymyr', 'Mruts', 13, '0672717999', 'volodymyr.mruts@gmail.com', '2001-06-07');
GO --working because insert with place_ID = 13 failed (check option says that ID must be 1)
---------
