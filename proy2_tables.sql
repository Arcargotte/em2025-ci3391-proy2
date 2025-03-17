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


-- Creación de la tabla 'marca', que almacena información sobre las marcas registradas.
CREATE TABLE marca (
    id_marca bigserial PRIMARY KEY, -- Identificador único de la marca.
    clase INTEGER NOT NULL, -- Clase de la marca según clasificación internacional
    distingue TEXT, -- Descripción de los productos/servicios distinguidos por la marca.
    tipo VARCHAR(100), -- Tipo de marca (denominativa, gráfica, mixta, etc.).
    numero_de_la_solicitud VARCHAR(100), -- Número de solicitud asociado a la marca.
    aplicar_a_la_marca VARCHAR(100) -- Indicación de si aplica a una marca específica.
);
COMMENT ON TABLE marca IS 'Tabla que almacena la información de marcas registradas.';
COMMENT ON COLUMN marca.id_marca IS 'Identificador único de la marca.';
COMMENT ON COLUMN marca.clase IS 'Clase de la marca según la clasificación internacional de Niza.';

-- Creación de la tabla 'signo_distintivo', que almacena los diferentes tipos de signos distintivos.
CREATE TABLE signo_distintivo(
    id_sd BIGSERIAL PRIMARY KEY, 
    marca INTEGER NOT NULL, 
    tipo VARCHAR(100), 
    nombre VARCHAR(100), 
    imagen_correspondiente TEXT,    
    descripción TEXT 
);
COMMENT ON TABLE signo_distintivo IS 'Tabla que almacena información sobre signos distintivos.';
COMMENT ON COLUMN signo_distintivo.id_sd IS 'Identificador único del signo distintivo.';
COMMENT ON COLUMN signo_distintivo.marca IS 'Referencia a la marca asociada.';
COMMENT ON COLUMN signo_distintivo.tipo IS 'Tipo de signo distintivo.';
COMMENT ON COLUMN signo_distintivo.nombre IS 'Nombre del signo distintivo.';
COMMENT ON COLUMN signo_distintivo.imagen_correspondiente IS 'URL o referencia a la imagen asociada.';
COMMENT ON COLUMN signo_distintivo.descripción IS 'Descripción detallada del signo distintivo.';

-- Creación de la tabla 'país', que almacena los países utilizados en los registros.
CREATE TABLE país (
    nombre VARCHAR(100) PRIMARY KEY -- Nombre del país. Unique. no null 
);
COMMENT ON TABLE país IS 'Tabla de referencia que almacena nombres de países.';

-- Creación de la tabla 'prioridad_extranjera', que almacena información sobre prioridades extranjeras.
CREATE TABLE prioridad_extranjera (
    número_de_prioridad VARCHAR(100) PRIMARY KEY,
    fecha_de_prioridad DATE NOT NULL,
    país VARCHAR(100) NOT NULL
);
COMMENT ON TABLE prioridad_extranjera IS 'Tabla que almacena prioridades extranjeras de marcas.';



--Crea secuencia de identificadores para personas naturales en caso
--de que no sea insertado un solicitante con su documento de identificación
CREATE SEQUENCE id_seq;

-- Creación de la tabla 'persona_natural', que almacena datos de solicitantes naturales.
CREATE TABLE persona_natural(
    nombre VARCHAR(100) NOT NULL,
    id_persona_natural BIGSERIAL PRIMARY KEY
);
COMMENT ON TABLE persona_natural IS 'Tabla que almacena información de personas naturales como solicitantes de marcas.';
COMMENT ON COLUMN persona_natural.id_persona_natural IS 'Identificador único de la persona natural.';
COMMENT ON COLUMN persona_natural.nombre IS 'Nombre de la persona natural.';

-- Creación de la tabla 'apoderado', que almacena información sobre los apoderados.
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
COMMENT ON TABLE apoderado IS 'Tabla que almacena información sobre apoderados de marcas comerciales.';
COMMENT ON COLUMN apoderado.número_de_agente IS 'Número de agente del apoderado.';
COMMENT ON COLUMN apoderado.número_de_poder IS 'Número de poder del apoderado.';
COMMENT ON COLUMN apoderado.fecha_de_presentacion IS 'Fecha de presentación del apoderado.';
COMMENT ON COLUMN apoderado.nombre IS 'Nombre del apoderado.';  
COMMENT ON COLUMN apoderado.documento_de_identificación IS 'Documento de identificación del apoderado.';
COMMENT ON COLUMN apoderado.domicilio IS 'Domicilio del apoderado.';
COMMENT ON COLUMN apoderado.correo_electrónico IS 'Correo del apoderado.';
COMMENT ON COLUMN apoderado.fax IS 'Número de fax del apoderado.';
COMMENT ON COLUMN apoderado.celular IS 'Número de celular del apoderado.';
COMMENT ON COLUMN apoderado.teléfono IS 'Número de teléfono del apoderado.';

-- Creación de la tabla 'solicitante', que almacena información sobre los solicitantes de marcas comerciales.
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
COMMENT ON TABLE solicitante IS 'Tabla que almacena información sobre los solicitantes de marcas comerciales.';
COMMENT ON COLUMN solicitante.id_solicitante IS 'Identificador único del solicitante.';
COMMENT ON COLUMN solicitante.tipo IS 'Tipo de solicitante (persona natural o jurídica).';
COMMENT ON COLUMN solicitante.documento_de_identificación IS 'Documento de identificación del solicitante.';
COMMENT ON COLUMN solicitante.domicilio IS 'Domicilio del solicitante.';
COMMENT ON COLUMN solicitante.correo_electrónico IS 'Correo electrónico del solicitante.';
COMMENT ON COLUMN solicitante.fax IS 'Número de fax del solicitante.';
COMMENT ON COLUMN solicitante.celular IS 'Número de celular del solicitante.';
COMMENT ON COLUMN solicitante.teléfono IS 'Número de teléfono del solicitante.';
COMMENT ON COLUMN solicitante.num_agente IS 'Número de agente del solicitante.';
COMMENT ON COLUMN solicitante.país_de_nacionalidad IS 'País de nacionalidad del solicitante.';
COMMENT ON COLUMN solicitante.país_de_domicilio IS 'País de domicilio del solicitante.';


-- Creación de la tabla 'persona_jurídica', que almacena datos de solicitantes jurídicos.
CREATE TABLE persona_jurídica(
    id_persona_jurídica BIGSERIAL PRIMARY KEY,
    razón_social VARCHAR(255) NOT NULL,
    tipo_jurídico VARCHAR(33) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    tipo_empresa VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    solicitante INTEGER
);
COMMENT ON TABLE persona_jurídica IS 'Tabla que almacena información sobre personas jurídicas registradas como solicitantes.';
COMMENT ON COLUMN persona_jurídica.id_persona_jurídica IS 'Identificador único de la persona jurídica.';
COMMENT ON COLUMN persona_jurídica.razón_social IS 'Razón social de la persona jurídica.';
COMMENT ON COLUMN persona_jurídica.tipo_jurídico IS 'Tipo jurídico de la persona jurídica.';
COMMENT ON COLUMN persona_jurídica.tipo_empresa IS 'Tipo de empresa de la persona jurídica.';
COMMENT ON COLUMN persona_jurídica.solicitante IS 'Referencia al solicitante asociado.';

-- Creación de la tabla 'solicitud', que almacena información sobre las solicitudes de marcas.
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
COMMENT ON TABLE solicitud IS 'Tabla que almacena las solicitudes de marcas registradas en el sistema.';
COMMENT ON COLUMN solicitud.número_de_solicitud IS 'Número de solicitud de la marca.';
COMMENT ON COLUMN solicitud.número_de_trámite IS 'Número de trámite de la solicitud.';
COMMENT ON COLUMN solicitud.número_de_referencia IS 'Número de referencia de la solicitud.';
COMMENT ON COLUMN solicitud.fecha_solicitud IS 'Fecha de solicitud de la marca.';
COMMENT ON COLUMN solicitud.taquilla_SAPI IS 'Número de taquilla de la solicitud.';
COMMENT ON COLUMN solicitud.condición IS 'Condición de la solicitud.';
COMMENT ON COLUMN solicitud.firma IS 'Firma de la solicitud.';
COMMENT ON COLUMN solicitud.prioridad_extranjera IS 'Prioridad extranjera asociada a la solicitud.';
COMMENT ON COLUMN solicitud.marca IS 'Referencia a la marca asociada.';

CREATE TABLE solicitud_solicitante ();

CREATE TABLE solicitud_prioridad();

-- Creación de la tabla 'recaudos', que almacena los documentos requeridos para las solicitudes.
CREATE TABLE recaudos (
    id_recaudo BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
COMMENT ON TABLE recaudos IS 'Tabla que almacena los recaudos necesarios para solicitudes de marcas.';
COMMENT ON COLUMN recaudos.id_recaudo IS 'Identificador único del recaudo.';
COMMENT ON COLUMN recaudos.nombre IS 'Nombre del recaudo.';

CREATE TABLE recaudos_solicitud();