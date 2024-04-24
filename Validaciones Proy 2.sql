--VALIDAR QUE TENGA SOLO LETRAS------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_solo_letras (p_cadena VARCHAR2)
RETURN INTEGER
IS
    v_expresion VARCHAR2(100) := '^[[:alpha:][:space:]]+$'; -- EXPRESION REGULAR PARA VALIDAR LETRAS
BEGIN
    IF REGEXP_LIKE(p_cadena, v_expresion) THEN
        RETURN 1; -- SOLO LETRAS
    ELSE
        RETURN 0; -- NO SOLO LETRAS
    END IF;
END validar_solo_letras;

--PRUEBAS
SELECT validar_solo_letras('abcd') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_solo_letras('abcd|') FROM DUAL; -- Devuelve 0 (FALSE)


--VALIDAR CORREO FORMATO CORRECTO------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_formato_correo (p_correo VARCHAR2)
RETURN INTEGER
IS
    v_expresion VARCHAR2(100) := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; -- EXPRESION REGULAR PARA VALIDAR FORMATO DE CORREO ELECTRÓNICO
BEGIN
    IF REGEXP_LIKE(p_correo, v_expresion) THEN
        RETURN 1; -- FORMATO DE CORREO VÁLIDO
    ELSE
        RETURN 0; -- FORMATO DE CORREO NO VALIDO
    END IF;
END validar_formato_correo;

--PRUEBAS
SELECT validar_formato_correo('eduardo@gmail.com') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_formato_correo('eduardo@gmail') FROM DUAL; -- Devuelve 0 (FALSE)


--VALIDAR NUMERO POSITIVO MENOR A 99000------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_numero_positivo(p_entrada VARCHAR2)
RETURN INTEGER
IS
    v_numero NUMBER;
BEGIN
    BEGIN
        v_numero := TO_NUMBER(p_entrada);				--CONVERTIR EL VARCHAR A NUMERO
        IF v_numero > 0 AND v_numero < 99001 THEN		--SI ES NUMERO VALIDA QUE ESTE EN EL RANGO
            RETURN 1; 	--VALIDO
        ELSE
            RETURN 0; 	--NO VALIDO
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RETURN 0; 									--NO ES NUMERO, RETORNA 0
    END;
END validar_numero_positivo;

--PRUEBAS
SELECT validar_numero_positivo('1') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_numero_positivo(99000) FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_numero_positivo('A') FROM DUAL; -- Devuelve 0 (FALSE)

--VALIDAR CICLO-------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_ciclo(p_entrada VARCHAR2)
RETURN INTEGER
IS
BEGIN
    IF p_entrada = '1S' OR p_entrada = '2S' OR p_entrada = 'VJ' OR p_entrada = 'VD' THEN
        RETURN 1; -- VÁLIDO
    ELSE
        RETURN 0; -- NO VÁLIDO
    END IF;
END validar_ciclo;

--PRUEBAS
SELECT validar_ciclo('1S') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_ciclo('2S') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_ciclo('VJ') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_ciclo('VD') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_ciclo('1s') FROM DUAL; -- Devuelve 0 (FALSE)

--VALIDAR MAYUSCULA-------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_letra_mayuscula(p_entrada VARCHAR2)
RETURN INTEGER
IS
    v_codigo NUMBER;
BEGIN
    v_codigo := ASCII(p_entrada);
    IF v_codigo >= 65 AND v_codigo <= 90 AND LENGTH(p_entrada) =1 THEN		--VALIDA QUE ESTE ENTRE LOS ASCII MAYUSCULAS
        RETURN 1; --MAYUSCULA
    ELSE
        RETURN 0; --NO MAYUSCULA
    END IF;
END validar_letra_mayuscula;

--pruebas
SELECT validar_letra_mayuscula('Z') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_letra_mayuscula('C') FROM DUAL; -- Devuelve 1 (FALSE)
SELECT validar_letra_mayuscula('a') FROM DUAL; -- Devuelve 0 (FALSE)

--VALIDAR NUMERO DE TELEFONO OBVIANDO EL CODIGO DE AREA EJEMPLO +(502) o +502 o PUEDE SER SOLO 8 DIGITOS SIN CODIGO DE AREA------------------------------------------------------------------
CREATE OR REPLACE FUNCTION validar_telefono(p_entrada VARCHAR2)
RETURN INTEGER
IS
    v_expresion VARCHAR2(100) := '^(\+?\([0-9]{3}\)|\+?[0-9]{3})?[0-9]{8}$'; -- EXPRESION REGULAR PARA VALIDAR NUMERO DE TELEFONO DE 8 DIGITOS SIN CODIGO DE AREA O CON CODIGO DE AREA +(502)
BEGIN
    IF REGEXP_LIKE(p_entrada, v_expresion) THEN
        RETURN 1; -- FORMATO DE TELEFONO VÁLIDO
    ELSE
        RETURN 0; -- FORMATO DE TELEFONO NO VALIDO
    END IF;
END validar_telefono;

--PRUEBAS
SELECT validar_telefono('12345678') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_telefono('1234567') FROM DUAL; -- Devuelve 0 (FALSE) 
SELECT validar_telefono('123456789') FROM DUAL; -- Devuelve 0 (FALSE)
SELECT validar_telefono('1234567A') FROM DUAL; -- Devuelve 0 (FALSE)
SELECT validar_telefono('+50212345678') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_telefono('+(502)12345678') FROM DUAL; -- Devuelve 1 (TRUE)
SELECT validar_telefono('+(502)1234567') FROM DUAL; -- Devuelve 0 (FALSE)
SELECT validar_telefono('+(502)123456789') FROM DUAL; -- Devuelve 0 (FALSE)

--Numero a letras en espanol---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION numero_a_letras(p_numero NUMBER)
RETURN VARCHAR2
IS
    v_numero VARCHAR2(100);
BEGIN
    SELECT TO_CHAR(TO_DATE(p_numero, 'J'), 'JSP') INTO v_numero FROM DUAL;
    RETURN v_numero;
END numero_a_letras;

--PRUEBAS
SELECT numero_a_letras(1) FROM DUAL; -- Devuelve 'UNO'
SELECT numero_a_letras(100) FROM DUAL; -- Devuelve 'CIEN'
SELECT numero_a_letras(12345) FROM DUAL; -- Devuelve 'DOCE MIL TRESCIENTOS CUARENTA Y CINCO'
