CREATE RULE R_correo AS (@correo LIKE ('%_@__%.__%')); 

go 
EXEC Sp_addtype 
  'T_correo', 
  'varchar (50)', 
  'NOT NULL'; 

go
EXEC Sp_bindrule 
  'R_correo', 
  'T_correo';

go 
CREATE RULE R_evento AS (@idEvento LIKE ('EV-[0-9][0-9][0-9][0-9]')); 

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

CREATE RULE R_idactividad AS (@idActividad LIKE ('Act-[0-9][0-9][0-9][0-9]')); 

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

CREATE RULE R_telefono AS (@telefono LIKE ( 
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
     estado      VARCHAR(3) NOT NULL, 
     contraseña VARCHAR(50) NOT NULL, 
     correo      T_correo NOT NULL, 
     CONSTRAINT pk_cedula_persona PRIMARY KEY (cedula), 
  ); 

go 

CREATE TABLE Evento 
  ( 
     idEvento    T_EVENTO NOT NULL, 
     nombre      VARCHAR(50) NOT NULL, 
     descripcion VARCHAR(200) NOT NULL, 
     fechaInicio DATE NOT NULL, 
     fechaFinal  DATE NOT NULL, 
     CONSTRAINT pk_idevento_evento PRIMARY KEY (idEvento) 
  ); 

go 

CREATE TABLE Actividad 
  ( 
     idActividad            T_ACTIVIDAD NOT NULL, 
     idEvento               T_EVENTO NOT NULL, 
     nombre                 VARCHAR(50) NOT NULL, 
     descripcion            VARCHAR(200) NOT NULL, 
     cupo                   INT NOT NULL, 
     duracion               TIME NOT NULL, 
     porcentaje_aprobacion INT NOT NULL, 
     CONSTRAINT pk_idactividad_actividad PRIMARY KEY (idActividad), 
     CONSTRAINT fk_idevento_evento FOREIGN KEY (idEvento) REFERENCES Evento( 
     idEvento) ON DELETE CASCADE 
  ); 

go 

CREATE TABLE Usuarios 
  ( 
     cedula     VARCHAR(50) NOT NULL, 
     tipoCuenta CHAR(1) NOT NULL, 
     CONSTRAINT pk_cedula_usuarios PRIMARY KEY (cedula), 
     CONSTRAINT fk_cedula_usuarios FOREIGN KEY (cedula) REFERENCES persona ON 
     DELETE CASCADE 
  ); 

go

/*
	Tipo de proceso: CREATE TABLE	Nombre del proceso: Lugar
	Tabla de atributos
    	Nombre		| Tipo			| NOT NULL	| PK	| FK	|
    	------------+---------------+-----------+-------+-------|
        idLugar		| INT			| 	 X		| X		|		|
        nombre		| Varchar 50	| 	 X		| 		|		|
        capacidad	| INT			| 	 X		| 		|		|
        ubicExacta	| Varchar 150	| 	 X		| 		|		|
        descripcion	| Varchar 150	| 	 		| 		|		|
    Descripcion
    	Tabla para lugares del evento a realizar
*/
CREATE TABLE Lugar 
  ( 
     idLugar    INT NOT NULL, 
     nombre      VARCHAR(50) NOT NULL, 
     capacidad INT NOT NULL, 
     ubicExacta VARCHAR(150) NOT NULL,
     descripcion VARCHAR(150) NULL,
     CONSTRAINT pk_idLugar_Lugar PRIMARY KEY (idLugar) 
  ); 

go 

CREATE TABLE Administradores_Eventos 
  ( 
     cedula   VARCHAR(50) NOT NULL, 
     idEvento T_EVENTO NOT NULL, 
     CONSTRAINT pk_cedula_idevento_administradores_eventos PRIMARY KEY (idEvento 
     , cedula), 
     CONSTRAINT fk_cedula_administradores_eventos FOREIGN KEY (cedula) 
     REFERENCES persona ON DELETE CASCADE, 
     CONSTRAINT fk_idevento_administradores_eventos FOREIGN KEY (idEvento) 
     REFERENCES Evento ON DELETE CASCADE 
  ); 

go 

CREATE TABLE Edecan_Actividades 
  ( 
     cedula      VARCHAR(50) NOT NULL, 
     idActividad T_ACTIVIDAD NOT NULL, 
     CONSTRAINT pk_cedula_idactividad_edecan_actividades PRIMARY KEY ( 
     idActividad, cedula), 
     CONSTRAINT fk_cedula_edecan_actividades FOREIGN KEY (cedula) REFERENCES 
     Usuarios(cedula) ON DELETE CASCADE, 
     CONSTRAINT fk_idactividad_edecan_actividades FOREIGN KEY (idActividad) 
     REFERENCES actividad(idActividad) ON DELETE CASCADE 
  ); 

go 

CREATE TABLE Matricula 
  ( 
     cedula      VARCHAR(50) NOT NULL, 
     idActividad T_ACTIVIDAD NOT NULL, 
     aprobado    CHAR(1) NOT NULL, 
     estado      CHAR(1) NOT NULL 
     CONSTRAINT pk_cedula_iactividad_matricula PRIMARY KEY (idActividad, cedula) 
     , 
     CONSTRAINT fk_cedula_matricula FOREIGN KEY (cedula) REFERENCES persona ON 
     DELETE CASCADE, 
     CONSTRAINT fk_idactividad_matricula FOREIGN KEY (idActividad) REFERENCES 
     actividad ON DELETE CASCADE 
  ); 

go 

CREATE TABLE regEntrada 
  ( 
     idActividad T_ACTIVIDAD NOT NULL, 
     cedula      VARCHAR(9) NOT NULL, 
     fecha       DATE DEFAULT(Getdate()), 
     hora        DATETIME DEFAULT(Sysdatetime()), 
     CONSTRAINT pk_cedula_horae_fecha PRIMARY KEY (cedula, hora, fecha), 
     CONSTRAINT fk_idactividad_regentrada FOREIGN KEY (idActividad) REFERENCES 
     actividad ON DELETE CASCADE 
  ); 

go 

CREATE TABLE regSalida 
  ( 
     idActividad T_ACTIVIDAD NOT NULL, 
     cedula      VARCHAR(9) NOT NULL, 
     fecha       DATE DEFAULT(Getdate()), 
     hora        DATETIME DEFAULT(Sysdatetime()), 
     CONSTRAINT pk_cedula_horas_fecha PRIMARY KEY (cedula, hora, fecha), 
     CONSTRAINT fk_idactividad_regsalida FOREIGN KEY (idActividad) REFERENCES 
     actividad ON DELETE CASCADE 
  ); 

go 

CREATE TABLE inmuebles 
  ( 
     nombre       VARCHAR(200) NOT NULL, 
     id_inmuebles INT IDENTITY (1, 1) NOT NULL, 
     CONSTRAINT pk_inmuebles PRIMARY KEY(id_inmuebles) 
  ) 

go 

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
     REFERENCES inmuebles ON DELETE CASCADE, 
     CONSTRAINT fk_actividad_horario_actividad FOREIGN KEY(idActividad) 
     REFERENCES Actividad ON DELETE CASCADE 
  ); 

go 

--PRODEDURES 
/*Eliminar edecan del sistema*/ 
CREATE PROCEDURE EliminarEdecan @cedula varchar(50) 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Edecan_Actividades 
      WHERE  cedula = @cedula; 

      DELETE FROM Usuarios 
      WHERE  cedula = @cedula 
             AND tipoCuenta = 'e'; 

      DELETE FROM Persona 
      WHERE  cedula = @cedula; 
  END; 

go 

/*Eliminar actividad de un evento*/ 
create PROCEDURE EliminarActdevento @id_actividad T_Actividad 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Actividad 
      WHERE  idActividad = @id_actividad; 
  END; 

go 

--Esto no elimina personas, solo las desmatricula de una actividad 
create PROCEDURE desmatriculaPersona @id_persona   VARCHAR(50), 
                                 @id_actividad T_Actividad 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Matricula 
      WHERE  cedula = @id_persona 
             AND idActividad = @id_actividad;	
UPDATE Actividades SET cupo = cupo + 1 WHERE idActividad = @id_actividad
  END; 

go 

create PROCEDURE AddActivitys @idEvento               AS VARCHAR(50), 
                              @nombre                 AS VARCHAR(50), 
                              @descripcion            AS VARCHAR(30), 
                              @cupo                   AS INT, 
                              @duracion               AS VARCHAR(50), 
                              @porcentaje_aprobacion AS INT 
AS 
  BEGIN 
      BEGIN Try 
          DECLARE @Random NVARCHAR(10); --To store 4 digit random number 
          DECLARE @Final NVARCHAR(MAX)--Final unique random number 
          DECLARE @Upper INT; 
          DECLARE @Lower INT 
          ---- This will create or alter a random number between 1 and 9999 
          DECLARE @temp NVARCHAR(MAX); 
          DECLARE @bandera bit; 

          SET @bandera = 0; 

          WHILE @bandera = 0 
            BEGIN 
                SET @Lower = 1 ---- The lowest random number 
                SET @Upper = 9999 ---- The highest random number 

                SELECT @Random = Round(( ( @Upper - @Lower - 1 ) * Rand() + 
                                         @Lower 
                                       ), 
                                 0) 

                IF @Random < 1000 
                   AND @Random > 100 
                  SET @Final = 'Act-' + '0' + @Random; 

                IF @Random < 100 
                   AND @Random > 10 
                  SET @Final = 'Act-' + '00' + @Random; 

                IF @Random < 10 
                  SET @Final = 'Act-' + '000' + @Random; 

                IF @Random >= 1000 
                  SET @Final = 'Act-' + @Random; 

                SELECT @temp = (SELECT idActividad 
                                FROM   Actividad 
                                WHERE  Actividad.idActividad = @Final); 

                IF @temp IS NULL 
                  SET @bandera=1; 
            END; 

          PRINT @Final; 

          PRINT @bandera; 

          INSERT INTO Actividad 
                      (idActividad, 
                       idEvento, 
                       nombre, 
                       descripcion, 
                       cupo, 
                       duracion, 
                       porcentaje_aprobacion) 
          VALUES      (@Final, 
                       @idEvento, 
                       @nombre, 
                       @descripcion, 
                       @cupo, 
                       @duracion, 
                       @porcentaje_aprobacion); 
      END try 

      BEGIN Catch 
      END Catch 
  END 

GO 

create PROCEDURE EliminarEvento @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Evento 
      WHERE  idEvento = @id_evento; 
  END; 

go 

create PROCEDURE modificarActivitys @idActividad            AS VARCHAR(50), 
                                    @nombre                 AS VARCHAR(50), 
                                    @descripcion            AS VARCHAR(30), 
                                    @cupo                   AS INT, 
                                    @duracion               AS VARCHAR(50), 
                                    @porcentaje_aprobacion AS INT 
AS 
  BEGIN 
      BEGIN Try 
          UPDATE Actividad 
          SET    nombre = @nombre, 
                 descripcion = @descripcion, 
                 cupo = @cupo, 
                 duracion = @duracion, 
                 porcentaje_aprobacion = @porcentaje_aprobacion 
          WHERE  idActividad = @idActividad 
      END try 

      BEGIN Catch 
      END Catch 
  END 

GO 

create PROCEDURE AddEvents @nombre      AS VARCHAR(50), 
                           @descripcion AS VARCHAR(30), 
                           @fechaInicio AS VARCHAR(50), 
                           @fechaFinal  AS VARCHAR(50) 
AS 
  BEGIN 
      BEGIN Try 
          DECLARE @Random NVARCHAR(10); --To store 4 digit random number 
          DECLARE @Final NVARCHAR(MAX)--Final unique random number 
          DECLARE @Upper INT; 
          DECLARE @Lower INT 
          ---- This will create or alter a random number between 1 and 9999 
          DECLARE @temp NVARCHAR(MAX); 
          DECLARE @bandera bit; 

          SET @bandera = 0; 

          WHILE @bandera = 0 
            BEGIN 
                SET @Lower = 1 ---- The lowest random number 
                SET @Upper = 9999 ---- The highest random number 

                SELECT @Random = Round(( ( @Upper - @Lower - 1 ) * Rand() + 
                                         @Lower 
                                       ), 
                                 0) 

                IF @Random < 1000 
                   AND @Random > 100 
                  SET @Final = 'Ev-' + '0' + @Random; 

                IF @Random < 100 
                   AND @Random > 10 
                  SET @Final = 'Ev-' + '00' + @Random; 

                IF @Random < 10 
                  SET @Final = 'Ev-' + '000' + @Random; 

                IF @Random >= 1000 
                  SET @Final = 'Ev-' + @Random; 

                SELECT @temp = (SELECT idEvento 
                                FROM   Evento 
                                WHERE  Evento.idEvento = @Final); 

                IF @temp IS NULL 
                  SET @bandera=1; 
            END; 

          PRINT @Final; 

          PRINT @bandera; 

          INSERT INTO Evento 
                      (idEvento, 
                       nombre, 
                       descripcion, 
                       fechaInicio, 
                       fechaFinal) 
          VALUES      (@Final, 
                       @nombre, 
                       @descripcion, 
                       @fechaInicio, 
                       @fechaFinal) 
      END try 

      BEGIN Catch 
      END Catch 
  END 

GO 

create PROCEDURE [dbo].[AddAdmiEvent] @cedula    VARCHAR(50), 
                                      @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 


IF( (select count(cedula) from Usuarios where cedula=@cedula and tipoCuenta='m')=1 and (select count(cedula) from Administradores_Eventos where cedula=@cedula)=0)
BEGIN

      INSERT INTO Administradores_Eventos 
                  (cedula, 
                   idEvento) 
      VALUES     (@cedula, 
                  @id_evento);  
				  select 1;
END
ELSE
SELECT 0;
  END; 

GO 

create PROCEDURE [dbo].[RemoveAdminEvent] @cedula    VARCHAR(50), 
                                          @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Administradores_Eventos 
      WHERE  cedula = @cedula 
             AND idEvento = @id_evento; 
  END; 

GO 

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

GO

create  PROCEDURE [dbo].[TodosEventos] @filtro varchar(1), 
                                      @cedula varchar(50) 
AS 
  BEGIN 
      DECLARE @fecha DATE=(SELECT SYSDATETIME()); 
      ---SELECT @fecha 
      DECLARE @Resul AS TABLE 
        ( 
           [idEvento]    [varchar](7) NOT NULL, 
           [nombre]      [varchar](50) NOT NULL, 
           [descripcion] [varchar](200) NOT NULL, 
           [fechaInicio] [date] NOT NULL, 
           [fechaFinal]  [date] NOT NULL 
        ) 

      INSERT INTO @Resul 
      EXEC dbo.Eventos_De_Usuario 
        @cedula 

      IF ( @filtro = 'p' ) 
        SELECT * 
        FROM   @Resul AS eventos_usuario 
        WHERE  Cast(eventos_usuario.fechaFinal AS DATETIME) < @fecha 
        ORDER  BY eventos_usuario.fechaInicio 
      ELSE IF ( @filtro = 'f' ) 
        SELECT * 
        FROM   @Resul AS eventos_usuario 
        WHERE  Cast(eventos_usuario.fechaInicio AS DATETIME) > @fecha 
        ORDER  BY eventos_usuario.fechaInicio 
      ELSE 
        SELECT * 
        FROM   @Resul AS eventos_usuario 
        WHERE  @fecha BETWEEN Cast(eventos_usuario.fechaInicio AS DATETIME) AND 
                              Cast( 
                                     eventos_usuario.fechaFinal AS 
                                     DATETIME) 
        ORDER  BY eventos_usuario.fechaInicio 
  END; 

GO 

EXEC TodosEventos'2-745-217','p'


SELECT *  FROM Administradores_Eventos

SELECT * FROM Persona

SELECT * FROM Usuarios

create PROCEDURE [dbo].[AddHorario] @fecha       DATE, 
                                    @id_inmueble INT, 
                                    @horaInicio  TIME, 
                                    @horaFinal   TIME, 
                                    @idActividad T_ACTIVIDAD 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DECLARE @temp1 VARCHAR(50); 

      SET @temp1=(SELECT Count(idEvento) 
                  FROM   Evento 
                  WHERE  fechaInicio < @fecha 
                         AND fechaFinal > @fecha 
                         AND idEvento = (SELECT idEvento 
                                         FROM   Actividad 
                                         WHERE  idActividad = @idActividad)); 

      PRINT @temp1; 

      IF @temp1 = 1 
        INSERT INTO horarios 
                    (fecha, 
                     id_inmueble, 
                     horaInicio, 
                     horaFinal, 
                     idActividad) 
        VALUES     (@fecha, 
                    @id_inmueble, 
                    @horaInicio, 
                    @horaFinal, 
                    @idActividad); 
  END; 

GO 

create PROCEDURE [dbo].[RemoveHorario] @fecha       DATE, 
                                       @id_inmueble INT, 
                                       @horaInicio  TIME, 
                                       @horaFinal   TIME, 
                                       @idActividad T_ACTIVIDAD 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM horarios 
      WHERE  fecha = @fecha 
             AND id_inmueble = @id_inmueble 
             AND horaInicio = @horaInicio 
             AND horaFinal = @horaFinal 
             AND idActividad = @idActividad; 
  END; 

GO 

--Parte Pamela
--procedure para agregar una persona
CREATE PROCEDURE agregarPersona 
(
 @ced VARCHAR (50),
 @nombre VARCHAR (20),
 @ap1  VARCHAR (20),
 @ap2  VARCHAR (20),
 @edad  INT,
 @direc  VARCHAR(20),
 @correo VARCHAR(50), 
 @pass VARCHAR (50)
 )

AS 
BEGIN
	IF((SELECT count(cedula) from Persona where cedula=@ced)=0)
		BEGIN
			INSERT INTO Persona(cedula,nombre, apellido1,apellido2,edad,direccion,estado,correo,contraseña) VALUES (@ced,@nombre,@ap1,@ap2,@edad,@direc,'out',@correo,@pass);
			SELECT 1;
		END
	ELSE
		SELECT 0;
	END
GO
---procedure para enlazar una actividad con usuario, entonces se disminuye
CREATE PROCEDURE matriculaUsuario
(
@cedula VARCHAR(50),
@idActividad VARCHAR(8)	
)
AS
BEGIN 

IF( ((select count(cedula) from Persona where cedula=@cedula)=1) and (select cupo from Actividad where idActividad=@idActividad)>0 )
BEGIN
	INSERT INTO Matricula(cedula,idActividad) VALUES (@cedula, @idActividad)
	UPDATE Actividad SET cupo = cupo - 1 WHERE idActividad = @idActividad 
	select 1;
END
ELSE
	select 0;
END 

GO

---busca la cedula del usuario 
CREATE PROCEDURE perfil
(
@idUser VARCHAR(50)
)
AS
BEGIN
	SELECT * FROM Persona WHERE cedula = @idUser;
END;

GO

---procedure para extraer las actividades en las que esta inscrito un usuario en especifico
CREATE PROCEDURE usuarioActividades
(
 @idUser VARCHAR (50)
)
AS
BEGIN
	
IF( (select count(cedula) from Persona where cedula=@idUser)=1 )
BEGIN
SELECT e.nombre, a.idActividad,a.nombre,i.lugar,h.horaInicio,h.horaFinal,h.fecha,a.descripcion,a.cupo,a.duracion from 
	((((select * from Matricula where cedula=@idUser) m join Actividad a on a.idActividad = m.idActividad) join eventos e on a.idEvento=e.idEvento)
	join
	horarios h on a.idActividad=h.idActividad) join inmuebles i on h.id_inmuebles=i.id_inmuebles;

END
ELSE
SELECT 0;

END

GO

CREATE PROCEDURE addRole
(
 @ced VARCHAR (50),
 @rol char
 )

AS 
BEGIN
	IF ((select count(cedula) from Persona where cedula = @ced)=1 and (select count(cedula) from Usuarios where cedula = @ced and tipoCuenta=@rol)=0 and (@rol='e' or @rol='m' or @rol='a'))
	BEGIN
		INSERT INTO Usuarios(cedula,tipoCuenta) values (@ced,@rol);
		SELECT 1;
		END
		ELSE
		SELECT 0;
	END
GO 
 --Procesos para la tabla lugar--
  /*
	Tipo de proceso: PROCEDURE	Nombre del proceso: crearLugar
	Tabla de parametros
    	Nombre		| Tipo			| E/S	|
    	------------+---------------+-------|
        @idLugar	| INT			| 	E	|
        @nombre		| Varchar 50	| 	E 	| 
        @capacidad	| INT			| 	E	| 
        @ubicExacta	| Varchar 150	| 	E	| 
        @descripcion| Varchar 150	| 	E	| 
    Descripcion
    	Proceso para crear un elemento en la tabla Lugar
*/

create procedure crearLugar (@idLugar INT, @nombre varchar(50), @capacidad INT, @ubicExacta varchar(150),@descripcion varchar(150))
AS
BEGIN
    Insert into Lugar(idLugar, nombre, capacidad, ubicExacta, descripcion) values(@idLugar, @nombre, @capacidad, @ubicExacta, @descripcion);
END

GO
/*
	Tipo de proceso: PROCEDURE	Nombre del proceso: modificarLugar
	Tabla de parametros
    	Nombre		| Tipo			| E/S	|
    	------------+---------------+-------|
        @idLugar	| INT			| 	E	|
        @nombre		| Varchar 50	| 	E 	| 
        @capacidad	| INT			| 	E	| 
        @ubicExacta	| Varchar 150	| 	E	| 
        @descripcion| Varchar 150	| 	E	| 
    Descripcion
    	Proceso para modificar un elemento en la tabla Lugar
*/
create procedure modificarLugar (@idLugar INT, @nombre varchar(50), @capacidad INT, @ubicExacta varchar(150),@descripcion varchar(150))
AS
BEGIN
	UPDATE Lugar
	SET nombre = @nombre,
        capacidad = @capacidad,
        ubicExacta = @ubicExacta,
        descripcion = @descripcion
	WHERE idLugar = @idLugar;
END

GO
/*
	Tipo de proceso: PROCEDURE	Nombre del proceso: eliminarLugar
	Tabla de parametros
    	Nombre		| Tipo			| E/S	|
    	------------+---------------+-------|
        @idLugar	| INT			| 	E	|
    Descripcion
    	Proceso para eliminar un elemento de la tabla Lugar
*/
create procedure eliminarLugar (@idLugar INT)
AS
BEGIN
	DELETE FROM Lugar
	WHERE idLugar = @idLugar;
END

GO
/*
	Tipo de proceso: PROCEDURE	Nombre del proceso: mostrarLugar
	Tabla de parametros
    	Nombre		| Tipo			| E/S	|
    	------------+---------------+-------|
    Descripcion
    	Proceso para mostrar los atributos de la tabla Lugar
*/
create procedure showLugar 
AS
BEGIN
	select * from Lugar;
END

go
/*
	Tipo de proceso: PROCEDURE	Nombre del proceso: mostrarLugar
	Tabla de parametros
    	Nombre		| Tipo			| E/S	|
    	------------+---------------+-------|
        @idLugar	| INT			| 	E	|
    Descripcion
    	Proceso para mostrar un atributo de la tabla Lugar
*/
create procedure showOneLugar(@idLugar INT)
AS
BEGIN
	select * from Lugar where idLugar = @idLugar;
END



--usuarios con rol
exec agregarPersona '207690305','Alberth','Salas','Calero',20,'Fortuna','alberthsalascalero@gmail.com','1234';
exec agregarPersona '207450217','Andres','Fernandez','Calderon',22,'San Ramón','landresf3638@gmail.com','0000';
exec agregarPersona '207610010','Keslerth','Calderon','Artavia',21,'Ciudad Quesada','keslerth.c@gmail.com','asdf';

--usuarios estandar
exec agregarPersona '000000001','Maria','Salas','Medina',8,'Agua Azul','Maria@gmail.com','4321';
exec agregarPersona '000000002','Juan','Perez','Trejos',23,'Ciudad Quesada','Juan@gmail.com','2222';
exec agregarPersona '000000003','Sofia','Salas','Calero',16,'Ciudad Quesada','Sofia.c@gmail.com','abcd';

--roles
exec addRole '207690305', 'e';
exec addRole '207450217', 'a';
exec addRole '207610010', 'm';

--eventos
exec AddEvents 'Taller SCRUM', 'Taller de capacitación en SCRUM, por la comunidad de moviles','05/06/2018','05/07/2018'
exec AddEvents 'Cena semestral', 'Cena del fin del 1 semestre, 2018','25/05/2018','26/05/2018';

--actividades
exec AddActivitys 'Ev-3020','Inauguracion','Presentación del evento',1000,'00:30',0;
exec AddActivitys 'Ev-3020','Baile','Baile luego de la cena',1000,'01:30',0;

SELECT * FROM Evento


SELECT a.cedula, p.contraseña,a.tipoCuenta from Usuarios as a inner join Persona as p on p.cedula=a.cedula and p.cedula= '207450217' and p.contraseña='0000'
--encargos
exec AddAdmiEvent '207610010','Ev-1469';
SELECT * FROM Usuarios
SELECT * FROM Persona