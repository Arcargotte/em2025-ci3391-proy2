DROP SCHEMA IF EXISTS proy2 CASCADE;
REVOKE ALL PRIVILEGES ON DATABASE postgres FROM proy2;
DROP USER proy2;
CREATE USER proy2 WITH PASSWORD 'proy2';

CREATE SCHEMA proy2 AUTHORIZATION proy2;
ALTER ROLE proy2 SET search_path TO proy2;
GRANT ALL PRIVILEGES ON SCHEMA proy2 TO proy2;
GRANT CREATE ON SCHEMA proy2 TO proy2;

SET ROLE proy2;

CREATE TABLE SOLICITUD (
    numero_de_solicitud CHAR(11),
    numero_de_trámite CHAR(6),
    numero_de_referencia CHAR(6),
    fecha_solicitud DATE,
    taquilla_SAPI INTEGER,
    condicion INTEGER,
    firma TEXT
);

CREATE TABLE SOLICITANTE (
    tipo VARCHAR(8),
    domicilio  TEXT,
    correo-electronico VARCHAR(320),
    fax TEXT,
    celular CHAR(12),
    telefono CHAR(12)
);

CREATE TABLE PERSONA_JURIDICA (
    rif: CHAR(12),
    tipo-juridico:  VARCHAR(33),
    razon-social: VARCHAR(255)
);

-- CREATE TABLE PÚBLICA (
--     tipo: TEXT,
-- )

-- CREATE TABLE ASOCIACION_DE_PROPIEDAD_COLECTIVA (
--     tipo TEXT,
-- )

-- CREATE TABLE PRIVADA (
--     tipo TEXT,
-- )

-- CREATE TABLE PERSONA_NATURAL (
--     nombre TEXT,
--     documento-de-identificacion TEXT
-- );

-- CREATE TABLE APODERADO (
--     es_apoderado BOOLEAN,
--     numero_de_agente INTEGER,
--     numero_de_poder VARCHAR,
--     fecha-de-presentacion DATE,
--     correlativo INTEGER
-- );

-- CREATE TABLE PRIORIDAD_EXTRANJERA (
--     numero-de-prioridad INTEGER,
--     fecha-de-prioridad DATE,
--     pais-origen TEXT REFERENCES PAIS(nombre),
--     CONSTRAINT pais-origen PRIMARY KEY,
--     CONSTRAINT numero-de-prioridad PRIMARY KEY
-- );

-- CREATE TABLE PAIS (
--     nombre TEXT
-- );

-- CREATE TABLE RECAUDOS (
--     tipo TEXT,
-- );

-- CREATE TABLE MARCA (
--     nombre TEXT
-- );

-- CREATE TABLE LEMA_COMERCIAL (
--     nombre TEXT
-- );

-- CREATE TABLE SIGNO_DISTINTIVO (
--     nombre TEXT
-- );

-- CREATE TABLE MIXTO(
--     nombre TEXT
    
-- );
-- CREATE TABLE DENOMINATIVO(
--     nombre TEXT
    
-- );
-- CREATE TABLE GRAFICO(
--     nombre TEXT
-- );