--Cambia al usuario proy2 desde el usuario que inicio la instancia de psql.
--Se asegura de que sea el usuario proy2 el que manipule el esquema.
SET ROLE proy2;

/*
Agrega las restricciones sobre las claves foráneas y valores de los atributos 
definidas en el esquema de la base de datos e implementadas en el script
proy2_tables.sql.
*/


ALTER TABLE prioridad_extranjera
ADD CONSTRAINT fk_país FOREIGN KEY (país) REFERENCES país (nombre);

ALTER TABLE solicitud
ADD CONSTRAINT chk_numero_de_tramite CHECK (número_de_trámite ~ '^[0-9]{6}$'),
ADD CONSTRAINT chk_numero_de_referencia CHECK (número_de_referencia ~ '^[0-9]{6}$'),
ADD CONSTRAINT chk_condicion CHECK (condición IN ('en proceso', 'rechazada', 'aprobada')),
ADD CONSTRAINT fk_prioridad_extranjera FOREIGN KEY (prioridad_extranjera)
    REFERENCES prioridad_extranjera (número_de_prioridad),
ADD CONSTRAINT fk_marca FOREIGN KEY (marca) REFERENCES marca (id_marca);

ALTER TABLE solicitante
ADD CONSTRAINT fk_apoderado 
    FOREIGN KEY (num_agente) REFERENCES apoderado (número_de_agente),
ADD CONSTRAINT fk_nacionalidad 
    FOREIGN KEY (país_de_nacionalidad) REFERENCES país (nombre),
ADD CONSTRAINT fk_país_domicilio
    FOREIGN KEY (país_de_domicilio) REFERENCES país (nombre);


/*
Agrega las llaves foráneas a persona_natural y las siguientes restricciones:

1. Documento de identificación debe ser de la forma v-*... o V-*...
2. Correo electrónico debe ser de la forma %@%
3. Si instancia de persona natural es apoderado, entonces debe tener a un poderdante.
4. Agrega llave foránea a solicitud, pues no se podía crear en el script proy2_tables.sql
debido al orden de definición de las tablas.

*/

ALTER TABLE persona_natural
ADD COLUMN solicitante INTEGER,
ADD CONSTRAINT fk_solicitante FOREIGN KEY (solicitante) 
    REFERENCES solicitante (id_solicitante);

ALTER TABLE apoderado
ADD CONSTRAINT fk_país_domicilio FOREIGN KEY (país_de_domicilio) REFERENCES país(nombre),
ADD CONSTRAINT fk_país_nacionalidad FOREIGN KEY (país_de_nacionalidad) REFERENCES país(nombre);

/*
Agrega las llaves foráneas a persona_juridica y las siguientes restricciones:

1. Documento de identificación debe ser de la forma ^[c,C,e,E,g,G,j,J,p,P,v,V]-[0-9]*$
2. Si tipo_juridico es publico, privado o asociación de propiedad colectiva, tipo_empresa debe ser el string especificado
en determinado conjunto

*/

ALTER TABLE persona_jurídica
ADD CONSTRAINT chk_tipo_juridico CHECK(
    tipo_jurídico ~* 'PÚBLICO' OR
    tipo_jurídico ~* 'PUBLICO' OR
    tipo_jurídico ~* 'PRIVADO' OR
    tipo_jurídico ~* 'ASOCIACIÓN DE PROPIEDAD COLECTIVA' OR
    tipo_jurídico ~* 'ASOCIACION DE PROPIEDAD COLECTIVA' OR
    tipo_jurídico ~ '^VACIO*'
),
ADD CONSTRAINT chk_tipo_empresa CHECK(
    tipo_empresa ~* 'publico' AND tipo_empresa IN (
        'estatal', 
        'mixta 51% o más', 
        'mixta 50% o menos'
        ) OR
    tipo_empresa ~* 'privado' AND tipo_empresa IN (
        'nacional', 
        'extranjera') OR
    tipo_empresa ~* 'asociacion de propiedad colectiva' AND tipo_empresa IN (
        'empresa de propiedad social directa comunal', 
        'cooperativa', 
        'empresa de propiedad social indirecta comunal', 
        'consejo comunal',
        'unidad productiva familiar', 
        'comuna',
        'conglomerado',
        'grupo de intercambio solidario') OR
    tipo_empresa ~ '^VACIO*'
),
ADD CONSTRAINT fk_solicitante FOREIGN KEY (solicitante) REFERENCES solicitante (id_solicitante);

ALTER TABLE solicitud_solicitante
ADD COLUMN fk_solicitud CHAR(11) REFERENCES solicitud (número_de_solicitud),
ADD COLUMN fk_solicitante INTEGER REFERENCES solicitante (id_solicitante),
ADD CONSTRAINT pk_solicitud_solicitante PRIMARY KEY (fk_solicitud, fk_solicitante);


/*
A PESAR DE QUE EN EL ESQUEMA DE BASE DE DATOS RESTRINGIMOS
LOS VALORES DE LOS ATRIBUTOS TIPO EN PUBLICO, TENEMOS LA LIMITACION
DE QUE EN EL ARCHIVO EXCEL ESTE ATRIBUTO NO PUEDE SER NULO
*/

ALTER TABLE marca
ADD CONSTRAINT chk_tipo_marca CHECK (
    tipo IN ('MP','NC','MS', 'DC', 'MC','DO','LC')
),
ADD CONSTRAINT chk_clase_internacional CHECK (
    clase >= 0 OR clase <= 47
),
ADD CONSTRAINT chk_lema_comercial CHECK(
    numero_de_la_solicitud is NULL OR aplicar_a_la_marca is NULL OR tipo != 'LC' --Verifica que si el tipo de marca no es LC, entonces el numero de solicitud y aplicar a la marca son NULL
);

ALTER TABLE signo_distintivo
ADD CONSTRAINT chk_tipo_sd CHECK (tipo IN ('denominativa', 'mixta', 'grafica')),
ADD CONSTRAINT marca_sd_unique UNIQUE (id_sd, marca),
ADD CONSTRAINT chk_sd_denominativo CHECK(
    imagen_correspondiente is NULL OR descripción is NULL OR tipo != 'denominativo' --Verifica que si el signo distintivo es denominativo, entonces atributos descripción e imagen son NULL
),
ADD CONSTRAINT fk_sd FOREIGN KEY (marca) REFERENCES marca(id_marca)
;

ALTER TABLE recaudos_solicitud
ADD COLUMN recaudo INTEGER REFERENCES recaudos (id_recaudo),
ADD COLUMN solicitud CHAR(11) REFERENCES solicitud (número_de_solicitud),
ADD CONSTRAINT pk_recaudos_solicitud PRIMARY KEY (recaudo, solicitud);

ALTER TABLE solicitud_prioridad
ADD COLUMN solicitud CHAR(11) REFERENCES solicitud (número_de_solicitud),
ADD COLUMN prioridad VARCHAR(100) REFERENCES prioridad_extranjera (número_de_prioridad),
ADD CONSTRAINT pk_solicitud_prioridad PRIMARY KEY (solicitud, prioridad);