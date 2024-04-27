CREATE TABLE asignacion (
    nocarne         INTEGER NOT NULL,
    codigocurso     INTEGER NOT NULL,
    seccion         VARCHAR2(2) NOT NULL,
    year            VARCHAR2(4) NOT NULL,
    ciclo           VARCHAR2(50) NOT NULL,
    zona            INTEGER NOT NULL,
    notaexamenfinal INTEGER NOT NULL,
    identificador    INTEGER NOT NULL
);
ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_pk PRIMARY KEY ( nocarne,
                                               codigocurso,
                                               seccion,
                                               year,
                                               ciclo,
                                               identificador );

CREATE TABLE carrera (
    codigocarrera INTEGER NOT NULL,
    nombre        VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE carrera ADD CONSTRAINT carrera_pk PRIMARY KEY ( codigocarrera );

CREATE TABLE curso (
    codigocurso INTEGER NOT NULL,
    nombre      VARCHAR2(50) NOT NULL
);

ALTER TABLE curso ADD CONSTRAINT curso_pk PRIMARY KEY ( codigocurso );

CREATE TABLE cursoprerrequisito (
    codigocarrera INTEGER NOT NULL,
    plan          INTEGER NOT NULL,
    codigocurso   INTEGER NOT NULL,
    codigocurso_1 INTEGER NOT NULL
);

ALTER TABLE cursoprerrequisito
    ADD CONSTRAINT cursoprerrequisito_pk PRIMARY KEY ( codigocarrera,
                                                       plan,
                                                       codigocurso,
                                                       codigocurso_1 );

CREATE TABLE dia (
    numerodia INTEGER NOT NULL,
    nombre    NVARCHAR2(50) NOT NULL
);

ALTER TABLE dia ADD CONSTRAINT dia_pk PRIMARY KEY ( numerodia );

CREATE TABLE docente (
    codigodocente   INTEGER NOT NULL,
    nombres         VARCHAR2(50) NOT NULL,
    apellidos       VARCHAR2(50) NOT NULL,
    sueldomensual   NUMBER NOT NULL,
    fechanacimiento DATE,
    correo          VARCHAR2(50),
    telefono        INTEGER,
    direccion       VARCHAR2(50),
    dpi_cui         INTEGER
);

ALTER TABLE docente ADD CONSTRAINT docente_pk PRIMARY KEY ( codigodocente );

CREATE TABLE estudiante (
    nocarne         INTEGER NOT NULL,
    nombres         VARCHAR2(50) NOT NULL,
    apellidos       VARCHAR2(50) NOT NULL,
    ingresofamiliar NUMBER NOT NULL,
    fechanacimiento DATE,
    correo          VARCHAR2(50),
    telefono        INTEGER,
    direccion       VARCHAR2(50),
    dpi_cui         INTEGER,
    creditos        INTEGER
);

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( nocarne );

CREATE TABLE horario (
    codigocurso   INTEGER NOT NULL,
    seccion       VARCHAR2(2) NOT NULL,
    year          VARCHAR2(4) NOT NULL,
    ciclo         VARCHAR2(50) NOT NULL,
    codigoperiodo INTEGER NOT NULL,
    numerodia     INTEGER NOT NULL,
    edificio      VARCHAR2(10) NOT NULL,
    salon         VARCHAR2(10) NOT NULL,
    identificador INTEGER NOT NULL
);


ALTER TABLE horario
    ADD CONSTRAINT horario_pk PRIMARY KEY ( numerodia,
                                            codigoperiodo,
                                            ciclo,
                                            year,
                                            seccion,
                                            codigocurso,
                                            identificador );

CREATE TABLE inscrito (
    codigocarrera    INTEGER NOT NULL,
    nocarne          INTEGER NOT NULL,
    fechainscripcion DATE NOT NULL
);

ALTER TABLE inscrito ADD CONSTRAINT inscrito_pk PRIMARY KEY ( nocarne,
                                                              codigocarrera );

CREATE TABLE pensum (
    codigocurso           INTEGER NOT NULL,
    plan                  INTEGER NOT NULL,
    codigocarrera         INTEGER NOT NULL,
    obligatorio           CHAR(1 CHAR) NOT NULL,
    creditos              INTEGER NOT NULL,
    notaaprobacion        INTEGER NOT NULL,
    zonaminima            INTEGER NOT NULL,
    creditosprerrequisito INTEGER
);

ALTER TABLE pensum
    ADD CONSTRAINT pensum_pk PRIMARY KEY ( codigocurso,
                                           plan,
                                           codigocarrera );

CREATE TABLE periodo (
    codigoperiodo INTEGER NOT NULL,
    horainicio    DATE NOT NULL,
    horafin       DATE NOT NULL
);

ALTER TABLE periodo ADD CONSTRAINT periodo_pk PRIMARY KEY ( codigoperiodo );

CREATE TABLE plan (
    plan           INTEGER NOT NULL,
    codigocarrera  INTEGER NOT NULL,
    nombre         VARCHAR2(50) NOT NULL,
    yearinicio     VARCHAR2(4) NOT NULL,
    cicloinicial   VARCHAR2(50) NOT NULL,
    yearfin        VARCHAR2(4) NOT NULL,
    ciclofinal     VARCHAR2(50) NOT NULL,
    creditoscierre INTEGER
);

ALTER TABLE plan ADD CONSTRAINT plan_pk PRIMARY KEY ( plan,
                                                      codigocarrera );

CREATE TABLE salon (
    edificio       VARCHAR2(10) NOT NULL,
    salon          VARCHAR2(10) NOT NULL,
    capacidadsalon INTEGER NOT NULL
);

ALTER TABLE salon ADD CONSTRAINT salon_pk PRIMARY KEY ( salon,
                                                        edificio );

CREATE TABLE seccion (
    identificador INTEGER NOT NULL,
    seccion       VARCHAR2(2) NOT NULL,
    year          VARCHAR2(4) NOT NULL,
    ciclo         VARCHAR2(50) NOT NULL,
    codigocurso   INTEGER NOT NULL,
    codigodocente INTEGER NOT NULL
);

ALTER TABLE seccion
    ADD CONSTRAINT seccion_pk PRIMARY KEY ( identificador,
                                            seccion,
                                            year,
                                            codigocurso,
                                            ciclo );

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_estudiante_fk FOREIGN KEY ( nocarne )
        REFERENCES estudiante ( nocarne );

ALTER TABLE asignacion
    ADD CONSTRAINT asignacion_seccion_fk FOREIGN KEY ( seccion,
                                                       year,
                                                       codigocurso,
                                                       ciclo,
                                                       identificador )
        REFERENCES seccion ( seccion,
                             year,
                             codigocurso,
                             ciclo,
                             identificador );

ALTER TABLE cursoprerrequisito
    ADD CONSTRAINT cursoprerrequisito_curso_fk FOREIGN KEY ( codigocurso )
        REFERENCES curso ( codigocurso );

ALTER TABLE cursoprerrequisito
    ADD CONSTRAINT cursoprerrequisito_pensum_fk FOREIGN KEY ( codigocurso_1,
                                                              plan,
                                                              codigocarrera )
        REFERENCES pensum ( codigocurso,
                            plan,
                            codigocarrera );

ALTER TABLE horario
    ADD CONSTRAINT horario_dia_fk FOREIGN KEY ( numerodia )
        REFERENCES dia ( numerodia );

ALTER TABLE horario
    ADD CONSTRAINT horario_periodo_fk FOREIGN KEY ( codigoperiodo )
        REFERENCES periodo ( codigoperiodo );

ALTER TABLE horario
    ADD CONSTRAINT horario_salon_fk FOREIGN KEY ( salon,
                                                  edificio )
        REFERENCES salon ( salon,
                           edificio );

ALTER TABLE horario
    ADD CONSTRAINT horario_seccion_fk FOREIGN KEY ( seccion,
                                                    year,
                                                    codigocurso,
                                                    ciclo,
                                                    identificador )
        REFERENCES seccion ( seccion,
                             year,
                             codigocurso,
                             ciclo,
                             identificador );

ALTER TABLE inscrito
    ADD CONSTRAINT inscrito_carrera_fk FOREIGN KEY ( codigocarrera )
        REFERENCES carrera ( codigocarrera );

ALTER TABLE inscrito
    ADD CONSTRAINT inscrito_estudiante_fk FOREIGN KEY ( nocarne )
        REFERENCES estudiante ( nocarne );

ALTER TABLE pensum
    ADD CONSTRAINT pensum_curso_fk FOREIGN KEY ( codigocurso )
        REFERENCES curso ( codigocurso );

ALTER TABLE pensum
    ADD CONSTRAINT pensum_plan_fk FOREIGN KEY ( plan,
                                                codigocarrera )
        REFERENCES plan ( plan,
                          codigocarrera );

ALTER TABLE plan
    ADD CONSTRAINT plan_carrera_fk FOREIGN KEY ( codigocarrera )
        REFERENCES carrera ( codigocarrera );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_curso_fk FOREIGN KEY ( codigocurso )
        REFERENCES curso ( codigocurso );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_docente_fk FOREIGN KEY ( codigodocente )
        REFERENCES docente ( codigodocente );
        