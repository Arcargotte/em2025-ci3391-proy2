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
    numero_de_solicitud CHAR(11) NOT NULL,
    numero_de_tramite CHAR(6) NOT NULL,
    numero_de_referencia CHAR(6) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    taquilla_SAPI INTEGER NOT NULL,
    condicion INTEGER NOT NULL,
    firma TEXT,
    CONSTRAINT solicitud_key PRIMARY KEY (numero_de_solicitud)
);

COMMENT ON TABLE solicitud IS '';
COMMENT ON COLUMN solicitud.numero_de_solicitud IS '';
COMMENT ON COLUMN solicitud.numero_de_tramite IS '';
COMMENT ON COLUMN solicitud.fecha_solicitud IS '';
COMMENT ON COLUMN solicitud.taquilla_SAPI IS '';
COMMENT ON COLUMN solicitud.condicion IS '';
COMMENT ON COLUMN solicitud.firma IS '';

--Crea secuencia de identificadores para personas naturales en caso
--de que no sea insertado un solicitante con su documento de identificación
CREATE SEQUENCE persona_natural_cdi_seq;

CREATE TABLE persona_natural(
    tipo VARCHAR(8) NOT NULL,
    domicilio TEXT NOT NULL,
    correo_electronico VARCHAR(320) NOT NULL,
    fax CHAR(12),
    celular CHAR(12) NOT NULL,
    telefono CHAR(12) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    documento_de_identificacion VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('persona_natural_cdi_seq')),
    CONSTRAINT persona_natural_key PRIMARY KEY (documento_de_identificacion)
);

COMMENT ON TABLE persona_natural IS '';
COMMENT ON COLUMN persona_natural.tipo IS '';
COMMENT ON COLUMN persona_natural.domicilio IS '';
COMMENT ON COLUMN persona_natural.correo_electronico IS '';
COMMENT ON COLUMN persona_natural.fax IS '';
COMMENT ON COLUMN persona_natural.celular IS '';
COMMENT ON COLUMN persona_natural.telefono IS '';
COMMENT ON COLUMN persona_natural.nombre IS '';
COMMENT ON COLUMN persona_natural.documento_de_identificacion IS '';

--Crea secuencia de identificadores para personas naturales en caso
--de que no sea insertado un solicitante con su documento de identificación
CREATE SEQUENCE persona_juridica_cdi_seq;

CREATE TABLE persona_juridica(
    tipo VARCHAR(8) NOT NULL,
    domicilio TEXT NOT NULL,
    correo_electronico VARCHAR(320) NOT NULL,
    fax CHAR(12),
    celular CHAR(12) NOT NULL,
    telefono CHAR(12) NOT NULL,
    rif CHAR(12) DEFAULT CONCAT('VACIO', nextval('persona_juridica_cdi_seq')),
    tipo_juridico VARCHAR(33) NOT NULL,
    razon_social VARCHAR(255) NOT NULL,
    CONSTRAINT persona_juridica_key PRIMARY KEY (rif)
);

COMMENT ON TABLE persona_juridica IS '';
COMMENT ON COLUMN persona_juridica.tipo IS '';
COMMENT ON COLUMN persona_juridica.domicilio IS '';
COMMENT ON COLUMN persona_juridica.correo_electronico IS '';
COMMENT ON COLUMN persona_juridica.fax IS '';
COMMENT ON COLUMN persona_juridica.celular IS '';
COMMENT ON COLUMN persona_juridica.telefono IS '';
COMMENT ON COLUMN persona_juridica.rif IS '';
COMMENT ON COLUMN persona_juridica.tipo_juridico IS '';
COMMENT ON COLUMN persona_juridica.razon_social IS '';

CREATE SEQUENCE no_def_publica_seq;

CREATE TABLE publica (
    tipo VARCHAR(17) DEFAULT CONCAT('NODEF', nextval('no_def_publica_seq')),
    id_publica CHAR(12) REFERENCES persona_juridica (rif),
    CONSTRAINT publica_key PRIMARY KEY (id_publica)
);

COMMENT ON TABLE publica IS '';
COMMENT ON COLUMN publica.tipo IS '';
COMMENT ON COLUMN publica.id_publica IS '';

CREATE TABLE asociacion_de_propiedad_colectiva (
    tipo VARCHAR(44) DEFAULT CONCAT('NODEF', nextval('no_def_publica_seq')),
    id_apc CHAR(12) REFERENCES persona_juridica (rif),
    CONSTRAINT apc_key PRIMARY KEY (id_apc)
);

COMMENT ON TABLE asociacion_de_propiedad_colectiva IS '';
COMMENT ON COLUMN asociacion_de_propiedad_colectiva.tipo IS '';
COMMENT ON COLUMN asociacion_de_propiedad_colectiva.id_apc IS '';

CREATE TABLE privada (
    tipo VARCHAR(10) DEFAULT CONCAT('NODEF', nextval('no_def_publica_seq')),
    id_privada CHAR(12) REFERENCES persona_juridica (rif),
    CONSTRAINT privada_key PRIMARY KEY (id_privada)
);

COMMENT ON TABLE privada IS '';
COMMENT ON COLUMN privada.tipo IS '';
COMMENT ON COLUMN privada.id_privada IS '';

CREATE TABLE apoderado (
    es_apoderado BOOLEAN NOT NULL,
    numero_de_agente INTEGER,
    numero_de_poder VARCHAR(100),
    fecha_de_presentacion DATE,
    correlativo INTEGER,
    id_apoderado VARCHAR(100) REFERENCES persona_natural (documento_de_identificacion),
    CONSTRAINT apoderado_key PRIMARY KEY (id_apoderado)
);

COMMENT ON TABLE apoderado IS '';
COMMENT ON COLUMN apoderado.es_apoderado IS '';
COMMENT ON COLUMN apoderado.numero_de_agente IS '';
COMMENT ON COLUMN apoderado.numero_de_poder IS '';
COMMENT ON COLUMN apoderado.fecha_de_presentacion IS '';
COMMENT ON COLUMN apoderado.correlativo IS '';

CREATE TABLE prioridad_extranjera (
    numero_de_prioridad INTEGER,
    fecha_de_prioridad DATE NOT NULL,
    fk_solicitud CHAR(11) REFERENCES solicitud (numero_de_solicitud),
    PRIMARY KEY (numero_de_prioridad, fk_solicitud)
);

COMMENT ON TABLE prioridad_extranjera IS '';
COMMENT ON COLUMN prioridad_extranjera.numero_de_prioridad IS '';
COMMENT ON COLUMN prioridad_extranjera.fecha_de_prioridad IS '';

CREATE TABLE pais (
    nombre VARCHAR(100),
    CONSTRAINT pais_key PRIMARY KEY (nombre)
);

COMMENT ON TABLE pais IS '';
COMMENT ON COLUMN pais.nombre IS '';

CREATE TABLE recaudos (
    id_recaudo BIGSERIAL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT recaudos_key PRIMARY KEY (id_recaudo)
);

COMMENT ON TABLE recaudos IS '';
COMMENT ON COLUMN recaudos.id_recaudo IS '';
COMMENT ON COLUMN recaudos.nombre IS '';

CREATE TABLE marca (
    id_marca bigserial,
    tipo VARCHAR(100) NOT NULL,
    clase INTEGER NOT NULL,
    CONSTRAINT marca_key PRIMARY KEY (id_marca)
);

COMMENT ON TABLE marca IS '';
COMMENT ON COLUMN marca.id_marca IS '';
COMMENT ON COLUMN marca.tipo IS '';
COMMENT ON COLUMN marca.clase IS '';

CREATE TABLE lema_comercial (
    numero_de_la_solicitud VARCHAR(100) NOT NULL,
    aplicar_a_la_marca VARCHAR(100) NOT NULL,
    marca_id INTEGER REFERENCES marca (id_marca),
    CONSTRAINT lema_comercial_key PRIMARY KEY (marca_id)
);

COMMENT ON TABLE lema_comercial IS '';
COMMENT ON COLUMN lema_comercial.numero_de_la_solicitud IS '';
COMMENT ON COLUMN lema_comercial.aplicar_a_la_marca IS '';
COMMENT ON COLUMN lema_comercial.marca_id IS '';

CREATE TABLE mixto(
    tipo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100),
    imagen_correspondiente TEXT NOT NULL,
    CONSTRAINT mixto_key PRIMARY KEY (descripcion)
);

COMMENT ON TABLE mixto IS '';
COMMENT ON COLUMN mixto.tipo IS '';
COMMENT ON COLUMN mixto.descripcion IS '';
COMMENT ON COLUMN mixto.imagen_correspondiente IS '';

CREATE TABLE denominativo(
    tipo VARCHAR(100) NOT NULL,
    nombre VARCHAR(100),
    CONSTRAINT denominativo_key PRIMARY KEY (nombre)
);

COMMENT ON TABLE denominativo IS '';
COMMENT ON COLUMN denominativo.tipo IS '';
COMMENT ON COLUMN denominativo.nombre IS '';

CREATE TABLE grafico(
    tipo VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100),
    imagen_correspondiente TEXT NOT NULL,
    CONSTRAINT grafico_key PRIMARY KEY (descripcion)
);

COMMENT ON TABLE grafico IS '';
COMMENT ON COLUMN grafico.tipo IS '';
COMMENT ON COLUMN grafico.descripcion IS '';
COMMENT ON COLUMN grafico.imagen_correspondiente IS '';