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
    descripción VARCHAR(100),
    CONSTRAINT pk_id PRIMARY KEY (id_sd)
);

CREATE TABLE marca (
    id_marca bigserial,
    tipo VARCHAR(100) NOT NULL,
    clase INTEGER NOT NULL,
    signo_distintivo INTEGER NOT NULL,

    CONSTRAINT pk_marca PRIMARY KEY (id_marca),
    CONSTRAINT fk_sd FOREIGN KEY (signo_distintivo) REFERENCES signo_distintivo(id_sd)
);

/*
TAREA: VERIFICAR QUE LEMA COMERCIAL APUNTE A SOLO UNA MARCA
*/
CREATE TABLE lema_comercial (
    numero_de_la_solicitud VARCHAR(100) NOT NULL,
    aplicar_a_la_marca VARCHAR(100) NOT NULL,
    marca INTEGER,

    CONSTRAINT fk_marca FOREIGN KEY (marca) REFERENCES marca (id_marca),
    CONSTRAINT pk_lc PRIMARY KEY (marca)
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
    nombre VARCHAR(100),

    CONSTRAINT pk_pais PRIMARY KEY (nombre)
);

CREATE TABLE prioridad_extranjera (
    número_de_prioridad VARCHAR(100) NOT NULL,
    fecha_de_prioridad DATE NOT NULL,
    país VARCHAR(100) NOT NULL,

    CONSTRAINT fk_país FOREIGN KEY (país) REFERENCES país (nombre),
    PRIMARY KEY (número_de_prioridad, país)
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
    documento_de_identificación VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),    

    CONSTRAINT pk_persona_natural PRIMARY KEY (documento_de_identificación)
);

CREATE TABLE apoderado(
    número_de_agente VARCHAR(100),
    número_de_poder VARCHAR(100),
    nombre VARCHAR(100) NOT NULL,
    documento_de_identificación VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    domicilio TEXT,
    correo_electrónico VARCHAR(320),
    fax CHAR(12),
    celular CHAR(12),
    teléfono CHAR(12),
    país_de_nacionalidad VARCHAR(100),
    país_de_domicilio VARCHAR(100),

    CONSTRAINT pk_apoderado PRIMARY KEY (número_de_agente)
);

/*
COLOCAR RESTRICCION DE QUE REPRESENTANTE LEGAL APODERADO NO DEBE SER NULO Y APUNTA A
UNA PERSONA NATURAL QUE ES APODERADO
*/
CREATE TABLE solicitante(
    id_solicitante BIGSERIAL,
    tipo VARCHAR(100),
    documento_de_identificación VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    domicilio TEXT,
    correo_electrónico VARCHAR(320),
    fax VARCHAR(100),
    celular VARCHAR(100),
    teléfono VARCHAR(100),
    num_agente VARCHAR(100),
    país_de_nacionalidad VARCHAR(100),
    país_de_domicilio VARCHAR(100),

    CONSTRAINT pk_solicitante PRIMARY KEY (id_solicitante)
);


/*
AGREGAR RESTRICCION DE TIPO_EMPRESA EN FUNCION DE TIPO_JURIDICO
*/

CREATE TABLE persona_jurídica(
    rif CHAR(12) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    razón_social VARCHAR(255) NOT NULL,
    tipo_jurídico VARCHAR(33) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    tipo_empresa VARCHAR(100) DEFAULT CONCAT('VACIO', nextval('id_seq')),
    solicitante INTEGER,
    
    CONSTRAINT fk_solicitante FOREIGN KEY (solicitante) REFERENCES solicitante (id_solicitante),
    PRIMARY KEY (rif, solicitante)
);

CREATE TABLE solicitud (
    número_de_solicitud CHAR(11) NOT NULL,
    número_de_trámite CHAR(6) NOT NULL,
    número_de_referencia CHAR(6) NOT NULL,
    fecha_solicitud DATE NOT NULL,
    taquilla_SAPI INTEGER NOT NULL,
    condición VARCHAR(100) NOT NULL DEFAULT 'en proceso',
    firma TEXT,
    prioridad_extranjera VARCHAR(100),
    país VARCHAR(100),
    marca INTEGER NOT NULL,
    solicitante INTEGER NOT NULL,

    CONSTRAINT pk_solicitud PRIMARY KEY (número_de_solicitud)
);


CREATE TABLE recaudos (
    id_recaudo BIGSERIAL,
    nombre VARCHAR(100) NOT NULL,
    CONSTRAINT pk_recaudo PRIMARY KEY (id_recaudo)
);

CREATE TABLE recaudos_solicitud(
    recaudo INTEGER REFERENCES recaudos (id_recaudo),
    solicitud CHAR(11) REFERENCES solicitud (número_de_solicitud),
    CONSTRAINT pk_recaudos_solicitud PRIMARY KEY (recaudo, solicitud)
)