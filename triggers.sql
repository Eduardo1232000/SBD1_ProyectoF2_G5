--tabla de las transacciones
CREATE TABLE historial_transacciones (
    id_transaccion  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_hora           TIMESTAMP,
    descripcion     VARCHAR2(100),
    tipo            VARCHAR2(10)
);


---------           CARRERA

--insert
CREATE OR REPLACE TRIGGER carrera_insert_trigger
BEFORE INSERT ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado una carrera en la tabla Carrera', 'INSERT');
END;

--update

CREATE OR REPLACE TRIGGER carrera_update_trigger
BEFORE UPDATE ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado una carrera en la tabla Carrera', 'UPDATE');
END;



--delete

CREATE OR REPLACE TRIGGER carrera_delete_trigger
BEFORE DELETE ON carrera
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado una carrera en la tabla Carrera', 'DELETE');
END;




---------           INCRIPCION

--insert

CREATE OR REPLACE TRIGGER inscripcion_insert_trigger
BEFORE INSERT ON inscripcion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado una inscripcion en la tabla Inscripción', 'Insert');
END;

--update


CREATE OR REPLACE TRIGGER inscripcion_update_trigger
BEFORE UPDATE ON inscripcion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado una inscripcion en la tabla Inscripción', 'Update');
END;


--delete

CREATE OR REPLACE TRIGGER inscripcion_delete_trigger
BEFORE DELETE ON inscripcion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado una inscripcion en la tabla Inscripción', 'Delete');
END;


---------           ESTUDIANTE

--insert
CREATE OR REPLACE TRIGGER estudiante_insert_trigger
BEFORE INSERT ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado un estudiante en la tabla Estudiante', 'Insert');
END;

--update

CREATE OR REPLACE TRIGGER estudiante_insert_trigger
BEFORE UPDATE ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado un estudiante en la tabla Estudiante', 'Update');
END;


--delete
CREATE OR REPLACE TRIGGER estudiante_delete_trigger
BEFORE DELETE ON estudiante
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado un estudiante en la tabla Estudiante', 'Delete');
END;


---------           DOCENTE

--insert
CREATE OR REPLACE TRIGGER docente_insert_trigger
BEFORE INSERT ON docente
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado un docente en la tabla Docente', 'Insert');
END;
--update
CREATE OR REPLACE TRIGGER docente_insert_trigger
BEFORE UPDATE ON docente
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado un docente en la tabla Docente', 'Update');
END;
--delete
CREATE OR REPLACE TRIGGER docente_delete_trigger
BEFORE DELETE ON docente
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado un docente en la tabla Docente', 'Delete');
END;


---------           PENSUM

--insert
CREATE OR REPLACE TRIGGER pensum_insert_trigger
BEFORE INSERT ON pensum
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado un pensum en la tabla Pensum', 'Insert');
END;
--update
CREATE OR REPLACE TRIGGER pensum_insert_trigger
BEFORE UPDATE ON pensum
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado un pensum en la tabla Pensum', 'Update');
END;
--delete
CREATE OR REPLACE TRIGGER pensum_delete_trigger
BEFORE DELETE ON pensum
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado un pensum en la tabla Pensum', 'Delete');
END;



---------           CURSO

--insert
CREATE OR REPLACE TRIGGER curso_insert_trigger
BEFORE INSERT ON curso
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado un curso en la tabla Curso', 'INSERT');
END;

--update

CREATE OR REPLACE TRIGGER curso_update_trigger
BEFORE UPDATE ON curso
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado un curso en la tabla Curso', 'UPDATE');
END;



--delete

CREATE OR REPLACE TRIGGER curso_delete_trigger
BEFORE DELETE ON curso
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado un curso en la tabla Curso', 'DELETE');
END;




---------           ASIGNACION

--insert
CREATE OR REPLACE TRIGGER asignacion_insert_trigger
BEFORE INSERT ON asignacion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado una asignacion en la tabla Asignacion', 'INSERT');
END;

--update

CREATE OR REPLACE TRIGGER asignacion_update_trigger
BEFORE UPDATE ON asignacion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado una asignacion en la tabla Asignacion', 'UPDATE');
END;



--delete

CREATE OR REPLACE TRIGGER asignacion_delete_trigger
BEFORE DELETE ON asignacion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado una asignacion en la tabla Asignacion', 'DELETE');
END;



---------           SECCION

--insert
CREATE OR REPLACE TRIGGER seccion_insert_trigger
BEFORE INSERT ON seccion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado una seccion en la tabla Seccion', 'INSERT');
END;

--update

CREATE OR REPLACE TRIGGER seccion_update_trigger
BEFORE UPDATE ON seccion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado una seccion en la tabla Seccion', 'UPDATE');
END;



--delete

CREATE OR REPLACE TRIGGER seccion_delete_trigger
BEFORE DELETE ON seccion
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado una seccion en la tabla Seccion', 'DELETE');
END;



---------           HORARIO

--insert
CREATE OR REPLACE TRIGGER horario_insert_trigger
BEFORE INSERT ON horario
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado un horario en la tabla Horario', 'INSERT');
END;

--update

CREATE OR REPLACE TRIGGER horario_update_trigger
BEFORE UPDATE ON horario
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado un horario en la tabla Horario', 'UPDATE');
END;



--delete

CREATE OR REPLACE TRIGGER horario_delete_trigger
BEFORE DELETE ON horario
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado una horario en la tabla Horario', 'DELETE');
END;



---------           PRERREQUISITO

--insert
CREATE OR REPLACE TRIGGER cursoprerrequisito_insert_trigger
BEFORE INSERT ON cursoprerrequisito
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha insertado un prerrequisito en la tabla Cursoprerrequisito', 'INSERT');
END;

--update

CREATE OR REPLACE TRIGGER prerrequisito_update_trigger
BEFORE UPDATE ON cursoprerrequisito
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha actualizado un prerrequisito en la tabla Cursoprerrequisito', 'UPDATE');
END;



--delete

CREATE OR REPLACE TRIGGER prerrequisito_delete_trigger
BEFORE DELETE ON cursoprerrequisito
FOR EACH ROW
BEGIN
    INSERT INTO historial_transacciones (fecha_hora, descripcion, tipo)
    VALUES (SYSDATE, 'Se ha eliminado un prerrequisito en la tabla Cursoprerrequisito', 'DELETE');
END;