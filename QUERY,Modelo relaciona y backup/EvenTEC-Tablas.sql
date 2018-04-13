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