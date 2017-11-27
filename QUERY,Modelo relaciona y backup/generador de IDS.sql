



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
			INSERT INTO Actividad (idActividad,nombre,descripcion,fecha,cupo,lugar,horaInicio,horaFinal,duracion) VALUES (@Final,@nombre,@descripcion,@fecha,@cupo,@lugar,@horaInicio,@horaFinal,@duracion)

			INSERT INTO Eventos_Actividades(idEvento,idActividad) VALUES (@idEvento,@Final)
    End try
    Begin Catch
    End Catch
END
GO


EXEC AddActivitys 'no mames','se genero','2017-12-12','12','ugug','8:8:8','8:8:8','0:0:0','Ev-0002'

