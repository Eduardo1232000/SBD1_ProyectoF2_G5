----consulta 1

/*
Consultar pensum
Se debe obtener un listado de todos los cursos pertenecientes a una carrera
Parámetro Tipo de Dato Observación
Código Carrera Numérico Identificador de la carrera, debe existir
La salida debe mostrar:
✓ Código de Curso
✓ Nombre de Curso
✓ Si es obligatorio o no
✓ Créditos que otorga
✓ Créditos necesarios
 */

SELECT 
    c.codigocurso AS "Código de Curso",
    c.nombre AS "Nombre de Curso",
    CASE
        WHEN p.obligatorio = 'S' THEN 'Si'
        ELSE 'No'
    END AS "Obligatorio",
    p.creditos AS "Créditos que otorga",
    p.creditosprerrequisito AS "Créditos necesarios"
FROM 
    pensum p
JOIN 
    curso c ON p.codigocurso = c.codigocurso
WHERE 
    p.codigocarrera = 1; --aca se debe de modificar para colocar el codigo de la carrera
    

/*
--consulta 2
--Consultar Estudiante
    Se debe poder visualizar la información del estudiante según su número de carnet.
    carrera a la que esta inscrito, nombre completo (concatenado), nombre y apellidos
    Cantidad de creditos aprobados
*/
CREATE OR REPLACE PROCEDURE ConsultarEstudiante(
    p_carnet IN NUMERIC
) IS
    v_student_exist NUMBER;
BEGIN
    -- Verificar si el estudiante existe
    SELECT COUNT(*) INTO v_student_exist FROM estudiante WHERE nocarne = p_carnet;
    IF v_student_exist = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El estudiante no existe.');
    END IF;

    -- Consulta para mostrar la información del estudiante
    FOR info IN (
        SELECT 
            e.nocarne AS carnet,
            e.nombres || ' ' || e.apellidos AS nombre_completo,
            e.fechanacimiento AS fechanacimiento,
            e.correo AS correo,
            e.telefono AS telefono,
            e.direccion AS direccion,
            e.dpi_cui AS numero_dpi,
            c.nombre AS carrera,
            e.creditos AS creditos
        FROM estudiante e
        JOIN inscrito i ON e.nocarne = i.nocarne
        JOIN carrera c ON i.codigocarrera = c.codigocarrera
        WHERE e.nocarne = p_carnet
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Carnet: ' || info.carnet);
        DBMS_OUTPUT.PUT_LINE('Nombre Completo: ' || info.nombre_completo);
        DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento: ' || info.fechanacimiento);
        DBMS_OUTPUT.PUT_LINE('Correo: ' || info.correo);
        DBMS_OUTPUT.PUT_LINE('Telefono: ' || info.telefono);
        DBMS_OUTPUT.PUT_LINE('Direccion: ' || info.direccion);
        DBMS_OUTPUT.PUT_LINE('Numero de DPI: ' || info.numero_dpi);
        DBMS_OUTPUT.PUT_LINE('Carrera: ' || info.carrera);
        DBMS_OUTPUT.PUT_LINE('Cantidad de Créditos Aprobados: ' || info.creditos);
    END LOOP;
END;

--PRUEBAS

BEGIN
    ConsultarEstudiante(1);
END;
BEGIN
    ConsultarEstudiante(2);
END;

--3
--Debe mostrar la información de un docente según su código de empleado.

CREATE OR REPLACE PROCEDURE ConsultarDocente(p_codigo IN NUMERIC) IS
	contador NUMBER := 0;
BEGIN
	SELECT COUNT(*) INTO contador FROM docente WHERE codigodocente = p_codigo;
	IF contador = 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'ERROR: No existe ningun docente con ese codigo!.');
	END IF;
  FOR info IN (
    SELECT 
    codigodocente, 
    nombres,
    apellidos,
    fechanacimiento,
    correo,telefono,
    direccion,
    DPI_CUI 
  FROM docente WHERE codigodocente = p_codigo) LOOP
    DBMS_OUTPUT.PUT_LINE('CODIGO              : ' || info.codigodocente);
    DBMS_OUTPUT.PUT_LINE('NOMBRE COMPLETO:    : ' || info.nombres || ' '|| info.apellidos);
   	DBMS_OUTPUT.PUT_LINE('FECHA DE NACIMIENTO : ' ||info.fechanacimiento);
   	DBMS_OUTPUT.PUT_LINE('CORREO              : ' ||info.correo);
  	DBMS_OUTPUT.PUT_LINE('TELEFONO            : ' ||info.telefono);
 	DBMS_OUTPUT.PUT_LINE('DIRECCION           : ' ||info.direccion);
	DBMS_OUTPUT.PUT_LINE('NUMERO DE DPI       : ' ||info.DPI_CUI);
  END LOOP;
END;

--PRUEBAS

BEGIN
	ConsultarDocente(1);
END;

--consulta 4
    
/*
 Consultar asignaciones
Debe retornar un listado de estudiantes asignados al curso. Si la sección para el curso no
existe en un ciclo y año debe mostrar error.
Parámetro Tipo de Dato Observación
Código Curso Numérico Mostrar error si no existe
Ciclo Cadena Puede ser ‘1S’, ’2S’, ’VJ’, ’VD’.
Año Numérico
Sección Carácter Mayúscula
La salida debe mostrar:
✓ Carnet
✓ Nombre completo del estudiante (concatenado)
*/

CREATE OR REPLACE PROCEDURE ConsultarAsignaciones (
    p_codigo_curso IN NUMBER,
    p_ano IN NUMBER,
    p_ciclo IN VARCHAR2,
    p_seccion IN VARCHAR2,
    p_carnet OUT INTEGER,
    p_nombre_completo OUT VARCHAR2
) AS
    v_cantidad_cursos INTEGER;
    v_cantidad_secciones INTEGER;
BEGIN
    -- Verificar si el curso especificado existe
    SELECT COUNT(*)
    INTO v_cantidad_cursos
    FROM curso
    WHERE codigocurso = p_codigo_curso;

    -- Si el curso no existe, mostrar error
    IF v_cantidad_cursos = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El curso especificado no existe.');
    END IF;

    -- Verificar si la sección del curso existe en el ciclo y año especificados
    SELECT COUNT(*)
    INTO v_cantidad_secciones
    FROM horario
    WHERE codigocurso = p_codigo_curso
    AND year = TO_CHAR(p_ano)
    AND ciclo = p_ciclo
    AND seccion = p_seccion;
	
    IF validar_letra_mayuscula(seccion) = 0 THEN
    	RAISE_APPLICATION_ERROR(-20002, 'La seccion debe ser mayuscula.');
    END IF;
   
   
    -- Si la sección no existe, mostrar error
    IF v_cantidad_secciones = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La sección especificada no existe para el curso en el ciclo y año especificados.');
    END IF;
    
    IF validar_ciclo(p_ciclo) = 0 THEN
    	RAISE_APPLICATION_ERROR(-20002, 'Error, el ciclo no es valido.');
    END IF;

    -- Consulta para mostrar las asignaciones de estudiantes
    SELECT 
        a.nocarne,
        e.nombres || ' ' || e.apellidos
    INTO
        p_carnet,
        p_nombre_completo
    FROM 
        asignacion a
    JOIN 
        estudiante e ON a.nocarne = e.nocarne
    WHERE 
        a.codigocurso = p_codigo_curso
        AND a.year = TO_CHAR(p_ano)
        AND a.ciclo = p_ciclo
        AND a.seccion = p_seccion;
END;




DECLARE
  codigo_curso NUMBER := 1;
  ano NUMBER := 2024;
  ciclo VARCHAR2(2) := '1S';
  seccion VARCHAR2(10) := 'A';
BEGIN
  SELECT 
    a.nocarne AS "Carnet",
    e.nombres || ' ' || e.apellidos AS "Nombre completo del estudiante"
  INTO
    :carnet,
    :nombre_completo
  FROM 
    asignacion a
  JOIN 
    estudiante e ON a.nocarne = e.nocarne
  WHERE 
    a.codigocurso = codigo_curso
    AND a.year = ano
    AND a.ciclo = ciclo
    AND a.seccion = seccion;
END;


--consulta 5
/*
Consultar Horario
Deberá retornar el horario de cursos asignados de un estudiante en un ciclo y año. Si el
estudiante no existe debe mostrar error.
Parámetro Tipo de Dato Observación
Carnet Numérico Mostrar error si no existe
Ciclo Cadena Puede ser ‘1S’, ’2S’, ’VJ’, ’VD’.
Año Numérico Si el año no tiene registros, no mostrar nada
La salida debe mostrar:
✓ Curso (nombre del curso
✓ Sección
✓ Dia (día que se imparte el curso)
✓ Periodo (rango de horas)
✓ Lugar (Salón y edificio concatenado, Ejemplo “Edificio T3, Salón 101”)
*/

CREATE OR REPLACE PROCEDURE ConsultarHorario (
    p_carnet IN INTEGER,
    p_ciclo IN VARCHAR2,
    p_year IN NUMBER
) IS
    v_existe_estudiante INTEGER;
    v_existe_ciclo INTEGER;
    v_existe_year INTEGER;
BEGIN
    -- Verificar si el estudiante existe
    SELECT COUNT(*)INTO v_existe_estudiante FROM estudiante WHERE nocarne = p_carnet;
    IF v_existe_estudiante = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El estudiante no existe.');
    END IF;

    --verificar si el ciclo es valido
    IF validar_ciclo(p_ciclo) = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El ciclo no tiene formato correcto.');
    END IF;

    -- Verificar si el ciclo existe
    SELECT COUNT(*) INTO v_existe_ciclo FROM horario WHERE ciclo = p_ciclo; 
    IF v_existe_ciclo = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El ciclo no existe.');
    END IF;

    -- Verificar si el año tiene registros
    SELECT COUNT(*) INTO v_existe_year FROM horario WHERE year = p_year;
    IF v_existe_year = 0 THEN
        RETURN;
    END IF;

    -- Consulta para mostrar el horario de cursos asignados de un estudiante
    FOR info IN (
        SELECT
            c.nombre AS curso,
            s.seccion AS seccion,
            d.nombre AS dia,
            TO_CHAR(p.horainicio, 'HH24:MI:SS')  AS h_inicio,
            TO_CHAR(p.horafin, 'HH24:MI:SS') AS h_fin,
            sal.edificio AS edificio,
            sal.salon AS salon
            
        FROM asignacion a
        JOIN curso c ON a.codigocurso = c.codigocurso
        JOIN seccion s ON a.seccion = s.seccion
        JOIN horario h ON a.seccion = h.seccion AND a.year = h.year AND a.ciclo = h.ciclo
        JOIN dia d ON h.numerodia = d.numerodia
        JOIN periodo p ON h.codigoperiodo = p.codigoperiodo
        JOIN salon sal ON h.salon = sal.salon  
        WHERE a.nocarne = p_carnet AND a.ciclo = p_ciclo AND a.year = p_year
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Curso: ' || info.curso);
        DBMS_OUTPUT.PUT_LINE('Sección: ' || info.seccion);
        DBMS_OUTPUT.PUT_LINE('Día: ' || info.dia);
        DBMS_OUTPUT.PUT_LINE('Periodo: ' || info.h_inicio || ' - ' || info.h_fin);
        DBMS_OUTPUT.PUT_LINE('Edificio: ' || info.edificio || ', Salón ' || info.salon);
    END LOOP;
END;
--PRUEBAS
select * from periodo;
BEGIN
    ConsultarHorario(1,'1S',2021);
END;



--6
CREATE OR REPLACE PROCEDURE ConsultarAprobaciones(p_codigo INTEGER, p_ciclo VARCHAR2, p_year INTEGER, p_seccion VARCHAR2) IS
	contador NUMBER := 0;
	v_codigocurso NUMBER :=0;
	v_seccion NUMBER :=0;
BEGIN
	--VALIDACION CODIGO CURSO
	SELECT COUNT(*) INTO v_codigocurso FROM pensum WHERE codigocurso = p_codigo;
	IF v_codigocurso = 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'ERROR: No existe el curso en la tabla pensum!.');
	END IF;

	--VALIDACION CICLO
	IF validar_ciclo(p_ciclo) = 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'ERROR: El ciclo no tiene formato correcto.');
	END IF;
	
	--VALIDACION SECCION  (LETRA Y EXISTENCIA)
	IF validar_letra_mayuscula(p_seccion) = 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'ERROR: La seccion debe estar en mayuscula.');
	END IF;
	SELECT COUNT(*) INTO v_seccion FROM seccion WHERE seccion = p_seccion AND YEAR = p_year AND ciclo = p_ciclo;
	IF v_seccion = 0 THEN
		RAISE_APPLICATION_ERROR(-20002, 'ERROR: La seccion no existe.');
	END IF;

	FOR info IN (
	SELECT
		c.CodigoCurso AS Codigo,
		a.NOCARNE AS Carnet,
		e.NOMBRES AS Nombre_Completo,
		a.ZONA + a.NOTAEXAMENFINAL AS notafinal,
		CASE
        	WHEN a.ZONA + a.NOTAEXAMENFINAL >= p.NOTAAPROBACION  THEN 'Aprobado'
        	ELSE 'Reprobado' 
    	END AS Estado
	FROM
		asignacion a
	JOIN 
		curso c ON a.CODIGOCURSO = c.CODIGOCURSO 
	JOIN 
		estudiante e ON a.NOCARNE = e.NOCARNE 
	JOIN 
		pensum p ON a.CODIGOCURSO = p.CODIGOCURSO
	WHERE 
		a.CodigoCurso = p_codigo AND a.CICLO = p_ciclo AND a.YEAR = p_year AND a.SECCION = p_seccion
	) LOOP		
    	DBMS_OUTPUT.PUT_LINE('CODIGO: ' || info.Codigo || ' , CARNET: ' || info.Carnet || ' , NOMBRE: ' || info.Nombre_Completo || ' , ESTADO: ' || info.Estado); 
  	END LOOP;
END;
--PRUEBAS

BEGIN
	ConsultarAprobaciones(1,'1S',2018,'A');
END;


---consulta 7

/*
Consultar cursos a asignar
Debe mostrar los cursos que un estudiante puede asignarse el próximo semestre, basado
en que ya aprobó los respectivos prerrequisitos.
Parámetro Tipo de Dato Observación
Carnet Numérico Mostrar error si no existe
La salida debe mostrar:
✓ Código de Curso
✓ Nombre Del Curso
✓ Créditos que Otorga
✓ Prerrequisito aprobado (código de curso prerrequisito)
✓ Nombre Prerrequisito (nombre del curso prerrequisito)
Para la salida, si el curso tiene varios prerrequisitos se debe mostrar en diferentes filas.
*/


CREATE OR REPLACE PROCEDURE ConsultarCursosAsignar (
    p_carnet IN INTEGER,
    p_ano IN VARCHAR2,
    p_ciclo IN VARCHAR2,
    p_cursor OUT SYS_REFCURSOR
) AS
    v_cantidad_estudiantes INTEGER;
BEGIN
    -- Verificar si el carnet del estudiante existe
    SELECT COUNT(*)
    INTO v_cantidad_estudiantes
    FROM estudiante
    WHERE nocarne = p_carnet;

    -- Si el estudiante no existe, mostrar error
    IF v_cantidad_estudiantes = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El carnet del estudiante no existe.');
    END IF;

    -- Abrir el cursor para los resultados
    OPEN p_cursor FOR
        SELECT 
            c.codigocurso AS "Código de Curso",
            c.nombre AS "Nombre del Curso",
            p.creditos AS "Créditos que Otorga",
            cr.codigocurso AS "Prerrequisito aprobado",
            cp.nombre AS "Nombre Prerrequisito"
        FROM 
            curso c
        JOIN 
            cursoprerrequisito cr ON c.codigocurso = cr.codigocurso
        JOIN 
            curso cp ON cr.codigocurso_1 = cp.codigocurso
        JOIN
            pensum p ON c.codigocurso = p.codigocurso
        LEFT JOIN 
            (
                SELECT 
                    nocarne,
                    codigocurso 
                FROM 
                    asignacion 
                WHERE 
                    year = p_ano 
                    AND ciclo = p_ciclo
            ) a ON c.codigocurso = a.codigocurso
        LEFT JOIN 
            estudiante e ON a.nocarne = e.nocarne
        WHERE 
            a.codigocurso IS NOT NULL
            AND e.nocarne = p_carnet;
END;

   
   


SELECT 
    c.codigocurso AS "Código de Curso",
    c.nombre AS "Nombre del Curso",
    p.creditos AS "Créditos que Otorga",
    cr.codigocurso AS "Prerrequisito aprobado",
    cp.nombre AS "Nombre Prerrequisito"
FROM 
    curso c
JOIN 
    cursoprerrequisito cr ON c.codigocurso = cr.codigocurso
JOIN 
    curso cp ON cr.codigocurso_1 = cp.codigocurso
JOIN
    pensum p ON c.codigocurso = p.codigocurso
LEFT JOIN 
    (
        SELECT 
            nocarne,
            codigocurso 
        FROM 
            asignacion 
        WHERE 
            year = :ano 
            AND ciclo = :ciclo
    ) a ON c.codigocurso = a.codigocurso
LEFT JOIN 
    estudiante e ON a.nocarne = e.nocarne
WHERE 
    a.codigocurso IS NOT NULL
    AND e.nocarne = :carnet;

--consulta 8
/*
Como solicitud especial se le solicita que para la tabla de catedráticos se ingrese una
nueva columna en la que se grabe el salario que ganan, pero en letras, pueden utilizar
tablas auxiliares.
La salida debe mostrar:
✓ Código Docente
✓ Nombre completo (concatenado)
✓ Salario (registrado)
✓ Salario en letras.
*/

CREATE OR REPLACE PROCEDURE ConsultarSalarioDocente IS 
BEGIN
    FOR info IN (
        SELECT 
            codigodocente,
            nombres || ' ' || apellidos AS nombre_completo,
            sueldomensual,
            numero_a_letras(sueldomensual) AS salario_en_letras
        FROM docente
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Código Docente: ' || info.codigodocente);
        DBMS_OUTPUT.PUT_LINE('Nombre Completo: ' || info.nombre_completo);
        DBMS_OUTPUT.PUT_LINE('Salario: ' || info.sueldomensual);
        DBMS_OUTPUT.PUT_LINE('Salario en Letras: ' || info.salario_en_letras);
    END LOOP;
END;

--PRUEBAS

BEGIN
    ConsultarSalarioDocente;
END;