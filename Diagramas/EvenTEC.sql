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
		edad			smallint			NOT NULL,
		direccion		varchar(20)			NOT NULL,

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
		cupo			smallint					NOT NULL,
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
		cedula			varchar(10)		NOT NULL,
		fecha			date			default(GETDATE()),
		hora			datetime		default(SYSDATETIME()),
		
		CONSTRAINT		pk_IdActividad_Cedula_regEntrada 	primary key (idActividad,cedula),
		CONSTRAINT		fk_idActividad_regEntrada			foreign key (idActividad) references actividad	

);

create table regSalida
(
		idActividad		T_Actividad		NOT NULL,
		cedula			varchar(10)		NOT NULL,
		fecha			date			default(GETDATE()),
		hora			datetime		default(SYSDATETIME())
		
		CONSTRAINT		pk_IdActividad_Cedula_regSalida 	primary key (idActividad,cedula),
		CONSTRAINT		fk_idActividad_regSalida			foreign key (idActividad) references actividad			
);




select e.nombre as "Nombre Evento",a.nombre as "Nombre Actividad",a.descripcion,
a.fecha,a.cupo,a.lugar,a.horaInicio,a.horaFinal,a.duracion
from Actividad as a inner join Eventos_Actividades as ea on 
a.idActividad = ea.idActividad inner join Evento as e on e.idEvento = ea.idEvento
inner join Edecan_Actividades as e_a on e_a.idActividad = a.idActividad inner join 
Persona as p on e_a.cedula = p.cedula