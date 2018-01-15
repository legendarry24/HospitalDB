USE Hospital
GO

CREATE TABLE Patient
(
	ID INT IDENTITY PRIMARY KEY CLUSTERED,
	Name NVARCHAR(50) NOT NULL,
	Age INT
)

CREATE TABLE Specialization
(
	ID INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL 
)

CREATE TABLE Doctor
(
	ID INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL,
	Age INT NULL,
	SpecializationID INT FOREIGN KEY REFERENCES Specialization(ID)
)

CREATE TABLE PatientDoctor
(
	PatientId INT,
	DoctorId INT,
	PRIMARY KEY (PatientId, DoctorId),
	FOREIGN KEY (PatientId) REFERENCES Patient(ID),
	FOREIGN KEY (DoctorId) REFERENCES Doctor(ID)
)

ALTER TABLE PatientDoctor
ADD Disease NVARCHAR(100)

CREATE TABLE Department
(
	ID INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL,
	Phone CHAR(12) NOT NULL,
	[Floor] TinyInt NOT NULL,
	Head INT NOT NULL FOREIGN KEY REFERENCES Doctor(ID)
	 ON UPDATE CASCADE  
)

ALTER TABLE Department
ADD CONSTRAINT CN_Department_Phone
CHECK (Phone LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')	 
GO

CREATE INDEX IX_DepartmentName
ON Department (Name)
GO

CREATE PROCEDURE [InsertPatient]
	@name nvarchar(100),
	@age int
AS
BEGIN
	INSERT INTO Patient (Name, Age)
	VALUES (@name, @age)

	SELECT SCOPE_IDENTITY()
END
GO

CREATE PROC GetPatients
AS
BEGIN
	SELECT * FROM Patient
END
GO

ALTER PROC GetAgeRange
	@Name nvarchar(100),
	@MinAge int output,
	@MaxAge int out -- the same this output
AS
BEGIN
	SELECT @MinAge = MIN(Age), @MaxAge = MAX(Age) FROM Patient
	WHERE Name LIKE '%' + @Name + '%'
END
GO
