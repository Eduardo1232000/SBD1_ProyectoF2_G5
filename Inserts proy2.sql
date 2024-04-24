INSERT INTO plan(PLAN,CODIGOCARRERA,NOMBRE,YEARINICIO,CICLOINICIAL,YEARFIN,CICLOFINAL,CREDITOSCIERRE) VALUES(1,1,'matutina','2018','1S','2022','2S',250);

SELECT * FROM plan;

--crear docente
INSERT INTO docente(codigodocente, nombres, apellidos, sueldomensual, fechanacimiento, correo, telefono, direccion, dpi_cui) VALUES(1,'Juan','Perez',5000,TO_DATE(p_Fecha_nac, 'DD-MM-YYYY'),'juanpe@gmail.com',12345678,'ciudad','1234567890101'); 

--crear curso
INSERT INTO curso(codigocurso, nombre) VALUES(1,'Matematica');
INSERT INTO curso(codigocurso, nombre) VALUES(4,'Compi');
INSERT INTO curso(codigocurso, nombre) VALUES(5,'Fisica');

SELECT * FROM curso;

--crear periodo
INSERT INTO periodo(codigoperiodo, horainicio, horafin) VALUES(1,TO_DATE('12:00', 'HH24:MI'),TO_DATE('14:40', 'HH24:MI'));

--insertar dia
INSERT INTO dia(numerodia, nombre) VALUES(1,'Lunes');
INSERT INTO dia(numerodia, nombre) VALUES(2,'Martes');
INSERT INTO dia(numerodia, nombre) VALUES(3,'Miercoles');
INSERT INTO dia(numerodia, nombre) VALUES(4,'Jueves');
INSERT INTO dia(numerodia, nombre) VALUES(5,'Viernes');
INSERT INTO dia(numerodia, nombre) VALUES(6,'Sabado');

-- crear salon
INSERT INTO salon(edificio, Salon, capacidadsalon) VALUES('T3','202',50);
INSERT INTO salon(edificio, Salon, capacidadsalon) VALUES('T3','203',50);

-- crear asignacion 
INSERT INTO asignacion(nocarne, codigocurso, seccion, year, ciclo, zona, notaexamenfinal, identificador) VALUES(1,1,'A',2021,'1S',0,0,1); 
Select * from asignacion;