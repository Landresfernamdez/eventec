CREATE RULE r_evento AS (@idEvento LIKE ('EV-[0-9][0-9][0-9][0-9]')); 

go 

EXEC Sp_addtype 
  'T_Evento', 
  'varchar (7)', 
  'not null'; 

go 

EXEC Sp_bindrule 
  'R_Evento', 
  'T_Evento' 

go 

CREATE RULE r_idactividad AS (@idActividad LIKE ('Act-[0-9][0-9][0-9][0-9]')); 

go 

EXEC Sp_addtype 
  'T_Actividad', 
  'varchar (8)', 
  'not null'; 

go 

EXEC Sp_bindrule 
  'R_IdActividad', 
  'T_Actividad' 

go 

CREATE RULE r_telefono AS (@telefono LIKE ( 
'[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')) OR (@telefono LIKE ( 
'([0-9][0-9][0-9])[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')); 

go 

EXEC Sp_addtype 
  'T_Telefono', 
  'varchar (14)', 
  'not null'; 

go 

EXEC Sp_bindrule 
  'R_Telefono', 
  'T_Telefono' 

go 





CREATE TABLE Persona 
  ( 
     cedula      VARCHAR(50) NOT NULL, 
     nombre      VARCHAR(20) NOT NULL, 
     apellido1   VARCHAR(20) NOT NULL, 
     apellido2   VARCHAR(20) NOT NULL, 
     edad        INT NOT NULL, 
     direccion   VARCHAR(20) NOT NULL, 
     estado      VARCHAR(1) NOT NULL, 
     contraseña VARCHAR(50) NOT NULL,
	 correo VARCHAR(50) NOT NULL, 
     CONSTRAINT pk_cedula_persona PRIMARY KEY (cedula), 
  ); 

CREATE TABLE Evento 
  ( 
     idEvento    T_EVENTO NOT NULL, 
     nombre      VARCHAR(50) NOT NULL, 
     descripcion VARCHAR(200) NOT NULL, 
     fechaInicio DATE NOT NULL, 
     fechaFinal  DATE NOT NULL, 
     CONSTRAINT pk_idevento_evento PRIMARY KEY (idEvento) 
  ); 

CREATE TABLE Actividad 
  ( 
     idActividad            T_ACTIVIDAD NOT NULL, 
     idEvento               T_EVENTO NOT NULL, 
     nombre                 VARCHAR(50) NOT NULL, 
     descripcion            VARCHAR(200) NOT NULL, 
     cupo                   INT NOT NULL, 
     duracion               TIME NOT NULL, 
     porcentaje_aprobación INT NOT NULL, 
     CONSTRAINT pk_idactividad_actividad PRIMARY KEY (idActividad), 
     CONSTRAINT fk_idevento_evento FOREIGN KEY (idEvento) REFERENCES Evento ON DELETE CASCADE 
  ); 

CREATE TABLE Usuarios 
  ( 
     cedula     VARCHAR(50) NOT NULL, 
     tipoCuenta CHAR(1) NOT NULL, 
     CONSTRAINT pk_cedula_usuarios PRIMARY KEY (cedula), 
     CONSTRAINT fk_cedula_usuarios FOREIGN KEY (cedula) REFERENCES Persona ON DELETE CASCADE
  ); 

CREATE TABLE Administradores_Eventos 
  ( 
     cedula   VARCHAR(50) NOT NULL, 
     idEvento T_EVENTO NOT NULL, 
     CONSTRAINT pk_cedula_idevento_administradores_eventos PRIMARY KEY (idEvento 
     , cedula), 
     CONSTRAINT fk_cedula_administradores_eventos FOREIGN KEY (cedula)  
     REFERENCES persona  ON DELETE CASCADE, 
     CONSTRAINT fk_idevento_administradores_eventos FOREIGN KEY (idEvento) 
     REFERENCES Evento  ON DELETE CASCADE
  ); 

CREATE TABLE Edecan_Actividades 
  ( 
     cedula      VARCHAR(50) NOT NULL, 
     idActividad T_ACTIVIDAD NOT NULL, 
     CONSTRAINT pk_cedula_idactividad_edecan_actividades PRIMARY KEY ( 
     idActividad, cedula), 
     CONSTRAINT fk_cedula_edecan_actividades FOREIGN KEY (cedula) REFERENCES 
     Usuarios(cedula)  ON DELETE CASCADE, 
     CONSTRAINT fk_idactividad_edecan_actividades FOREIGN KEY (idActividad) 
     REFERENCES actividad(idActividad)  ON DELETE CASCADE
  ); 

CREATE TABLE Matricula 
  ( 
     cedula      VARCHAR(50) NOT NULL, 
     idActividad T_ACTIVIDAD NOT NULL, 
     aprobado    CHAR(1) NOT NULL, 
     estado      CHAR(1) NOT NULL 
     CONSTRAINT pk_cedula_iactividad_matricula PRIMARY KEY (idActividad, cedula) 
     , 
     CONSTRAINT fk_cedula_matricula FOREIGN KEY (cedula) REFERENCES persona  ON DELETE CASCADE, 
     CONSTRAINT fk_idactividad_matricula FOREIGN KEY (idActividad) REFERENCES 
     actividad  ON DELETE CASCADE
  ); 

CREATE TABLE regEntrada 
  ( 
     idActividad T_ACTIVIDAD NOT NULL, 
     cedula      VARCHAR(9) NOT NULL, 
     fecha       DATE DEFAULT(Getdate()), 
     hora        DATETIME DEFAULT(Sysdatetime()), 
     CONSTRAINT fk_cedula_horae_fecha PRIMARY KEY (cedula, hora, fecha), 
     CONSTRAINT fk_idactividad_regentrada FOREIGN KEY (idActividad) REFERENCES 
     actividad  ON DELETE CASCADE
  ); 

CREATE TABLE regSalida 
  ( 
     idActividad T_ACTIVIDAD NOT NULL, 
     cedula      VARCHAR(9) NOT NULL, 
     fecha       DATE DEFAULT(Getdate()), 
     hora        DATETIME DEFAULT(Sysdatetime()), 
     CONSTRAINT fk_cedula_horas_fecha PRIMARY KEY (cedula, hora, fecha), 
     CONSTRAINT fk_idactividad_regsalida FOREIGN KEY (idActividad) REFERENCES 
     actividad  ON DELETE CASCADE
  );
CREATE TABLE inmuebles 
  ( 
     nombre       VARCHAR(200) NOT NULL, 
     id_inmuebles INT IDENTITY (1, 1) NOT NULL, 
     CONSTRAINT pk_inmuebles PRIMARY KEY(id_inmuebles) 
  ) 
CREATE TABLE horarios 
  ( 
     fecha       DATE NOT NULL, 
     id_inmueble INT NOT NULL, 
     horaInicio  TIME NOT NULL, 
     horaFinal   TIME NOT NULL, 
     idActividad T_ACTIVIDAD NOT NULL, 
     CONSTRAINT pk_compuesta_existencia PRIMARY KEY(fecha, id_inmueble, 
     horaInicio, horaFinal, idActividad), 
     CONSTRAINT fk_inmueble_horario_actividad FOREIGN KEY(id_inmueble) 
     REFERENCES inmuebles  ON DELETE CASCADE
  ); 

/*Eliminar edecan del sistema*/
CREATE PROCEDURE EliminarEdecan
@cedula varchar(50) 
AS
BEGIN
SET NOCOUNT ON;
		/*DELETE from Edecan_Actividades where cedula=@cedula;
		DELETE from Usuarios where cedula=@cedula and tipoCuenta='e';*/
		DELETE from Persona where cedula=@cedula;
END;




SELECT * FROM Persona



/*Eliminar actividad de un evento*/
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

CREATE PROCEDURE EliminarEvento
@id_evento T_evento
AS
BEGIN
SET NOCOUNT ON;
		DELETE from Eventos_Actividades where idEvento=@id_evento;
		DELETE from Edecan_Eventos where idEvento=@id_evento;
        DELETE from Evento where idEvento =@id_evento;
END;
SELECT * FROM Evento;
EXEC AddActivitys 'no mames','se genero','2017-12-6','12','ugug','8:8:8','8:8:8','0:0:0','Ev-1675'
SELECT * FROM Actividad



CREATE PROCEDURE modificarActivitys
    @nombre AS VARCHAR(50),
    @descripcion AS VARCHAR(30),
    @fecha AS VARCHAR(20),
    @cupo AS INT,
    @lugar AS VARCHAR(100) ,
	@horaInicio AS VARCHAR(50),
	@horaFinal AS VARCHAR(50),
	@duracion AS VARCHAR(50),
	@idActividad AS VARCHAR(50)
AS
BEGIN
	
    Begin Try
			DECLARE @fechat DATE;
			SET @fechat=@fecha;
			DECLARE @idEvento VARCHAR(50);
			SET @idEvento=(SELECT idEvento from Eventos_Actividades where idActividad=@idActividad);
			DECLARE @temp1 VARCHAR(50);
			SET @temp1=(SELECT idEvento FROM  Evento WHERE  fechaInicio<@fecha AND fechaFinal>@fecha AND idEvento=@idEvento); 
			PRINT @temp1;
			IF @temp1=@idEvento
				Update Actividad set nombre=@nombre,descripcion = @descripcion,fecha = @fecha,cupo = @cupo,lugar=@lugar,horaInicio=@horaInicio,horaFinal=@horaFinal,duracion=@duracion where idActividad = @idActividad
    End try
    Begin Catch
    End Catch
END
GO

EXEC modificarActivitys 'no mames','se genero','2017-12-8','12','ugug','8:8:8','8:8:8','0:0:0','Act-2431'

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

-- =============================================
-- Author:		Alberth Salas
-- Create date: 1/3/2018
-- Description:	Esta funcion obtiene todos los eventos encargados a un usuario
-- =============================================
CREATE PROCEDURE Eventos_De_Usuario
@cedula varchar(50)
 
AS BEGIN
    if ((select dbo.Usuarios.tipoCuenta from dbo.Usuarios where dbo.Usuarios.cedula=cedula)='a')
	select * from dbo.Evento;
	else if ((select dbo.Usuarios.tipoCuenta from dbo.Usuarios where dbo.Usuarios.cedula=cedula)='m')
	select dbo.Evento.idEvento,dbo.Evento.nombre,dbo.Evento.descripcion,dbo.Evento.fechaInicio,dbo.Evento.fechaFinal from (select * from dbo.Administradores_Eventos where dbo.Administradores_Eventos.cedula=cedula) as encargado
	inner join dbo.Evento on dbo.Evento.idEvento = encargado.idEvento
	else
	select dbo.Evento.idEvento,dbo.Evento.nombre,dbo.Evento.descripcion,dbo.Evento.fechaInicio,dbo.Evento.fechaFinal from (select * from dbo.Edecan_Eventos where dbo.Edecan_Eventos.cedula=cedula) as edecan
	inner join dbo.Evento on dbo.Evento.idEvento = edecan.idEvento;
END

CREATE PROCEDURE [dbo].[TodosEventos]
@filtro varchar(1),
@cedula varchar(50)
AS
BEGIN
	DECLARE @fecha DATE=(SELECT SYSDATETIME());
	---SELECT @fecha
	Declare @Resul as Table 
	(
	[idEvento] [varchar](7) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
	[fechaInicio] [date] NOT NULL,
	[fechaFinal] [date] NOT NULL
	)
	INSERT into @Resul EXEC dbo.Eventos_De_Usuario @cedula
	if (@filtro='p')
	SELECT * FROM @Resul as eventos_usuario
	WHERE CAST(eventos_usuario.fechaFinal AS DATETIME) < @fecha ORDER BY eventos_usuario.fechaInicio
	else if (@filtro='f')
	SELECT * FROM @Resul as eventos_usuario
	WHERE CAST(eventos_usuario.fechaInicio AS DATETIME) > @fecha ORDER BY eventos_usuario.fechaInicio
	else
	SELECT * FROM @Resul as eventos_usuario
	WHERE @fecha BETWEEN CAST(eventos_usuario.fechaInicio AS DATETIME) AND CAST(eventos_usuario.fechaFinal AS DATETIME) ORDER BY eventos_usuario.fechaInicio
END;


EXEC TodosEventos
SELECT * FROM Evento
SELECT * FROM Actividad
SELECT * FROM Usuarios

SELECT * FROM Eventos_Actividades

Select * from Edecan_Actividades

