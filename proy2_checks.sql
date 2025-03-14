--Cambia al usuario proy2 desde el usuario que inicio la instancia de psql.
--Se asegura de que sea el usuario proy2 el que manipule el esquema.
SET ROLE proy2;

/*
Agrega las restricciones sobre las claves foráneas y valores de los atributos 
definidas en el esquema de la base de datos e implementadas en el script
proy2_tables.sql.
*/

ALTER TABLE solicitud
ADD CONSTRAINT chk_numero_de_tramite CHECK numero_de_tramite LIKE '^[0-9]{6}$',
ADD CONSTRAINT chk_numero_de_referencia CHECK numero_de_referencia LIKE '^[0-9]{6}$',
ADD CONSTRAINT chk_condicion CHECK condicion IN 'en proceso, rechazada, aprobada',
ADD CONSTRAINT fk_prioridad_extranjera FOREIGN KEY (prioridad_extranjera, pais)
    REFERENCES prioridad_extranjera (numero_de_prioridad, fk_pais),

ADD CONSTRAINT fk_marca INTEGER NOT NULL REFERENCES fk_marca (id_marca),
ADD CONSTRAINT fk_solicitante INTEGER NOT NULL REFERENCES solicitante (id_solicitante)

ALTER TABLE solicitante
ADD CONSTRAINT fk_apoderado 
    FOREIGN KEY fk_apoderado REFERENCES persona_natural (documento_de_identificacion),
ADD CONSTRAINT fk_nacionalidad 
    FOREIGN KEY fk_nacionalidad REFERENCES pais (nombre)

/*
Agrega las llaves foráneas a persona_natural y las siguientes restricciones:

1. Documento de identificación debe ser de la forma v-*... o V-*...
2. Correo electrónico debe ser de la forma %@%
3. Si instancia de persona natural es apoderado, entonces debe tener a un poderdante.

*/

ALTER TABLE persona_natural
ADD COLUMN fk_poderdante VARCHAR(100) REFERENCES persona_natural (documento_de_identificacion),
ADD COLUMN fk_solicitante INTEGER REFERENCES solicitante (id_solicitante),
ADD CONSTRAINT chk_documento_de_identificacion CHECK documento_de_identificacion LIKE '^[v,V,e,E,p,P]-[0-9]*$',
ADD CONSTRAINT chk_correo_electronico CHECK correo_electronico LIKE '%@%.%',
ADD CONSTRAINT chk_es_apoderado CHECK (es_apoderado IS 'false' OR es_apoderado IS 'true'),
ADD CONSTRAINT chk_apoderado_representa CHECK (es_apoderado IS 'false' AND fk_poderdante IS NULL);

/*
Agrega las llaves foráneas a persona_juridica y las siguientes restricciones:

1. Documento de identificación debe ser de la forma ^[c,C,e,E,g,G,j,J,p,P,v,V]-[0-9]*$
2. Si tipo_juridico es publico, privado o asociación de propiedad colectiva, tipo_empresa debe ser el string especificado
en determinado conjunto

*/

ALTER TABLE persona_juridica
ADD CONSTRAINT chk_rif CHECK rif LIKE '^[c,C,e,E,g,G,j,J,p,P,v,V]-[0-9]*$',
ADD CONSTRAINT chk_tipo_juridico CHECK(
    tipo_juridico ILIKE 'PÚBLICO' OR
    tipo_juridico ILIKE 'PUBLICO' OR
    tipo_juridico ILIKE 'PRIVADO' OR
    tipo_juridico ILIKE 'ASOCIACIÓN DE PROPIEDAD COLECTIVA' OR
    tipo_juridico ILIKE 'ASOCIACION DE PROPIEDAD COLECTIVA' OR
),
ADD CONSTRAINT chk_tipo_empresa CHECK(
    tipo_juridico ILIKE 'PUBLICO' AND tipo_empresa in (
        'estatal', 
        'mixta 51% o más', 
        'mixta 50% o menos'
        ) OR
    tipo_juridico ILIKE 'PRIVADO' AND tipo_empresa in (
        'nacional', 
        'extranjera') OR
    tipo_juridico ILIKE 'ASOCIACIÓN DE PROPIEDAD COLECTIVA' AND tipo_empresa in (
        'empresa de propiedad social directa comunal', 
        'cooperativa', 
        'empresa de propiedad social indirecta comunal', 
        'consejo comunal',
        'unidad productiva familiar', 
        'comuna',
        'conglomerado',
        'grupo de intercambio solidario')
);

/*
A PESAR DE QUE EN EL ESQUEMA DE BASE DE DATOS RESTRINGIMOS
LOS VALORES DE LOS ATRIBUTOS TIPO EN PUBLICO, TENEMOS LA LIMITACION
DE QUE EN EL ARCHIVO EXCEL ESTE ATRIBUTO NO PUEDE SER NULO
*/

ALTER TABLE prioridad_extranjera
ADD CONSTRAINT CHECK;

ALTER TABLE pais
ADD CONSTRAINT CHECK;

ALTER TABLE recaudos
ADD CONSTRAINT CHECK;

ALTER TABLE marca
ADD CONSTRAINT marca_sd_unique UNIQUE (id_marca, fk_sd);

ALTER TABLE lema_comercial
ADD CONSTRAINT marca_lc_unique UNIQUE (id_marca, fk_marca);

ALTER TABLE signo_distintivo
ADD CONSTRAINT chk_tipo_sd CHECK tipo IN ('denominativo', 'mixto', 'gráfico');
ADD CONSTRAINT chk_tipo_denominativo CHECK tipo='denominativo' AND nombre IS NOT NULL,
ADD CONSTRAINT chk_tipo_mixto CHECK (tipo='mixto' OR tipo='gráfico') AND 
    descripcion IS NOT NULL AND imagen_correspondiente IS NOT NULL;

ALTER TABLE recaudos_solicitud
ADD CONSTRAINT fk_solicitud FOREIGN KEY fk_solicitud REFERENCES solicitud (numero_de_solicitud),
ADD CONSTRAINT fk_recaudo FOREIGN KEY fk_recaudo REFERENCES recaudos (id_recaudo);