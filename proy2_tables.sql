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
CREATE TABLE solicitud (
    numero_de_solicitud CHAR(11),
    numero_de_trámite CHAR(6),
    numero_de_referencia CHAR(6),
    fecha_solicitud DATE,
    taquilla_SAPI INTEGER,
    condicion INTEGER,
    firma TEXT,
    CONSTRAINT solicitud_key PRIMARY KEY (numero_de_solicitud)


);

CREATE TABLE solicitante (
    tipo VARCHAR(8),
    domicilio  TEXT,
    correo_electronico VARCHAR(320),
    fax CHAR(12),
    celular CHAR(12),
    telefono CHAR(12),
    CONSTRAINT solicitante_key PRIMARY KEY (tipo)
);

CREATE TABLE persona_juridica (
    rif CHAR(12),
    tipo_juridico  VARCHAR(33),
    razon_social VARCHAR(255),
    CONSTRAINT persona_juridica_key PRIMARY KEY (rif)
);

CREATE TABLE publica (
    tipo VARCHAR(17)
);

CREATE TABLE asociacion_de_propiedad_colectiva (
    tipo VARCHAR(44)
);

CREATE TABLE privada (
    tipo VARCHAR(10)
);

CREATE TABLE persona_natural (
    nombre VARCHAR(100),
    documento_de_identificacion VARCHAR(100),
    CONSTRAINT persona_natural_key PRIMARY KEY (documento_de_identificacion)
);

CREATE TABLE apoderado (
    es_apoderado BOOLEAN,
    numero_de_agente INTEGER,
    numero_de_poder VARCHAR(100),
    fecha_de_presentacion DATE,
    correlativo INTEGER
);

CREATE TABLE prioridad_extranjera (
    numero_de_prioridad INTEGER,
    fecha_de_prioridad DATE,
    CONSTRAINT prioridad_extranjera_key PRIMARY KEY (numero_de_prioridad)
);

CREATE TABLE pais (
    nombre VARCHAR(100),
    CONSTRAINT pais_key PRIMARY KEY (nombre)
);

CREATE TABLE recaudos (
    nombre VARCHAR(100)
);

CREATE TABLE marca (
    tipo VARCHAR(100),
    clase INTEGER,
    CONSTRAINT marca_key PRIMARY KEY (tipo)
);

CREATE TABLE lema_comercial (
    numero_de_la_solicitud VARCHAR(100),
    aplicar_a_la_marca VARCHAR(100)
);

CREATE TABLE signo_distintivo (
    tipo VARCHAR(100),
    CONSTRAINT signo_distintivo_key PRIMARY KEY (tipo)
);

CREATE TABLE mixto(
    descripcion VARCHAR(100),
    imagen_correspondiente TEXT,
    CONSTRAINT mixto_key PRIMARY KEY (descripcion)
);
CREATE TABLE denominativo(
    nombre VARCHAR(100),
    CONSTRAINT denominativo_key PRIMARY KEY (nombre)
);
CREATE TABLE grafico(
    descripcion VARCHAR(100),
    imagen_correspondiente TEXT,
    CONSTRAINT grafico_key PRIMARY KEY (descripcion)
);