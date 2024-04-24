--1------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--REGISTRAR ESTUDIANTE
CREATE OR REPLACE PROCEDURE RegistrarEstudiante(
    p_nocarne INTEGER,
    p_nombres VARCHAR2,
    p_apellidos VARCHAR2,
    p_ingresofamiliar NUMERIC,
    p_fechanacimiento VARCHAR2,
    p_correo VARCHAR2,
    p_telefono NUMERIC,
    p_direccion VARCHAR2,
    p_DPI_CUI NUMERIC,
    p_carrera INTEGER,
    p_plan INTEGER
)
IS 
    v_carrera_exist INTEGER;
    v_plan_exist INTEGER;
BEGIN 
    -- VALIDAR QUE SOLO CONTENGA LETRAS NOMBRES
    IF validar_solo_letras(p_nombres) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Los nombres del estudiante deben contener solo letras.');
    END IF;

    -- VALIDAR QUE SOLO CONTENGA LETRAS APELLIDOS
    IF validar_solo_letras(p_apellidos) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Los apellidos del estudiante deben contener solo letras.');
    END IF;

    -- VALIDAR FORMATO CORREO
    IF validar_formato_correo(p_correo) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El Correo no tiene el formato correcto.');
    END IF;
   
    -- VALIDAR TELEFONO OBVIANDO CODIGO DE AREA
    IF validar_telefono(p_telefono) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El Telefono no tiene el formato correcto.');
    END IF;

    -- VALIDAR QUE LA CARERA EXISTA
    SELECT COUNT(*) INTO v_carrera_exist 
    FROM carrera WHERE CodigoCarrera = p_carrera;
    IF v_carrera_exist = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: La carrera no existe.');
    END IF;

    -- VALIDAR QUE EL PLAN EXISTA
    SELECT COUNT(*) INTO v_plan_exist
    FROM plan WHERE plan = p_plan;
    IF v_plan_exist = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: El plan no existe.');
    END IF;

    -- INSERTAR EL ESTUDIANTE
    INSERT INTO estudiante (nocarne, nombres, apellidos, ingresofamiliar, fechanacimiento, correo, telefono, direccion, dpi_cui, creditos)
    VALUES (p_nocarne, p_nombres, p_apellidos, p_ingresofamiliar, TO_DATE(p_fechanacimiento, 'DD-MM-YYYY'), p_correo, p_telefono, p_direccion, p_DPI_CUI, 0);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END RegistrarEstudiante;

--PRUEBAS 
BEGIN
    RegistrarEstudiante(1,'Eduardo', 'Garcia Lopez', 10000,'05-03-1980','eduardo@mail.com',11223344,'calle 5 zona 1',1111222220101,1,1);
END;

SELECT * FROM estudiante;

-- nombre no valido
BEGIN
    RegistrarEstudiante(1,'Eduardo3$', 'Garcia Lopez', 10000,'05-03-1980','eduardo@gmail.com',11223344,'calle 5 zona 1',1111222220101,1,1);
END;

-- apellido no valido
BEGIN
    RegistrarEstudiante(1,'Eduardo', 'Garcia Lopez2', 10000,'05-03-1980','eduardo@gmail.com',11223344,'calle 5 zona 1',1111222220101,1,1);
END;

-- correo no valido
BEGIN
    RegistrarEstudiante(1,'Eduardo', 'Garcia Lopez', 10000,'05-03-1980','eduardogmail.com',11223344,'calle 5 zona 1',1111222220101,1,1);
END;

-- telefono no valido
BEGIN
    RegistrarEstudiante(1,'Eduardo', 'Garcia Lopez', 10000,'05-03-1980','eduardo@gmail.com',5022234344,'calle 5 zona 1',1111222220101,1,1);
END;

--2------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE CrearCarrera(p_nombre VARCHAR2)
IS
    v_ultimo_codigo INTEGER;
    v_existencia_carrera INTEGER;
BEGIN
    -- VALIDAR QUE SOLO CONTENGA LETRAS
    IF validar_solo_letras(p_nombre) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El nombre de la carrera debe contener solo letras.');
    END IF;

    -- VALIDAR QUE NO EXISTA UNA CARRERA CON EL MISMO NOMBRE
    SELECT COUNT(*) INTO v_existencia_carrera FROM carrera WHERE Nombre = p_nombre;
    IF v_existencia_carrera > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: Ya existe una carrera con ese nombre.');
    END IF;
	
   -- OBTENER ULTIMO NUMERO
    SELECT COALESCE(MAX(CodigoCarrera), 0) INTO v_ultimo_codigo FROM carrera;

    -- INSERTAR LA NUEVA CARRERA
    INSERT INTO carrera (CodigoCarrera, Nombre) VALUES (v_ultimo_codigo + 1, p_nombre);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END CrearCarrera;



--PRUEBA
BEGIN
    CrearCarrera('Sistemas');
END;
BEGIN
    CrearCarrera('Civil');
   	CrearCarrera('Industrial');
   	CrearCarrera('Quimica');
   	CrearCarrera('Mecanica');
   	CrearCarrera('Electrica');
END;

SELECT * FROM carrera


--3------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE RegistrarDocente(
    p_codigo INTEGER,
    p_Nombres VARCHAR2,
    p_Apellidos VARCHAR2,
    p_Fecha_nac VARCHAR2, -- Cambiado a VARCHAR2
    p_Correo VARCHAR2,
    p_Telefono NUMERIC,
    p_Direccion VARCHAR2,
    p_DPI NUMERIC,
    p_Salario NUMERIC
)
IS
    v_existencia_docente INTEGER;
BEGIN
    -- VALIDAR QUE SOLO CONTENGA LETRAS
    IF validar_solo_letras(p_Nombres) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Los nombres del docente deben contener solo letras.');
    END IF;
    IF validar_solo_letras(p_Apellidos) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Los apellidos del docente debe contener solo letras.');
    END IF;

    -- VALIDAR FORMATO CORREO
    IF validar_formato_correo(p_Correo) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El Correo no tiene el formato correcto.');
    END IF;
    
    -- VALIDAR SALARIO POSITIVO MENOR A 99000
    IF p_Salario < 0 OR p_Salario > 99000 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El Salario es Negativo o Superior a 99000.');
    END IF;
   
    -- VALIDAR QUE NO EXISTA UNO IGUAL
    SELECT COUNT(*) INTO v_existencia_docente FROM docente WHERE CodigoDocente = p_codigo;
    IF v_existencia_docente > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: Ya existe un docente con ese codigo.');
    END IF;
    
    -- INSERTAR EL NUEVO DOCENTE
    INSERT INTO docente (CodigoDocente, Nombres, Apellidos, SueldoMensual, FechaNacimiento, Correo, Telefono, Direccion, DPI_CUI) 
    VALUES (p_codigo, p_Nombres, p_Apellidos, p_Salario, TO_DATE(p_Fecha_nac, 'DD-MM-YYYY'), p_Correo, p_Telefono, p_Direccion, p_DPI);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END RegistrarDocente;

--PRUEBA 1
BEGIN --CORRECTO
    RegistrarDocente(1,'Felipe Armando', 'Garcia Lopez','05-03-1980','felipe123@gmail.com',11223344,'calle 5 zona 1',1111222220101,15000);
END;

SELECT * FROM docente;
--PRUEBA 2
BEGIN --INCORRECTO (NOMBRES CON NUMEROS)
    RegistrarDocente(1,'Felipe Armando2', 'Garcia Lopez','05-03-1980','felipe123@gmail.com',11223344,'calle 5 zona 1',1111222220101,15000);
END;

--PRUEBA 3
BEGIN --INCORRECTO (APELLIDOS CON NUMEROS)
    RegistrarDocente(1,'Felipe Armando', 'Garcia Lopez2','05-03-1980','felipe123@gmail.com',11223344,'calle 5 zona 1',1111222220101,15000);
END;

--PRUEBA 4
BEGIN --INCORRECTO (CORREO CON FORMATO INCORRECTO)
    RegistrarDocente(1,'Felipe Armando', 'Garcia Lopez','05-03-1980','felipe123gmail.com',11223344,'calle 5 zona 1',1111222220101,15000);
END;

--PRUEBA 5
BEGIN --INCORRECTO (SALARIO NEGATIVO)
    RegistrarDocente(1,'Felipe Armando', 'Garcia Lopez','05-03-1980','felipe123@gmail.com',11223344,'calle 5 zona 1',1111222220101,-15000);
END;


--4------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--CREA UN CURSO EN PENSUM (CREO PUEDE EXISTIR EN CURSOS)
CREATE OR REPLACE PROCEDURE CrearCurso(
    p_codigo_Curso INTEGER,
    p_Nombre VARCHAR2,
    p_Creditos_Necesarios NUMERIC,  -- PREREQUISITOS
    p_Creditos_Otorga NUMERIC,
    p_Obligatorio NUMERIC,
    p_Plan NUMERIC
)
IS
    v_existencia_curso INTEGER;
    v_existencia_curso_pensum INTEGER;
    v_codigo_carrera_plan INTEGER;
BEGIN
    -- VALIDAR CREDITOS PREREQUISITO POSITIVOS 
    IF  p_Creditos_Necesarios < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Los créditos prerrequisito deben ser positivos.');
    END IF;

    -- VALIDAR CREDITOS OTORGA POSITIVOS MENOR 
    IF  p_Creditos_Otorga < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Los créditos que otorga deben ser positivos.');
    END IF;

    -- VALIDAR OBLIGATORIO 1 O 0
    IF p_Obligatorio <> 0 AND p_Obligatorio <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: Obligatorio debe ser 0 o 1.');
    END IF;

    -- VALIDAR SI EXISTE EL CURSO EN LA TABLA CURSO
    SELECT COUNT(*) INTO v_existencia_curso FROM curso WHERE CodigoCurso = p_codigo_Curso;

    IF v_existencia_curso = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El curso no existe en la tabla Curso.');
    END IF;

    -- VALIDAR SI EXISTE CURSO EN PENSUM
    SELECT COUNT(*) INTO v_existencia_curso_pensum FROM pensum WHERE CodigoCurso = p_codigo_Curso AND plan = p_Plan;

    IF v_existencia_curso_pensum = 0 THEN
        -- OBTENER EL ID DE CARRERA
        SELECT CodigoCarrera INTO v_codigo_carrera_plan FROM plan WHERE plan = p_Plan;
        -- INSERTAR EL CURSO A PENSUM
        INSERT INTO pensum (CODIGOCURSO, PLAN, CODIGOCARRERA, OBLIGATORIO, CREDITOS, NOTAAPROBACION, ZONAMINIMA, CREDITOSPRERREQUISITO)
        VALUES (p_codigo_Curso, p_Plan, v_codigo_carrera_plan, p_Obligatorio, p_Creditos_Otorga, 61, 36, p_Creditos_Necesarios);
    ELSE 
    	RAISE_APPLICATION_ERROR(-20001, 'ERROR: El curso ya existe en la tabla pensum.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: Ocurrió una excepción en el procedimiento CrearCurso.'|| SQLERRM);
END CrearCurso;

--PRUEBAS
BEGIN 
    CrearCurso(4,'compi',1,7,1,1);
END;

BEGIN 
   CrearCurso(2,'Fisica', 1,7,1,2);
END;

SELECT * FROM pensum;

--5------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE AgregarPrerrequisito(p_codigo_curso INTEGER, p_codigo_curso_prerrequisito INTEGER)
IS
    v_existe_curso INTEGER;
    v_existe_curso_prerrequisito INTEGER;
    v_codigo_carrera INTEGER;
    v_planes_pensum SYS.ODCINUMBERLIST;
   	v_existe_combinacion INTEGER;
BEGIN
    --VALIDAR SI YA EXISTE EL PRERREQUISITO (NO INSERTAR DOBLE)
    SELECT COUNT(*) INTO v_existe_curso FROM cursoprerrequisito WHERE CodigoCurso = p_codigo_curso AND CodigoCurso_1 = p_codigo_curso_prerrequisito;
    IF v_existe_curso = 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El prerrequisito ya existe.');
    END IF;

    --VALIDAR SI EXISTE EL CURSO
    SELECT COUNT(*) INTO v_existe_curso FROM curso WHERE CodigoCurso = p_codigo_curso;
    IF v_existe_curso = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El curso no existe!.');
    END IF;

    --VALIDAR SI EXISTE EL CURSO PRERREQUISITO
    SELECT COUNT(*) INTO v_existe_curso_prerrequisito FROM curso WHERE CodigoCurso = p_codigo_curso_prerrequisito;
    IF v_existe_curso_prerrequisito = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El curso prerrequisito no existe!.');
    END IF;

    --OBTENER EL CÓDIGO DE CARRERA Y LOS PLANES DEL CURSO
    SELECT DISTINCT CodigoCarrera INTO v_codigo_carrera FROM pensum WHERE CodigoCurso = p_codigo_curso;

    --VALIDAR SI EXISTE CURSO EN PENSUM (PARA PODER AGREGAR PRERREQUISITO)
    IF v_codigo_carrera IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: No se puede agregar un prerrequisito ya que el curso no existe en el pensum!.');
    END IF;
   
   --OBTENER LOS PLANES 
   	SELECT DISTINCT Plan BULK COLLECT INTO v_planes_pensum FROM pensum WHERE CodigoCurso = p_codigo_curso;
   	
   	FOR i IN 1..v_planes_pensum.COUNT LOOP
	SELECT COUNT(*) INTO v_existe_combinacion FROM cursoprerrequisito WHERE CodigoCarrera = v_codigo_carrera
    AND Plan = v_planes_pensum(i)
    AND CodigoCurso = p_codigo_curso
    AND CodigoCurso_1 = p_codigo_curso_prerrequisito;
    
    -- SI LA COMBINACION NO EXISTE ENTONCES SE INSERTA SINO SE OMITE
    IF v_existe_combinacion = 0 THEN
        INSERT INTO cursoprerrequisito (CodigoCarrera, Plan, CodigoCurso, CodigoCurso_1) 
        VALUES (v_codigo_carrera, v_planes_pensum(i), p_codigo_curso, p_codigo_curso_prerrequisito);
    END IF;
	END LOOP;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END AgregarPrerrequisito;

--PRUEBA
BEGIN 
    AgregarPrerrequisito(1,4);	
END;

select * from curso;
--6--------------------------------------------------------------------------------------------------------------------
--Crear Seccion Curso
/*
Nota: segun el enunciado el ID de seccion deberia de ser autoincremental, pero no se puede hacer en este procedimiento porque el ID no existe como tal en la tabla para su insercion.
*/
CREATE OR REPLACE PROCEDURE CrearSeccionCurso(
    p_seccion VARCHAR2,
    p_ciclo VARCHAR2,
    p_codigo_curso INTEGER,
    p_codigo_docente INTEGER
)
IS
    v_existencia_seccion INTEGER;
    v_existencia_curso INTEGER;
    v_existencia_docente INTEGER;
    v_id_seccion INTEGER;
BEGIN
    -- VALIDAR QUE LA SECCION NO EXISTA
    SELECT COUNT(*) INTO v_existencia_seccion FROM seccion WHERE seccion = p_seccion AND codigocurso = p_codigo_curso AND year = p_year AND ciclo = p_ciclo;
    IF v_existencia_seccion > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: La sección ya existe.');
    END IF;

    -- VALIDAR QUE EL CURSO EXISTA
    SELECT COUNT(*) INTO v_existencia_curso FROM curso WHERE codigocurso = p_codigo_curso;
    IF v_existencia_curso = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El curso no existe.');
    END IF;

    -- VALIDAR QUE EL DOCENTE EXISTA
    SELECT COUNT(*) INTO v_existencia_docente FROM docente WHERE codigodocente = p_codigo_docente;
    IF v_existencia_docente = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: El docente no existe.');
    END IF;

    --SECCION SOLO PUEDE SER UNA LETRA MAYUSCULA
    IF REGEXP_LIKE(p_seccion, '[^A-Z]') THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERROR: La sección debe ser una letra mayúscula.');
    END IF;

    --CICLO SOLO PUEDE SER 1S, 2S, VJ, VD
    IF validar_ciclo(p_ciclo) = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'ERROR: El ciclo no es válido.');
    END IF;

    -- AUTO INCREMENTAR EL ID DE SECCION
    SELECT NVL(MAX(identificador), 0) + 1 INTO v_id_seccion FROM seccion;

    -- INSERTAR LA SECCION
    INSERT INTO seccion (identificador, seccion, year, ciclo, codigocurso, codigodocente)
    VALUES (v_id_seccion, p_seccion, p_year, p_ciclo, p_codigo_curso, p_codigo_docente);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
        ROLLBACK;
END CrearSeccionCurso;

--PRUEBAS 
BEGIN --correcto
    CrearSeccionCurso('A', '2021', '1S', 1, 1);
END;

BEGIN
    CrearSeccionCurso('A', '2021', '1S', 4, 1);
END;

SELECT * FROM seccion;
BEGIN --incorrecto (seccion ya existe)
    CrearSeccionCurso('A', '2021', '1S', 1, 1);
END;

BEGIN --incorrecto (curso no existe)
    CrearSeccionCurso('B', '2021', '1S', 2, 1);
END;

BEGIN --incorrecto (docente no existe)
    CrearSeccionCurso('B', '2021', '1S', 1, 2);
END;

BEGIN --incorrecto (seccion no es letra mayuscula)
    CrearSeccionCurso('b', '2021', '1S', 1, 1);
END;

BEGIN --incorrecto (ciclo no es valido)
    CrearSeccionCurso('B', '2021', '1', 1, 1);
END;

SELECT * FROM seccion;


--7--------------------------------------------------------------------------------------------------------------------
--Agregar Horario
CREATE OR REPLACE PROCEDURE AgregarHorario(
    p_codigo_curso INTEGER,
    p_seccion VARCHAR2,
    p_year VARCHAR2,
    p_ciclo VARCHAR2,
    p_codigo_periodo INTEGER,
    p_numero_dia INTEGER,
    p_edificio VARCHAR2,
    p_salon VARCHAR2,
    p_identificador_seccion INTEGER
)
IS
    v_existencia_seccion INTEGER;
    v_existencia_periodo INTEGER;
    v_existencia_dia INTEGER;
    v_existencia_salon INTEGER;
BEGIN
    -- VALIDAR QUE LA SECCION EXISTA
    SELECT COUNT(*) INTO v_existencia_seccion FROM seccion WHERE codigocurso = p_codigo_curso AND seccion = p_seccion AND year = p_year AND ciclo = p_ciclo AND identificador = p_identificador_seccion;
    IF v_existencia_seccion = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: La sección no existe.');
    END IF;

    -- VALIDAR QUE EL PERIODO EXISTA
    SELECT COUNT(*) INTO v_existencia_periodo FROM periodo WHERE codigoperiodo = p_codigo_periodo;
    IF v_existencia_periodo = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El periodo no existe.');
    END IF;

    -- VALIDAR QUE EL DIA EXISTA
    SELECT COUNT(*) INTO v_existencia_dia FROM dia WHERE numerodia = p_numero_dia;
    IF v_existencia_dia = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: El día no existe.');
    END IF;

    -- VALIDAR QUE EL SALON EXISTA
    SELECT COUNT(*) INTO v_existencia_salon FROM salon WHERE edificio = p_edificio AND salon = p_salon;
    IF v_existencia_salon = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'ERROR: El salón no existe.');
    END IF;

    -- INSERTAR EL HORARIO
    INSERT INTO horario (codigocurso, seccion, year, ciclo, codigoperiodo, numerodia, edificio, salon, identificador)
    VALUES (p_codigo_curso, p_seccion, p_year, p_ciclo, p_codigo_periodo, p_numero_dia, p_edificio, p_salon, p_identificador_seccion);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
        ROLLBACK;
END AgregarHorario;

--PRUEBAS
BEGIN --correcto
    AgregarHorario(1, 'A', '2021', '1S', 1, 1, 'T3', '202', 1);
END;

BEGIN --correcto
    AgregarHorario(4, 'A', '2021', '1S', 1, 1, 'T3', '203', 2);
END;

BEGIN --incorrecto (seccion no existe)
    AgregarHorario(1, 'A', '2021', '1S', 1, 1, 'T3', '202', 3);
END;

BEGIN --incorrecto (periodo no existe)
    AgregarHorario(1, 'A', '2021', '1S', 2, 1, 'T3', '202', 1);
END;

BEGIN --incorrecto (dia no existe)
    AgregarHorario(1, 'A', '2021', '1S', 1, 7, 'T3', '202', 1);
END;

BEGIN --incorrecto (salon no existe)
    AgregarHorario(1, 'A', '2021', '1S', 1, 1, 'T3', '203', 1);
END;

BEGIN --incorrecto (salon no existe)
    AgregarHorario(1, 'A', '2021', '1S', 1, 1, 'T2', '202', 1);
END;

SELECT * FROM seccion;

--------------8 
----------Asignación Curso-----------------
CREATE OR REPLACE PROCEDURE AsignarCurso(
    p_codigo_seccion VARCHAR2,
    p_carnet_estudiante INTEGER
)
IS
    v_existencia_seccion INTEGER;
    v_existencia_estudiante INTEGER;
    v_existencia_asignacion INTEGER;
    v_creditos_necesarios INTEGER;
    v_creditos_actuales INTEGER;
    v_codigo_carrera INTEGER;
    v_year VARCHAR2(4);
    v_ciclo VARCHAR2(2);
    v_seccion VARCHAR2(10);
    v_codigo_curso INTEGER;
BEGIN
    -- Verificar si la sección existe
    SELECT COUNT(*) INTO v_existencia_seccion FROM seccion WHERE seccion = p_codigo_seccion;
    IF v_existencia_seccion = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: La sección especificada no existe.');
    END IF;

    -- Verificar si el estudiante existe
    SELECT COUNT(*) INTO v_existencia_estudiante FROM estudiante WHERE nocarne = p_carnet_estudiante;
    IF v_existencia_estudiante = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El estudiante especificado no existe.');
    END IF;

    -- --asignar el codigo de curso
    SELECT codigocurso INTO v_codigo_curso FROM seccion WHERE seccion = p_codigo_seccion;

    -- -- Verificar si el estudiante ya está asignado a esta sección de curso
    -- SELECT COUNT(*) INTO v_existencia_asignacion FROM asignacion WHERE nocarne = p_carnet_estudiante AND seccion = p_codigo_seccion;
    -- IF v_existencia_asignacion > 0 THEN
    --     RAISE_APPLICATION_ERROR(-20003, 'ERROR: El estudiante ya está asignado a esta sección de curso.');
    -- END IF;

    -- -- Obtener el código de carrera del estudiante
    -- SELECT codigocarrera INTO v_codigo_carrera FROM inscrito WHERE nocarne = p_carnet_estudiante;
    
    -- -- Verificar si el curso corresponde a la carrera del estudiante
    -- SELECT COUNT(*) INTO v_existencia_seccion FROM seccion
    -- WHERE seccion = p_codigo_seccion AND
    --       codigocurso IN (SELECT codigocurso FROM pensum WHERE codigocarrera = v_codigo_carrera) AND
    --       seccion IN (SELECT seccion FROM seccion WHERE seccion = p_codigo_seccion) AND
    --       year = TO_CHAR(SYSDATE, 'YYYY') AND
    --       ciclo IN ('1S', '2S'); -- Considera todos los ciclos posibles

    -- IF v_existencia_seccion = 0 THEN
    --     RAISE_APPLICATION_ERROR(-20004, 'ERROR: El curso no corresponde a la carrera del estudiante.');
    -- END IF;

    -- -- Verificar si el estudiante tiene los créditos necesarios para este curso
    -- SELECT creditosprerrequisito INTO v_creditos_necesarios
    -- FROM pensum
    -- WHERE codigocurso = v_codigo_curso
    -- AND plan = (SELECT plan FROM inscrito WHERE nocarne = p_carnet_estudiante AND ROWNUM = 1); -- Si el estudiante está inscrito en más de una carrera, toma solo una

    -- SELECT NVL(SUM(creditos), 0) INTO v_creditos_actuales
    -- FROM pensum
    -- WHERE codigocurso IN (
    --     SELECT codigocurso
    --     FROM asignacion
    --     WHERE nocarne = p_carnet_estudiante
    -- );

    -- IF v_creditos_actuales < v_creditos_necesarios THEN
    --     RAISE_APPLICATION_ERROR(-20005, 'ERROR: El estudiante no tiene los créditos necesarios para este curso.');
    -- END IF;

    -- -- Obtener el año actual
    -- v_year := TO_CHAR(SYSDATE, 'YYYY');

    -- -- Obtener el ciclo actual
    -- IF TO_CHAR(SYSDATE, 'MM') IN ('01', '02', '03', '04', '05') THEN
    --     v_ciclo := 'S1';
    -- ELSIF TO_CHAR(SYSDATE, 'MM') = '06' THEN
    --     v_ciclo := 'VJ';
    -- ELSIF TO_CHAR(SYSDATE, 'MM') IN ('07', '08', '09', '10', '11') THEN
    --     v_ciclo := 'S2';
    -- ELSE
    --     v_ciclo := 'VD';
    -- END IF;

    -- -- Obtener la sección actual
    -- SELECT seccion INTO v_seccion FROM asignacion WHERE nocarne = p_carnet_estudiante AND seccion = p_codigo_seccion;

    -- -- Insertar la asignación del estudiante al curso
    -- INSERT INTO asignacion (nocarne, codigocurso, seccion, year, ciclo, zona, notaexamenfinal)
    -- VALUES (p_carnet_estudiante, p_codigo_seccion, v_seccion, v_year, v_ciclo, 0, 0); -- Se asume el ciclo actual y la zona y nota iniciales como cero
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END AsignarCurso;

--PRUEBAS
BEGIN
    AsignarCurso('A', 1);
END;

BEGIN --error seccion no existe
    AsignarCurso('B', 1);
END;
BEGIN --error estudiante no existe
    AsignarCurso('A', 2);
END;

SELECT * FROM estudiante;

--------------9
----------Ingresar Nota-----------------

CREATE OR REPLACE PROCEDURE IngresarNota(
    p_codigo_seccion VARCHAR2,
    p_carnet_estudiante INTEGER,
    p_zona NUMBER,
    p_examen_final NUMBER
)
IS
    v_existencia_seccion INTEGER;
    v_existencia_asignacion INTEGER;
    v_nota_final NUMBER;
    v_creditos_curso INTEGER;
    v_codigo_curso INTEGER;
BEGIN
    -- Verificar si la sección existe
    SELECT COUNT(*) INTO v_existencia_seccion FROM seccion WHERE seccion = p_codigo_seccion;
    IF v_existencia_seccion = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: La sección especificada no existe.');
    END IF;

    -- Verificar si el estudiante está asignado a esta sección de curso
    SELECT COUNT(*) INTO v_existencia_asignacion FROM asignacion WHERE nocarne = p_carnet_estudiante AND seccion = p_codigo_seccion;
    IF v_existencia_asignacion = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: El estudiante no está asignado a esta sección de curso.');
    END IF;

    -- Validar que p_zona y p_examen_final sean números positivos
    IF validar_numero_positivo(p_zona) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: La zona no es numero positivo.');
    END IF;

    IF validar_numero_positivo(p_examen_final) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: El examen final no es número positivo.');
    END IF;

    -- Obtener el código del curso
    SELECT COUNT(*) INTO v_codigo_curso FROM asignacion WHERE nocarne = p_carnet_estudiante AND seccion = p_codigo_seccion;


    -- Calcular la nota final y aplicar redondeo
    v_nota_final := ROUND(p_zona + p_examen_final);

    -- Actualizar la tabla asignación con la nota final y los valores de zona y examen final
    UPDATE asignacion
    SET notaexamenfinal = v_nota_final,
        zona = p_zona
    WHERE nocarne = p_carnet_estudiante AND seccion = p_codigo_seccion;

    -- Si el estudiante pasó el curso, sumar los créditos
    IF v_nota_final >= 61 THEN
        -- Obtener los créditos del curso
        SELECT creditos INTO v_creditos_curso
        FROM pensum
        WHERE codigocurso = v_codigo_curso;

        -- Sumar los créditos al estudiante
        UPDATE estudiante
        SET creditos = creditos + v_creditos_curso
        WHERE nocarne = p_carnet_estudiante;
        
        -- Actualizar los créditos del curso
        -- UPDATE curso
        -- SET creditosutilizados = creditosutilizados + v_creditos_curso
        -- WHERE codigocurso = p_codigo_seccion;
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END IngresarNota;

--PRUEBAS
BEGIN
    IngresarNota(1, 1, 50, 50);
END;


--------------10
----------Desasignar Curso-----------------

CREATE OR REPLACE PROCEDURE DesasignarCurso(
    p_codigo_seccion INTEGER,
    p_carnet_estudiante INTEGER
)
IS
    v_existencia_asignacion INTEGER;
BEGIN
    -- Verificar si el estudiante está asignado a esta sección de curso
    SELECT COUNT(*) INTO v_existencia_asignacion FROM asignacion WHERE nocarne = p_carnet_estudiante AND codigocurso = p_codigo_seccion;
    
    IF v_existencia_asignacion = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: El estudiante no está asignado a esta sección de curso.');
    END IF;

    -- Desasignar al estudiante del curso
    DELETE FROM asignacion WHERE nocarne = p_carnet_estudiante AND codigocurso = p_codigo_seccion;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END DesasignarCurso;

