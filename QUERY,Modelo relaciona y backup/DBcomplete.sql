CREATE RULE correo AS (@correo LIKE ('%_@__%.__%'));
go
CREATE RULE R_evento AS (@idEvento LIKE ('EV-[0-9][0-9][0-9][0-9]')); 

go 

EXEC Sp_addtype 
  'correo', 
  'varchar (50)', 
  'NOT NULL'; 

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
     estado      VARCHAR(1) NOT NULL, 
     contraseña VARCHAR(50) NOT NULL,
	 correo      correo NOT NULL,
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
     porcentaje_aprobación INT NOT NULL, 
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
     CONSTRAINT fk_cedula_usuarios FOREIGN KEY (cedula) REFERENCES persona ON DELETE CASCADE
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
     CONSTRAINT fk_cedula_matricula FOREIGN KEY (cedula) REFERENCES persona ON DELETE CASCADE, 
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
     REFERENCES inmuebles ON DELETE CASCADE
  ); 
  go

  INSERT INTO Persona(cedula,nombre,apellido1,apellido2,edad,direccion,estado,contraseña,correo)VALUES('207450217','a','a','a','22','aa','1','1234','landresf12@estudiantes.com');
  INSERT INTO Usuarios(cedula,tipoCuenta)VALUES('207450217','s')

  
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
CREATE PROCEDURE EliminarActdevento @id_actividad T_Actividad 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Actividad 
      WHERE  idActividad = @id_actividad; 
  END; 

go 

--Esto no elimina personas, solo las desmatricula de una actividad 
CREATE PROCEDURE EliminarPersona @id_persona   VARCHAR(50), 
                                 @id_actividad T_Actividad 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Matricula 
      WHERE  cedula = @id_persona 
             AND idActividad = @id_actividad; 
  END; 

go 

CREATE PROCEDURE AddActivitys @idEvento               AS VARCHAR(50), 
                              @nombre                 AS VARCHAR(50), 
                              @descripcion            AS VARCHAR(30), 
                              @cupo                   AS INT, 
                              @duracion               AS VARCHAR(50), 
                              @porcentaje_aprobación AS INT 
AS 
  BEGIN 
      BEGIN Try 
          DECLARE @Random NVARCHAR(10); --To store 4 digit random number 
          DECLARE @Final NVARCHAR(MAX)--Final unique random number 
          DECLARE @Upper INT; 
          DECLARE @Lower INT 
          ---- This will create a random number between 1 and 9999 
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
                       porcentaje_aprobación) 
          VALUES      (@Final, 
                       @idEvento, 
                       @nombre, 
                       @descripcion, 
                       @cupo, 
                       @duracion, 
                       @porcentaje_aprobación); 
      END try 

      BEGIN Catch 
      END Catch 
  END 

GO 

CREATE PROCEDURE EliminarEvento @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Evento 
      WHERE  idEvento = @id_evento; 
  END; 

go 

CREATE PROCEDURE modificarActivitys @idActividad            AS VARCHAR(50), 
                                    @nombre                 AS VARCHAR(50), 
                                    @descripcion            AS VARCHAR(30), 
                                    @cupo                   AS INT, 
                                    @duracion               AS VARCHAR(50), 
                                    @porcentaje_aprobación AS INT 
AS 
  BEGIN 
      BEGIN Try 
          UPDATE Actividad 
          SET    nombre = @nombre, 
                 descripcion = @descripcion, 
                 cupo = @cupo, 
                 duracion = @duracion, 
                 porcentaje_aprobación = @porcentaje_aprobación 
          WHERE  idActividad = @idActividad 
      END try 

      BEGIN Catch 
      END Catch 
  END 

GO 

CREATE PROCEDURE AddEvents @nombre      AS VARCHAR(50), 
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
          ---- This will create a random number between 1 and 9999 
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

CREATE PROCEDURE [dbo].[AddAdmiEvent] @cedula    VARCHAR(50), 
                                      @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      INSERT INTO Administradores_Eventos 
                  (cedula, 
                   idEvento) 
      VALUES     (@cedula, 
                  @id_evento); 
  END; 

GO 

CREATE PROCEDURE [dbo].[RemoveAdminEvent] @cedula    VARCHAR(50), 
                                          @id_evento T_evento 
AS 
  BEGIN 
      SET NOCOUNT ON; 

      DELETE FROM Administradores_Eventos 
      WHERE  cedula = @cedula 
             AND idEvento = @id_evento; 
  END; 

GO 

CREATE PROCEDURE [dbo].[TodosEventos] @filtro varchar(1), 
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

CREATE PROCEDURE [dbo].[AddHorario] @fecha       DATE, 
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

CREATE PROCEDURE [dbo].[RemoveHorario] @fecha       DATE, 
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
