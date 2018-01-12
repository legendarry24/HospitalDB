USE Hospital
GO

INSERT INTO Patient (Name, Age)
VALUES ('Sasha', 10), ('Kolya', 15), ('Test', 7), ('Alex', 23)

INSERT Patient
VALUES ('Daniel', 18)

INSERT INTO [Specialization]
VALUES ('Surgeon'), ('Pediatrician'), ('Dentist')

INSERT INTO Doctor (Name, Age, [SpecializationID])
VALUES ('Ivan', 32, 1), ('Vlad', NULL, 2), ('Dima', 26, 3), ('Jack', 24, NULL)

INSERT [dbo].[PatientDoctor]
VALUES (1, 1, 'Appendicitis'), (2, 2, 'Measles'), 
(3, 4, 'Angina'), (4, 3, 'Caries'), (1, 3, 'Pulpitis')

INSERT [dbo].[Department]
VALUES 
('Surgery department', '(063)1234567', 1, 1),
('Dental department', '(050)7654321', 2, 3),
('Pediatric department', '(067)1239967', 3, 2)
GO

SELECT * FROM Patient
SELECT * FROM [Specialization]
SELECT * FROM [PatientDoctor]
SELECT * FROM Doctor
SELECT * FROM [Department]

SELECT d.Name Department, d.Phone, d.Floor, doc.Name Head, s.Name Specialization 
FROM Department d
JOIN Doctor doc ON d.Head = doc.ID
JOIN Specialization s ON doc.SpecializationID = s.ID

--1) Patients whose name starts with "Sa" 
SELECT * FROM Patient
WHERE Name LIKE 'Sa%'

--2) Patients with names Sasha, Kolya, Test
SELECT * FROM Patient
WHERE Name IN ('Sasha', 'Kolya', 'Test')

--3) Patients which don't have any doctor 
SELECT p.Name, p.Age, pd.[PatientId] FROM Patient p
LEFT JOIN [PatientDoctor] pd ON p.ID = pd.[PatientId]
WHERE pd.[PatientId] IS NULL

--4) Patients which have 1 doctor assigned
SELECT p.Name, COUNT(pd.[DoctorId]) 'Amount of doctors assigned' FROM Patient p
JOIN [PatientDoctor] pd ON p.ID = pd.[PatientId]
GROUP BY p.Name
HAVING COUNT(pd.[DoctorId]) = 1

--5) Patients which have max amount of doctors assigned
SELECT MAX([Amount of doctors].Amount) 'Amount of doctors assigned'
FROM (SELECT COUNT(pd.[DoctorId]) Amount FROM Patient p
	  JOIN [PatientDoctor] pd ON p.ID = pd.[PatientId]
	  GROUP BY p.Name) AS [Amount of doctors]

SELECT p.Name 'Patient name', COUNT(pd.[DoctorId]) 'Amount of doctors assigned' FROM Patient p
JOIN [PatientDoctor] pd ON p.ID = pd.[PatientId]
GROUP BY p.Name
HAVING COUNT(pd.[DoctorId]) = (SELECT MAX([Amount of doctors].Amount)
							   FROM (SELECT COUNT(pd.[DoctorId]) Amount FROM Patient p
									 JOIN [PatientDoctor] pd ON p.ID = pd.[PatientId]
									 GROUP BY p.Name) AS [Amount of doctors])

/*
6) for each doctor a list of patients who were under his supervision
7) get patients treated in a certain department 
8) get all the diseases that treat a doctor from a certain department
9) the most in-demand department
*/

-- 6)
SELECT d.Name Doctor, p.Name Patient FROM Doctor d
JOIN PatientDoctor pd ON d.ID = pd.DoctorId
JOIN Patient p ON p.ID = pd.PatientId
ORDER BY 1
GO

-- 7)
SELECT p.Name Patient, d.Name Department FROM Doctor doc
JOIN Department d ON d.Head = doc.ID
JOIN PatientDoctor pd ON doc.ID = pd.DoctorId
JOIN Patient p ON p.ID = pd.PatientId
WHERE d.Name = 'Pediatric department' 
GO

-- 8)
SELECT pd.Disease, doc.Name Doctor, s.Name Specialization, d.Name Department 
FROM Department d
JOIN Doctor doc ON d.Head = doc.ID
JOIN Specialization s ON doc.SpecializationID = s.ID
JOIN PatientDoctor pd ON doc.ID = pd.DoctorId
WHERE d.Name = 'Dental department'
GO

-- 9)
SELECT d.Name Department, COUNT(*) Patients
FROM Department d
JOIN Doctor doc ON d.Head = doc.ID
JOIN PatientDoctor pd ON doc.ID = pd.DoctorId
GROUP BY d.Name
HAVING COUNT(*) = (SELECT MAX(Amount) 
				   FROM (SELECT COUNT(*) Amount
				  		 FROM Department d
				  		 JOIN Doctor doc ON d.Head = doc.ID
				  		 JOIN PatientDoctor pd ON doc.ID = pd.DoctorId
				  		 GROUP BY d.Name) AS Result)