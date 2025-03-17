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

CREATE TABLE marca (
    id_marca bigserial PRIMARY KEY,
    clase INTEGER NOT NULL,
    distingue TEXT,
    tipo VARCHAR(100),
    --ATRIBUTOS DE LEMA COMERCIAL
    numero_de_la_solicitud VARCHAR(100),
    aplicar_a_la_marca VARCHAR(100)
);
CREATE TABLE signo_distintivo(
    id_sd BIGSERIAL PRIMARY KEY,
    marca INTEGER NOT NULL,
    tipo VARCHAR(100),
    --TIPO MIXTO/ DENOMINATIVO
    nombre VARCHAR(100),
    imagen_correspondiente TEXT,
    --TIPO GRAFICO
    descripción TEXT
);


/*
NECESITA RESTRICCION DE NOT NULL EN FUNCION DEL TIPO DE SIGNO_DISTINTIVO
*/

/*
Verificar que solicitud apunte a un solicitante que tiene.
Agregar en el reporte que se tuvo que agregar el atributo PAIS
a la solicitud
*/


CREATE TABLE país (
    nombre VARCHAR(100) PRIMARY KEY
);

CREATE TABLE prioridad_extranjera (
    número_de_prioridad VARCHAR(100) PRIMARY KEY,
    fecha_de_prioridad DATE NOT NULL,
    país VARCHAR(100) NOT NULL
);

/*
AGREGAR CONSTRAING DE QUE LA REFERENCIA A LA MARCA DEBE SER UNICA
AGREGAR CONSTRAINT DE QUE LA REFERENCIA AL SOLICITANTE DEBE SER NO NULA
*/

--Crea secuencia de identificadores para personas naturales en caso
--de que no sea insertado un solicitante con su documento de identificación
CREATE SEQUENCE id_seq;

/*
LA LLAVE FORANEA SOLICITANTE_NATURAL DEBE SER IMPLEMENTADA UNA VEZ CREADA LA TABLA SOLICITANTE
*/

CREATE TABLE persona_natural(
    nombre VARCHAR(100) NOT NULL,
    id_persona_natural BIGSERIAL PRIMARY KEY
);

CREATE TABLE apoderado(
    número_de_agente VARCHAR(100) PRIMARY KEY,
    número_de_poder VARCHAR(100),
    fecha_de_presentacion DATE DEFAULT NULL,
    nombre VARCHAR(100) NOT NULL,
    documento_de_identificación VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    domicilio TEXT,
    correo_electrónico VARCHAR(320),
    fax CHAR(12),
    celular CHAR(12),
    teléfono CHAR(12),
    país_de_nacionalidad VARCHAR(100),
    país_de_domicilio VARCHAR(100)
);

/*
COLOCAR RESTRICCION DE QUE REPRESENTANTE LEGAL APODERADO NO DEBE SER NULO Y APUNTA A
UNA PERSONA NATURAL QUE ES APODERADO
*/
CREATE TABLE solicitante(
    id_solicitante BIGSERIAL PRIMARY KEY,
    tipo VARCHAR(100),
    documento_de_identificación VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    domicilio TEXT,
    correo_electrónico VARCHAR(320),
    fax VARCHAR(100),
    celular VARCHAR(100),
    teléfono VARCHAR(100),
    num_agente VARCHAR(100),
    país_de_nacionalidad VARCHAR(100),
    país_de_domicilio VARCHAR(100)
);


/*
AGREGAR RESTRICCION DE TIPO_EMPRESA EN FUNCION DE TIPO_JURIDICO
*/

CREATE TABLE persona_jurídica(
    id_persona_jurídica BIGSERIAL PRIMARY KEY,
    razón_social VARCHAR(255) NOT NULL,
    tipo_jurídico VARCHAR(33) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    tipo_empresa VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    solicitante INTEGER
);

CREATE TABLE solicitud (
    número_de_solicitud CHAR(11) PRIMARY KEY,
    número_de_trámite CHAR(6),
    número_de_referencia CHAR(6),
    fecha_solicitud DATE NOT NULL,
    taquilla_SAPI INTEGER,
    condición VARCHAR(100) NOT NULL DEFAULT 'en proceso',
    firma TEXT DEFAULT NULL,
    prioridad_extranjera VARCHAR(100),
    marca INTEGER NOT NULL
);

CREATE TABLE solicitud_solicitante ();

CREATE TABLE solicitud_prioridad();

CREATE TABLE recaudos (
    id_recaudo BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE recaudos_solicitud();