
--procedure para agregar un usuario
ALTER PROCEDURE [dbo].[agregarUsuario] 
(
 @ced VARCHAR (50),
 @nombre VARCHAR (20),
 @ap1  VARCHAR (20),
 @ap2  VARCHAR (20),
 @edad  INT,
 @direc  VARCHAR(20),
 @correo VARCHAR(20),
 @pass VARCHAR (50)
 )

AS 
BEGIN
	INSERT INTO Persona(cedula,nombre, apellido1,apellido2,edad,direccion,estado) VALUES (@ced,@nombre,@ap1,@ap2,@edad,@direc,0);
	INSERT INTO Usuarios(cedula,correo,contraseña,tipoCuenta) VALUES (@ced,@correo,@pass,'u');
END

---procedure para eliminar la actividad del usuario, por ello se aumenta el cupo de la actividad
ALTER PROCEDURE [dbo].[eliminarActividad]
(
@cedula VARCHAR(50),
@idActividad VARCHAR(8)	
)
AS
BEGIN 
	DELETE FROM Persona_Actividades WHERE cedula = @cedula AND idActividad = @idActividad
	UPDATE Actividad SET cupo = cupo + 1 WHERE idActividad = @idActividad
END 
---procedure para enlazar una actividad con usuario, entonces se disminuye
ALTER PROCEDURE [dbo].[inscribirUsuario]
(
@cedula VARCHAR(50),
@idActividad VARCHAR(8)	
)
AS
BEGIN 
	INSERT INTO Persona_Actividades(cedula,idActividad) VALUES (@cedula, @idActividad)
	UPDATE Actividad SET cupo = cupo - 1 WHERE idActividad = @idActividad
END 


---busca la cedula del usuario 
ALTER PROCEDURE [dbo].[perfil]
(
@idUser VARCHAR(50)
)
AS
BEGIN
	SELECT * FROM Usuarios WHERE cedula = @idUser;
END;


---procedure que permite ver todos los eventos actualizados mediante la fecha
ALTER PROCEDURE [dbo].[TodosEventos]
AS
BEGIN
	DECLARE @fecha DATE=(SELECT SYSDATETIME());
	---SELECT @fecha
	SELECT * FROM Evento
	WHERE CAST(Evento.fechaInicio AS DATETIME) BETWEEN @fecha AND CAST(Evento.fechaFinal AS DATETIME)
END;


---procedure para extraer las actividades en las que esta inscrito a las actividades
ALTER PROCEDURE [dbo].[usuarioActividades]
(
 @idUser VARCHAR (50)
)
AS
BEGIN
	SELECT e.nombre, a.idActividad,a.nombre,a.lugar,a.horaInicio,a.horaFinal,a.descripcion,a.fecha,a.cupo,a.duracion from Actividad a 
		JOIN Eventos_Actividades as ea on a.idActividad = ea.idActividad JOIN Evento as e on ea.idEvento = e.idEvento
		JOIN Persona_Actividades as act on act.idActividad = ea.idActividad WHERE act.cedula = @idUser
END