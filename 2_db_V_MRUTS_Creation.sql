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
CREATE TABLE [car]			(car_id INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
							brand VARCHAR(30),
							model VARCHAR(50),
							serial_no VARCHAR(30),
							release_date DATE,
							color VARCHAR(15),
							hp float,
							engine float);

CREATE TABLE [second_car]	(car_id INTEGER NOT NULL,
							brand VARCHAR(30),
							model VARCHAR(50),
							serial_no VARCHAR(30),
							release_date DATE,
							color VARCHAR(15),
							hp float,
							engine float,
							type_of_operation VARCHAR(20),
							date_of_operation DATE);
GO
---------Creating triggers
CREATE TRIGGER car_I ON [car]
AFTER INSERT
AS
INSERT INTO [second_car](car_id, brand, model, serial_no, release_date, color, hp, engine, type_of_operation, date_of_operation)
SELECT car_id, brand, model, serial_no, release_date, color, hp, engine, 'Insert', GETDATE() FROM inserted;
GO

CREATE TRIGGER car_U ON [car]
AFTER UPDATE
AS
INSERT INTO [second_car](car_id, brand, model, serial_no, release_date, color, hp, engine, type_of_operation, date_of_operation)
SELECT car_id, brand, model, serial_no, release_date, color, hp, engine, 'Update(Delete)', GETDATE() FROM deleted;
INSERT INTO [second_car](car_id, brand, model, serial_no, release_date, color, hp, engine, type_of_operation, date_of_operation)
SELECT car_id, brand, model, serial_no, release_date, color, hp, engine, 'Update(Insert)', GETDATE() FROM inserted;
GO

CREATE TRIGGER car_D ON [car]
AFTER DELETE
AS
INSERT INTO [second_car](car_id, brand, model, serial_no, release_date, color, hp, engine, type_of_operation, date_of_operation)
SELECT car_id, brand, model, serial_no, release_date, color, hp, engine, 'Delete', GETDATE() FROM deleted;

---------Inserting/updating/deleting data
INSERT INTO [car](brand, model,serial_no, release_date, color, hp, engine) VALUES
('Kia', 'Carnival', '39F93G', GETDATE(), 'black', 369, 3.2);

UPDATE [car] SET
hp = 963
WHERE car_id = 1;

DELETE FROM [car]
WHERE car_id = 1;

---------Checking if all is working normally. All triggers work normally
SELECT * FROM [car]
SELECT * FROM [second_car]