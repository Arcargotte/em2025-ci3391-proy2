/*
Verifica si el esquema y el usuario proy2 ya existe en la base de datos. 
Si existe, los elimina. En caso contrario, los crea.
*/

--Borra el esquema y sus dependencias y el usuario de la base de datos.
DROP SCHEMA IF EXISTS proy2 CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM proy2;
DROP USER proy2;
--Crea el usuario con la contraseña proy2 y el esquema dandole autorizacion a proy2.
CREATE USER proy2 WITH PASSWORD 'proy2';
CREATE SCHEMA proy2 AUTHORIZATION proy2;
ALTER ROLE proy2 SET search_path TO proy2;
GRANT ALL PRIVILEGES ON SCHEMA proy2 TO proy2;

--Otorga permisos de creacion al esquema proy2 al usuario proy2.
GRANT CREATE ON SCHEMA proy2 TO proy2;

--Cambia al usuario proy2 desde el usuario que inicio la instancia de psql.
SET ROLE proy2;

/*
Son creadas las tablas especificadas según el esquema de la base de datos.
*/

--Crea secuencia de identificadores para personas naturales en caso
--de que no sea insertado un solicitante con su documento de identificación
CREATE SEQUENCE persona_natural_cdi_seq;


/*
Agregar restriccion de que un apoderado siempre debe hacer referencia a una persona natural
*/

/*
ESCRIBIR EN EL INFORME EL CAMBIO DEL ESQUEMA A UNA RELACION RECURSIVA ENTRE PERSONA
NATURAL Y APODERADO DEBIDO A LIMITACIONES LOGICAS
*/


/*
AGREGAR RESTRICCION DE QUE SOLO UNA MARCA PUEDE APUNTAR A UN MISMO SIGNO DISTINTIVO
*/

CREATE TABLE signo_distintivo(
    id_sd BIGSERIAL,
    tipo VARCHAR(100),
    --TIPO MIXTO/ DENOMINATIVO
    nombre VARCHAR(100),
    imagen_correspondiente TEXT,
    --TIPO GRAFICO
    descripcion VARCHAR(100),
    CONSTRAINT pk_id PRIMARY KEY (id_sd)
);

CREATE TABLE marca (
    id_marca bigserial,
    tipo VARCHAR(100) NOT NULL,
    clase INTEGER NOT NULL,
    fk_sd INTEGER NOT NULL,

    CONSTRAINT pk_marca PRIMARY KEY (id_marca),
    CONSTRAINT fk_sd FOREIGN KEY (fk_sd) REFERENCES signo_distintivo(id_sd)
);

/*
TAREA: VERIFICAR QUE LEMA COMERCIAL APUNTE A SOLO UNA MARCA
*/
CREATE TABLE lema_comercial (
    numero_de_la_solicitud VARCHAR(100) NOT NULL,
    aplicar_a_la_marca VARCHAR(100) NOT NULL,
    fk_marca INTEGER,

    CONSTRAINT fk_marca FOREIGN KEY (fk_marca) REFERENCES marca (id_marca),
    CONSTRAINT pk_lc PRIMARY KEY (fk_marca)
);

/*
NECESITA RESTRICCION DE NOT NULL EN FUNCION DEL TIPO DE SIGNO_DISTINTIVO
*/

/*
Verificar que solicitud apunte a un solicitante que tiene.
Agregar en el reporte que se tuvo que agregar el atributo PAIS
a la solicitud
*/


CREATE TABLE pais (
    nombre VARCHAR(100),

    CONSTRAINT pk_pais PRIMARY KEY (nombre)
);

CREATE TABLE prioridad_extranjera (
    numero_de_prioridad VARCHAR(100) NOT NULL,
    fecha_de_prioridad DATE NOT NULL,
    fk_pais CHAR(11) NOT NULL,

    CONSTRAINT fk_pais FOREIGN KEY (fk_pais) REFERENCES pais (nombre),
    PRIMARY KEY (numero_de_prioridad, fk_pais)
);

/*
AGREGAR CONSTRAING DE QUE LA REFERENCIA A LA MARCA DEBE SER UNICA
AGREGAR CONSTRAINT DE QUE LA REFERENCIA AL SOLICITANTE DEBE SER NO NULA
*/

/*
LA LLAVE FORANEA SOLICITANTE_NATURAL DEBE SER IMPLEMENTADA UNA VEZ CREADA LA TABLA SOLICITANTE
*/

CREATE TABLE persona_natural(
    nombre VARCHAR(100) NOT NULL,
    documento_de_identificacion VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('persona_natural_cdi_seq')),    
    es_apoderado BOOLEAN NOT NULL,
    fk_poderdante VARCHAR(100),
    numero_de_agente INTEGER,
    numero_de_poder VARCHAR(100),
    fecha_de_presentacion DATE,
    correlativo INTEGER,

    CONSTRAINT pk_persona_natural PRIMARY KEY (documento_de_identificacion)
);


/*
COLOCAR RESTRICCION DE QUE REPRESENTANTE LEGAL APODERADO NO DEBE SER NULO Y APUNTA A
UNA PERSONA NATURAL QUE ES APODERADO
*/
CREATE TABLE solicitante(
    id_solicitante BIGSERIAL,
    domicilio TEXT NOT NULL,
    correo_electronico VARCHAR(320) NOT NULL,
    fax CHAR(12),
    celular CHAR(12) NOT NULL,
    telefono CHAR(12) NOT NULL,
    fk_apoderado VARCHAR(100) NOT NULL,
    fk_nacionalidad VARCHAR(100) NOT NULL,

    CONSTRAINT pk_solicitante PRIMARY KEY (id_solicitante)
);

--Crea secuencia de identificadores para personas naturales en caso
--de que no sea insertado un solicitante con su documento de identificación
CREATE SEQUENCE persona_juridica_cdi_seq;

CREATE SEQUENCE no_def_publica_seq;

/*
AGREGAR RESTRICCION DE TIPO_EMPRESA EN FUNCION DE TIPO_JURIDICO
*/

CREATE TABLE persona_juridica(
    rif CHAR(12) DEFAULT CONCAT('VACIO', nextval('persona_juridica_cdi_seq')),
    razon_social VARCHAR(255) NOT NULL,
    tipo_juridico VARCHAR(33) NOT NULL,
    tipo_empresa VARCHAR(100) DEFAULT CONCAT('NODEF', nextval('no_def_publica_seq')),
    fk_solicitante INTEGER,
    
    CONSTRAINT fk_solicitante FOREIGN KEY (fk_solicitante) REFERENCES solicitante (id_solicitante),
    PRIMARY KEY (rif, fk_solicitante)
);

CREATE TABLE solicitud (
    numero_de_solicitud CHAR(11) NOT NULL,
    numero_de_tramite CHAR(6) NOT NULL,
    numero_de_referencia CHAR(6) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    taquilla_SAPI INTEGER NOT NULL,
    condicion VARCHAR(100) NOT NULL DEFAULT 'en proceso',
    firma TEXT,
    prioridad_extranjera VARCHAR(100),
    pais VARCHAR(100),
    fk_marca INTEGER NOT NULL,
    fk_solicitante INTEGER NOT NULL,

    CONSTRAINT pk_solicitud PRIMARY KEY (numero_de_solicitud)
);


CREATE TABLE recaudos (
    id_recaudo BIGSERIAL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pk_recaudo PRIMARY KEY (id_recaudo)
);

CREATE TABLE recaudos_solicitud(
    fk_recaudo INTEGER REFERENCES recaudos (id_recaudo),
    fk_solicitud CHAR(11) REFERENCES solicitud (numero_de_solicitud),
    CONSTRAINT pk_recaudos_solicitud PRIMARY KEY (fk_recaudo, fk_solicitud)
)