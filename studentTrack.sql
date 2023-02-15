//____ create db ____
CREATE DATABASE EstudentTracker; 

CREATE TABLE dbo.Persona
    (personaID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name varchar(50) NOT NULL,
    lastName varchar(50) NOT NULL,
    edad int NOT NULL);

CREATE TABLE dbo.Estados
    (estadosID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Name varchar(50) NOT NULL
   );

CREATE TABLE dbo.Ciudades(
    ciudadID INT IDENTITY(1,1) PRIMARY KEY, 
    Name VARCHAR(50) NOT NULL,
    FKEstado INT NOT NULL REFERENCES Estados(estadosID)
);

CREATE TABLE dbo.Direcciones(
    direccionID INT IDENTITY(1,1) PRIMARY KEY, 
    Name VARCHAR(MAX) NOT NULL,
    FKCiudad INT NOT NULL REFERENCES Ciudades(ciudadID)
);

CREATE TABLE dbo.Padres(
    padreID INT IDENTITY(1,1) PRIMARY KEY, 
    contacto VARCHAR(10) NOT NULL,
    trabajo VARCHAR(50) NOT NULL,
    FKPersona INT NOT NULL REFERENCES Persona(personaID),
    FKDireccion INT NOT NULL REFERENCES Direcciones(direccionID)
);


CREATE TABLE dbo.Estudiantes(
    estudianteID INT IDENTITY(1,1) PRIMARY KEY, 
    grado VARCHAR(10) NOT NULL,
    FKEstudiane INT NOT NULL REFERENCES Persona(personaID),
    FKPadre INT NULL REFERENCES Padres(padreID),
    FKMadre INT NULL REFERENCES Padres(padreID),
    FKHermano1 INT NULL REFERENCES Persona(personaID),
    FKHermano2 INT NULL REFERENCES Persona(personaID),
    FKProfersor INT NULL REFERENCES Persona(personaID)
);


CREATE TABLE dbo.Tardias(
    tardiaID INT IDENTITY(1,1) PRIMARY KEY, 
    fecha DATE NOT NULL,
    FKEstudiane INT NOT NULL REFERENCES Estudiantes(estudianteID)
);

CREATE TABLE dbo.Tardias(
    tardiaID INT IDENTITY(1,1) PRIMARY KEY, 
    fecha DATE NOT NULL,
    FKEstudiane INT NOT NULL REFERENCES Estudiantes(estudianteID)
);




//—————Insert Data———————————
INSERT INTO Estados (Name)
VALUES ('Cartago')
,('Alajuela')
,('San Jose')
,('Heredia')
,('Limon')
,('Guanacaste')
,('Puntarenas')
;

INSERT INTO Ciudades (Name, FKEstado)
VALUES ('Turrialba', 1)
,('VArgas Araya', 2)
,('Curridabat', 3)
,('Flores', 4)
,('Manzanillo', 5)
,('Liberia', 6)
,('San pedro', 7)
,('sabana', 1)
,('puerto viejo', 3)
;


INSERT INTO Direcciones (Name, FKCiudad)
VALUES ('La margoth', 1)
,('cedros', 2)
,('atillos', 3)
,('estadios', 4)
,('playa', 5)
,('macdonals', 6)
,('mall', 7)
,('plaza', 8)
,('resaturante', 9)
;


INSERT INTO Persona (Name, lastName, edad)
VALUES ('Juan', 'Guevara', 18)
,('Manuel', 'Guevara', 40)
,('Yor', 'Guevara', 40)
,('Daniel', 'Guevara', 18)
,('Val', 'Guevara', 18)
,('Rodrigo', 'Nunez', 40)
,(‘Franco', 'Quiros', 18)
,('Estela', 'Quiros', 40)
,('Mari', 'Quesada', 18)
,('Estaban', 'Quiros', 18)
,('Camila', 'QUesada', 18)
,('Kenneth', 'Nunez', 40)
;




INSERT INTO Padres (contacto, trabajo, FKPersona, FKDireccion)
VALUES ('12345', 'Vendedor', 2, 1)
,(‘12345', 'Vendedor', 3, 2)
,('12345', 'Maestro', 6, 2)
,(‘12345', 'Vendedor', 8, 3)
,('12345', 'Vendedor', 9, 2)
,('12345', 'Maestro', 12, 4)
;



INSERT INTO Estudiantes (grado, FKEstudiane, FKPadre, FKHermano1, FKProfersor)
VALUES ('1', 1, 1, 5, 12)
,('2', 4, 2, 13, 12)
,('3', 7, 3, 14, 12)
,('4', 11, 4, 15, 12)
,('6', 10, 5, 16, 12)
;


INSERT INTO Tardias (fecha, FKEstudiane)
VALUES ('2022-06-11', 1)
,('2022-06-11', 2)
,('2022-06-11', 3)
,('2022-06-12', 4)
,('2022-06-12', 5)
,('2022-06-13', 1)
,('2022-06-14', 5)
,('2022-06-14', 2)
,('2022-06-14', 1)
,('2022-06-15', 4)
,('2022-07-14', 2)
,('2022-07-14', 4)
,('2022-07-14', 5)
,('2022-07-18', 1)
,('2022-07-18', 3)
,('2022-07-18', 4)
,('2022-07-20', 1)
,('2022-07-21', 1)
,('2022-07-26', 3)
,('2022-08-10', 4)
,('2022-08-11', 2)
,('2022-08-15', 1)
,('2022-08-16', 1)
,('2022-08-16', 3)
,('2022-08-17', 1)
,('2022-08-18', 5)
,('2022-08-19', 2)
;




//———————sp——————————


//——3——
USE EstudentTrackerTest;  
GO  
CREATE PROCEDURE getParentInfo  
    @FirstNameEstudent varchar(50),   
    @LastNameEstudent varchar(50)  
AS   
     SET NOCOUNT ON;  
    SELECT Padre.Name AS Nombre, Padre.lastName AS Apellido, Padre.edad AS Edad, infoPadre.contacto AS Contacto, infoPadre.trabajo AS Trabajo, Direccion.Name AS Direccion, Ciudad.Name AS Ciudad, Estado.Name AS Estado
    FROM Estudiantes E
    INNER JOIN Persona Estudiante ON E.FKEstudiane = Estudiante.personaID
    INNER JOIN Persona Padre ON E.FKPadre = Padre.personaID
    INNER JOIN Padres infoPadre ON infoPadre.FKPersona = Padre.personaID
    INNER JOIN Direcciones Direccion ON infoPadre.FKDireccion = Direccion.direccionID
    INNER JOIN Ciudades Ciudad ON Direccion.FKCiudad = Ciudad.ciudadID
    INNER JOIN Estados Estado ON Ciudad.FKEstado = Estado.estadosID
    WHERE Estudiante.Name = @FirstNameEstudent AND Estudiante.lastName = @LastNameEstudent 

GO 


//----run 
DECLARE @RC int
DECLARE @FirstNameEstudent varchar(50)
DECLARE @LastNameEstudent varchar(50)



EXECUTE @RC = [dbo].[getParentInfo] 
   @FirstNameEstudent = 'Juan'
  ,@LastNameEstudent = "Guevara"
GO


//------4-------
USE EstudentTrackerTest;  
GO  
CREATE PROCEDURE city 
AS   
     SET NOCOUNT ON;  
    SELECT TOP(1)
    Count(Ciudades.ciudadID) AS TOTAL,
    Ciudades.Name FROM
    Tardias
    INNER JOIN Estudiantes ON Tardias.FKEstudiane = Estudiantes.estudianteID
    INNER JOIN Persona Padre ON Estudiantes.FKPadre = Padre.personaID
    INNER JOIN Padres P ON P.FKPersona = Padre.personaID
    INNER JOIN Direcciones ON Direcciones.direccionID = P.FKDireccion
    INNER JOIN Ciudades ON Ciudades.ciudadID = Direcciones.FKCiudad 
    WHERE
     Tardias.fecha >= DATEADD(week, DATEDIFF(week,0,GETDATE())-1,-1)
    AND Tardias.fecha < DATEADD(week, DATEDIFF(week,0,GETDATE()),-1)
    GROUP BY Ciudades.Name, Ciudades.ciudadID
    ORDER BY TOTAL DESC;

GO 

//----run 
DECLARE @RC int
EXECUTE @RC = [dbo].[city] 
GO






