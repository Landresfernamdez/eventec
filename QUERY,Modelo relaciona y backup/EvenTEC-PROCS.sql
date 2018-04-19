---------------------------------------------------------------------------------------------------------------------
--CRUD PERSONA
--procedure para agregar una persona
CREATE or ALTER PROCEDURE agregarPersona 
(
 @ced VARCHAR (50),
 @nombre VARCHAR (20),
 @ap1  VARCHAR (20),
 @ap2  VARCHAR (20),
 @edad  INT,
 @direc  VARCHAR(20),
 @correo VARCHAR(50), 
 @pass VARCHAR (50),
	@rol char
 )

AS 
BEGIN
	IF((SELECT count(cedula) from Persona where cedula=@ced)=0)
		BEGIN
			INSERT INTO Persona(cedula,nombre, apellido1,apellido2,edad,direccion,estado,correo,contraseña) VALUES (@ced,@nombre,@ap1,@ap2,@edad,@direc,'out',@correo,@pass);
      INSERT INTO Usuarios(cedula,tipoCuenta) VALUES (@ced,@rol);
			SELECT 1;
		END
	ELSE
		SELECT 0;
	END

GO

---busca la cedula del usuario 
CREATE or ALTER PROCEDURE perfil
(
@idUser VARCHAR(50)
)
AS
BEGIN
	SELECT * FROM Persona WHERE cedula = @idUser;
END;

GO 
CREATE or ALTER PROCEDURE updatePersona 
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
	IF((SELECT count(cedula) from Persona where cedula=@ced)=1)
		BEGIN
			UPDATE Persona SET
      								nombre = @nombre, 
      								apellido1 = @ap1,
                      apellido2 = @ap2,
                      edad = @edad,
                      direccion = @direc,
                      correo = @correo,
                      contraseña = @pass
                      WHERE cedula = @ced;
			SELECT 1;
		END
	ELSE
		SELECT 0;
	END
GO
CREATE or ALTER PROCEDURE deletePersona
(
@idUser VARCHAR(50)
)
AS
BEGIN
	DELETE FROM [dbo].[Persona] WHERE cedula=@idUser;
END;

GO
--/CRUD Personas
---------------------------------------------------------------------------------------------------------------------
--CRUD Eventos
create or alter PROCEDURE AddEvents @nombre      AS VARCHAR(50), 
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

-- =============================================
-- Author:		Alberth Salas
-- Create date: 1/3/2018
-- Description:	Esta funcion obtiene todos los eventos encargados a un usuario
-- =============================================
CREATE OR ALTER PROCEDURE Eventos_De_Usuario
@cedula varchar(50)
 
AS BEGIN
    if ((select count(dbo.Usuarios.tipoCuenta) from dbo.Usuarios where dbo.Usuarios.cedula=@cedula and tipoCuenta='a')=1)
	select * from dbo.Evento;
	else if ((select count(dbo.Usuarios.tipoCuenta) from dbo.Usuarios where dbo.Usuarios.cedula=@cedula and tipoCuenta='m')=1)
	select dbo.Evento.idEvento,dbo.Evento.nombre,dbo.Evento.descripcion,dbo.Evento.fechaInicio,dbo.Evento.fechaFinal from (select * from dbo.Administradores_Eventos where dbo.Administradores_Eventos.cedula=@cedula) as encargado
	inner join dbo.Evento on dbo.Evento.idEvento = encargado.idEvento
	else
	select dbo.Evento.idEvento,dbo.Evento.nombre,dbo.Evento.descripcion,dbo.Evento.fechaInicio,dbo.Evento.fechaFinal from (select idEvento from (select * from dbo.Edecan_Actividades where dbo.Edecan_Actividades.cedula=@cedula) as edecan
	inner join dbo.Actividad on dbo.Actividad.idActividad = edecan.idActividad) as activities inner join Evento on Evento.idEvento=activities.idEvento;
END

GO
create or alter PROCEDURE [dbo].[TodosEventos] @filtro varchar(1), 
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
CREATE or ALTER PROCEDURE modificarEvento 
(
  	@idEvento 	 AS T_Evento,
		@nombre      AS VARCHAR(50), 
    @descripcion AS VARCHAR(30), 
    @fechaInicio AS VARCHAR(50), 
    @fechaFinal  AS VARCHAR(50) 
 )

AS 
BEGIN
	IF((SELECT count(idEvento) from Evento where idEvento=@idEvento)=1)
		BEGIN
			UPDATE [dbo].[Evento]
         SET
            [nombre] = @nombre,
            [descripcion] = @descripcion,
            [fechaInicio] = @fechaInicio,
            [fechaFinal] = @fechaFinal
       WHERE idEvento = @idEvento;
			SELECT 1;
		END
	ELSE
		SELECT 0;
	END
GO
create or alter PROCEDURE EliminarEvento @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Evento 
      WHERE  idEvento = @id_evento; 
  END;
GO 
--/CRUD Eventos
---------------------------------------------------------------------------------------------------------------------
--CRUD Actividades
create or alter PROCEDURE AddActivitys @idEvento               AS VARCHAR(50), 
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
create or alter PROCEDURE actividadesEdecan
	@idEvento 		AS T_Evento,
  @idUsuario 		AS VARCHAR(50)
  AS
  	BEGIN
    	SELECT Actividad.idActividad,Actividad.nombre,Actividad.descripcion,Actividad.cupo,Actividad.duracion,Actividad.porcentaje_aprobacion from
      	(SELECT idActividad from Edecan_Actividades where cedula=@idUsuario) as Actividades inner join Actividad on Actividades.idActividad = Actividad.idActividad and Actividad.idEvento=@idEvento;
    END
GO

create or alter PROCEDURE actividadesEvento
	@idEvento 		AS T_Evento
  AS
  	BEGIN
    	SELECT * from Actividad where Actividad.idEvento = @idEvento;
    END
GO
	
create or alter PROCEDURE modificarActivitys 
	@idActividad             AS T_Actividad,
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

create or alter PROCEDURE EliminarActividad 
	@idActividad T_Actividad
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Actividad 
      WHERE  idActividad = @idActividad; 
  END;
GO 

--/CRUD Actividades
---------------------------------------------------------------------------------------------------------------------
--CRUD Horarios

create or alter PROCEDURE [dbo].[AddHorario] 
	@fecha       DATE, 
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

CREATE OR ALTER PROCEDURE horarioActivity
	@idActivity T_ACTIVIDAD
  AS
  	BEGIN
    	select * from Horario where idActivad = @idActivity;
    END
GO

create or alter PROCEDURE [dbo].[RemoveHorario] 
	@fecha       DATE, 
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
--/CRUD Horarios
---------------------------------------------------------------------------------------------------------------------
--CRUD Inmuebles

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

create or alter procedure crearLugar (@idLugar INT, @nombre varchar(50), @capacidad INT, @ubicExacta varchar(150),@descripcion varchar(150))
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
create or alter procedure modificarLugar (@idLugar INT, @nombre varchar(50), @capacidad INT, @ubicExacta varchar(150),@descripcion varchar(150))
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
create or alter procedure eliminarLugar (@idLugar INT)
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
create or alter procedure showLugar 
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
create or alter procedure showOneLugar(@idLugar INT)
AS
BEGIN
	select * from Lugar where idLugar = @idLugar;
END
--/CRUD Inmuebles
---------------------------------------------------------------------------------------------------------------------
--Registros miscelaneos
GO

CREATE or ALTER PROCEDURE addRole
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

CREATE OR ALTER PROCEDURE AddEdecan 
	@cedula varchar(50),
	@idActividad T_ACTIVIDAD 
AS BEGIN
	
	IF( (SELECT COUNT(cedula) from Usuarios where tipoCuenta='e') =1 and (select count(cedula) from Edecan_Actividades where cedula=@cedula and idActividad=@idActividad)=0)
		BEGIN
			INSERT INTO Edecan_Actividades (cedula,idActividad) values (@cedula,@idActividad);
			SELECT 1;
		END
	ELSE
		SELECT 0;


END
 GO
/*Eliminar edecan del sistema*/ 
create or alter PROCEDURE EliminarEdecan @cedula varchar(50) 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Edecan_Actividades 
      WHERE  cedula = @cedula; 

      DELETE FROM Usuarios 
      WHERE  cedula = @cedula
             AND tipoCuenta = 'e'; 

  END; 

GO

--Esto no elimina personas, solo las desmatricula de una actividad 
create or alter PROCEDURE desmatriculaPersona @id_persona   VARCHAR(50), 
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

create or alter PROCEDURE [dbo].[AddAdmiEvent] @cedula    VARCHAR(50), 
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

create or alter PROCEDURE [dbo].[RemoveAdminEvent] @cedula    VARCHAR(50), 
                                          @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Administradores_Eventos 
      WHERE  cedula = @cedula 
             AND idEvento = @id_evento;
             

      DELETE FROM Usuarios 
      WHERE  cedula = @cedula
             AND tipoCuenta = 'm'; 
  END; 

GO 
---procedure para enlazar una actividad con usuario, entonces se disminuye
CREATE or ALTER PROCEDURE matriculaUsuario
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

---procedure para extraer las actividades en las que esta inscrito un usuario en especifico
CREATE or ALTER PROCEDURE usuarioActividades
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