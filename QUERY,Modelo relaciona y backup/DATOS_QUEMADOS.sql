--usuarios con rol
exec agregarPersona '207690305','Alberth','Salas','Calero',20,'Fortuna','alberthsalascalero@gmail.com','1234';
exec agregarPersona '207450217','Andres','Fernandez','Calderon',22,'San Ramón','landresf3638@gmail.com','0000';
exec agregarPersona '207610010','Keslerth','Calderon','Artavia',21,'Ciudad Quesada','keslerth.c@gmail.com','asdf';
exec agregarPersona '207510911','Kenneth','Alvarez','Esquivel',21,'Pital','kenneth_alv@hotmail.com','1234';

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
exec AddActivitys 'Ev-1469','Inauguracion','Presentación del evento',1000,'00:30',0;
exec AddActivitys 'Ev-1469','Baile','Baile luego de la cena',1000,'01:30',0;

--encargos
exec AddAdmiEvent '207610010','Ev-1469';
exec AddEdecan '207690305', 'Act-1229';