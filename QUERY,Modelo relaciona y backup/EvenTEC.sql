CREATE RULE R_Evento AS
    (@idEvento like ('EV-[0-9][0-9][0-9][0-9]'));
GO
EXEC sp_addtype 'T_Evento', 'varchar (7)', 'not null';
GO
EXEC sp_bindrule 'R_Evento','T_Evento'
GO

CREATE RULE R_IdActividad AS
    (@idActividad like ('Act-[0-9][0-9][0-9][0-9]'));
GO
EXEC sp_addtype 'T_Actividad', 'varchar (8)', 'not null';
GO
EXEC sp_bindrule 'R_IdActividad','T_Actividad'
GO

CREATE RULE R_Telefono AS
    (@telefono like ('[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'))
    or
    (@telefono like ('([0-9][0-9][0-9])[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'));
GO
EXEC sp_addtype 'T_Telefono', 'varchar (14)', 'not null';
GO
EXEC sp_bindrule 'R_Telefono','T_Telefono'
GO

create table Persona
(
		cedula			varchar(50)			NOT NULL,
		nombre			varchar(20)			NOT NULL,
		apellido1		varchar(20)			NOT NULL,
		apellido2		varchar(20)			NOT NULL,
		edad			int			NOT NULL,
		direccion		varchar(20)			NOT NULL,
		estado          	varchar(1)          NOT NULL, 
		CONSTRAINT		pk_cedula_Persona	primary key (cedula),
);

create table Evento 
(
		idEvento		T_Evento			NOT NULL,
		nombre			varchar(50)			NOT NULL,
		descripcion		varchar(200)		NOT NULL,
		fechaInicio		date				NOT NULL,
		fechaFinal		date				NOT NULL,

		CONSTRAINT		pk_idEvento_Evento	primary key (idEvento)
);

create table Actividad
(
		idActividad		T_Actividad					NOT NULL,
		nombre			varchar(50)					NOT NULL,
		descripcion		varchar(200)				NOT NULL,
		fecha			date						NOT NULL,
		cupo			int					NOT NULL,
		lugar			varchar(200)				NOT NULL,
		horaInicio		time						NOT NULL,
		horaFinal		time						NOT NULL,
		duracion		time						NOT NULL,

		CONSTRAINT		pk_idActividad_Actividad	primary key (idActividad)
);

create table Telefono
(
		idTelefono		smallint					identity(1,1)				NOT NULL,
		cedula			varchar(50)												NOT NULL,
		telefono		T_Telefono,

		CONSTRAINT		pk_idTelefono_telefono		primary key (idTelefono),
		CONSTRAINT		fk_cedula_Telefono			foreign key (cedula) references persona	
);

create table Usuarios 
(
		cedula			varchar(50)			NOT NULL,
		contraseña		varchar(50)			NOT NULL,
		tipoCuenta		char(1)				NOT NULL,

		CONSTRAINT		pk_cedula_Usuarios	primary key (cedula),
		CONSTRAINT		fk_cedula_Usuarios	foreign key (cedula) references persona	
	
);

create table Administradores_Eventos 
(
		cedula			varchar(50)									NOT NULL,
		idEvento		T_Evento									NOT NULL,

		CONSTRAINT		pk_cedula_IdEvento_Administradores_Eventos 	primary key (idEvento,cedula),
		CONSTRAINT		fk_cedula_Administradores_Eventos			foreign key (cedula) references persona,
		CONSTRAINT		fk_idEvento_Administradores_Eventos			foreign key (idEvento) references Evento	

);

create table Edecan_Actividades 
(
		cedula			varchar(50)		NOT NULL,
		idActividad		T_Actividad		NOT NULL,

		CONSTRAINT		pk_cedula_IdActividad_Edecan_Actividades 	primary key (idActividad,cedula),
		CONSTRAINT		fk_cedula_Edecan_Actividades				foreign key (cedula) references persona,
		CONSTRAINT		fk_idActividad_Edecan_Actividades			foreign key (idActividad) references actividad	
);
create table Edecan_Eventos 
(
		cedula			varchar(50)		NOT NULL,
		idEvento		T_Evento		NOT NULL,

		CONSTRAINT		pk_cedula_IdEvento_Edecan_Actividades 	primary key (idEvento,cedula),
		CONSTRAINT		fk_cedula_Edecan_Eventos				foreign key (cedula) references persona,
		CONSTRAINT		fk_idEvento_Edecan_Eventos			foreign key (idEvento) references Evento
);
create table Matricula 
(
		cedula			varchar(50)		NOT NULL,
		idActividad		T_Actividad		NOT NULL,

		CONSTRAINT		pk_cedula_IActividad_Matricula 	primary key (idActividad,cedula),
		CONSTRAINT		fk_cedula_Matricula				foreign key (cedula)		references persona,
		CONSTRAINT		fk_idActividad_Matricula		foreign key (idActividad)	references actividad	
);

create table Eventos_Actividades 
(
		idEvento		T_Evento		NOT NULL,
		idActividad		T_Actividad		NOT NULL,

		CONSTRAINT		pk_IdEvento_IdActividad_Eventos_Actividades 	primary key (idActividad,idEvento),
		CONSTRAINT		fk_idEvento_Eventos_Actividades					foreign key (idEvento)		references evento,	
		CONSTRAINT		fk_idActividad_Eventos_Actividades				foreign key (idActividad)	references actividad	
);

create table regEntrada
(
		idActividad		T_Actividad		NOT NULL,
		cedula			varchar(9)		NOT NULL,
		fecha			date			default(GETDATE()),
		hora			datetime		default(SYSDATETIME()),
		CONSTRAINT              fk_cedula_HoraE_fecha          primary key (cedula,hora,fecha),
		CONSTRAINT		fk_idActividad_regEntrada foreign key (idActividad) references actividad	

);

create table regSalida
(
		idActividad		T_Actividad		NOT NULL,
		cedula			varchar(9)		NOT NULL,
		fecha			date			default(GETDATE()),
		hora			datetime		default(SYSDATETIME()),
		CONSTRAINT              fk_cedula_HoraS_fecha          primary key (cedula,hora,fecha),
		CONSTRAINT		fk_idActividad_regSalida foreign key (idActividad) references actividad			
);



///////////////////Funciones

CREATE PROCEDURE EliminarEvento
@id_evento T_evento
AS
BEGIN
SET NOCOUNT ON;
		DELETE from Eventos_Actividades where idEvento=@id_evento;
		DELETE from Edecan_Eventos where idEvento=@id_evento;
        DELETE from Evento where idEvento =@id_evento;
END;



CREATE PROCEDURE EliminarEdecan
@cedula varchar(50) 
AS
BEGIN
SET NOCOUNT ON;
		DELETE from Edecan_Actividades where cedula=@cedula;
		DELETE from Usuarios where cedula=@cedula and tipoCuenta='e';
		DELETE from Persona where cedula=@cedula;
END;




CREATE PROCEDURE EliminarActdevento
@id_evento T_evento,
@id_actividad T_Actividad
AS
BEGIN
SET NOCOUNT ON;
		DELETE from Eventos_Actividades where idEvento=@id_evento and idActividad=@id_actividad;
        DELETE from Actividad where idActividad =@id_actividad;
END;


CREATE PROCEDURE EliminarPersona
@id_persona VARCHAR(50),
@id_actividad T_Actividad
AS
BEGIN
SET NOCOUNT ON;
		DELETE FROM Persona_Actividades WHERE cedula=@id_persona and idActividad=@id_actividad;
END;



CREATE PROCEDURE AddActivitys
    @nombre AS VARCHAR(50),
    @descripcion AS VARCHAR(30),
    @fecha AS VARCHAR(20),
    @cupo AS INT,
    @lugar AS VARCHAR(100) ,
	@horaInicio AS VARCHAR(50),
	@horaFinal AS VARCHAR(50),
	@duracion AS VARCHAR(50),
	@idEvento AS VARCHAR(50)
AS
BEGIN
	
    Begin Try
		
		DECLARE @Random NVARCHAR(10);--To store 4 digit random number
		DECLARE @Final NVARCHAR(MAX)--Final unique random number
		DECLARE @Upper INT;
		DECLARE @Lower INT
		---- This will create a random number between 1 and 9999
		DECLARE @temp NVARCHAR(MAX);
		DECLARE @bandera bit;
		SET @bandera = 0;
			WHILE @bandera =0
			BEGIN
			   	SET @Lower = 1 ---- The lowest random number
				SET @Upper = 9999 ---- The highest random number
				SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
				IF @Random<1000 and @Random>100 
					SET @Final = 'Act-' +'0'+ @Random;
				IF @Random<100 and @Random>10
					SET @Final = 'Act-' +'00'+ @Random;
				IF @Random<10
					SET @Final = 'Act-' +'000'+ @Random;
				IF @Random>=1000
					SET @Final = 'Act-'+ @Random;

				SELECT @temp=(SELECT idActividad from Actividad where Actividad.idActividad=@Final);
				IF @temp IS NULL
					SET @bandera=1;
				END;

				PRINT @Final;
				PRINT @bandera;
			
			DECLARE @fechat DATE;
			SET @fechat=@fecha;
			DECLARE @temp1 VARCHAR(50);
			SET @temp1=(SELECT idEvento FROM  Evento WHERE  fechaInicio<@fecha AND fechaFinal>@fecha AND idEvento=@idEvento); 
			PRINT @temp1;
			IF @temp1=@idEvento
				INSERT INTO Actividad (idActividad,nombre,descripcion,fecha,cupo,lugar,horaInicio,horaFinal,duracion) VALUES (@Final,@nombre,@descripcion,@fecha,@cupo,@lugar,@horaInicio,@horaFinal,@duracion);
				INSERT INTO Eventos_Actividades(idEvento,idActividad) VALUES (@idEvento,@Final); 
    End try
    Begin Catch
    End Catch
END
GO


SELECT * FROM Evento
EXEC AddActivitys 'no mames','se genero','2017-12-6','12','ugug','8:8:8','8:8:8','0:0:0','Ev-1675'
SELECT * FROM Actividad



CREATE PROCEDURE AddEvents
	@cedula varchar(50), 
    @nombre AS VARCHAR(50),
    @descripcion AS VARCHAR(30),
	@fechaInicio AS VARCHAR(50),
	@fechaFinal AS VARCHAR(50)
AS
BEGIN
	
    Begin Try
		
		DECLARE @Random NVARCHAR(10);--To store 4 digit random number
		DECLARE @Final NVARCHAR(MAX)--Final unique random number
		DECLARE @Upper INT;
		DECLARE @Lower INT
		---- This will create a random number between 1 and 9999
		DECLARE @temp NVARCHAR(MAX);
		DECLARE @bandera bit;
		SET @bandera = 0;
			WHILE @bandera =0
			BEGIN
			   	SET @Lower = 1 ---- The lowest random number
				SET @Upper = 9999 ---- The highest random number
				SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
				IF @Random<1000 and @Random>100 
					SET @Final = 'Ev-' +'0'+ @Random;
				IF @Random<100 and @Random>10
					SET @Final = 'Ev-' +'00'+ @Random;
				IF @Random<10
					SET @Final = 'Ev-' +'000'+ @Random;
				IF @Random>=1000
					SET @Final = 'Ev-'+ @Random;

				SELECT @temp=(SELECT idEvento from Evento where Evento.idEvento=@Final);
				IF @temp IS NULL
					SET @bandera=1;
				END;
				PRINT @Final;
				PRINT @bandera;
			INSERT INTO Evento(idEvento,nombre,descripcion,fechaInicio,fechaFinal) VALUES (@Final,@nombre,@descripcion,@fechaInicio,@fechaFinal)
			INSERT INTO Administradores_Eventos(cedula,idEvento)VALUES(@cedula,@Final)
    End try
    Begin Catch
    End Catch
END
GO



EXEC AddEvents '203210321','reunionleli','eventecnomames','2017-12-12','2017-12-12'


CREATE PROCEDURE [dbo].[AddAdmiEvent]
@cedula VARCHAR(50),
@id_evento T_evento
AS
BEGIN
SET NOCOUNT ON;
		INSERT INTO Administradores_Eventos(cedula,idEvento)VALUES(@cedula,@id_evento);
END;


CREATE PROCEDURE TodosEventos
AS
BEGIN
	DECLARE @fecha DATE=(SELECT SYSDATETIME());
	---SELECT @fecha
	SELECT * FROM Evento
	WHERE CAST(Evento.fechaInicio AS DATETIME) BETWEEN @fecha AND CAST(Evento.fechaFinal AS DATETIME)
END;


EXEC TodosEventos


SELECT * FROM Evento


SELECT * FROM Actividad
SELECT * FROM Usuarios
