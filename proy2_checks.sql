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

ALTER TABLE persona_natural
ADD CONSTRAINT correo_electronico CHECK correo_electronico LIKE '%@%.%',

ALTER TABLE persona_juridica
ADD CONSTRAINT chk_persona_juridica_tipo CHECK(
    tipo ILIKE 'PÚBLICO' OR
    tipo ILIKE 'PUBLICO' OR
    tipo ILIKE 'PRIVADO' OR
    tipo ILIKE 'ASOCIACIÓN DE PROPIEDAD COLECTIVA' OR
    tipo ILIKE 'ASOCIACION DE PROPIEDAD COLECTIVA' OR
);

/*
A PESAR DE QUE EN EL ESQUEMA DE BASE DE DATOS RESTRINGIMOS
LOS VALORES DE LOS ATRIBUTOS TIPO EN PUBLICO, TENEMOS LA LIMITACION
DE QUE EN EL ARCHIVO EXCEL ESTE ATRIBUTO NO PUEDE SER NULO
*/
ALTER TABLE publica;

ALTER TABLE asociacion_de_propiedad_colectiva
ADD CONSTRAINT CHECK;

ALTER TABLE privada
ADD CONSTRAINT CHECK;

ALTER TABLE apoderado
ADD CONSTRAINT CHECK;

ALTER TABLE prioridad_extranjera
ADD CONSTRAINT CHECK;

ALTER TABLE pais
ADD CONSTRAINT CHECK;

ALTER TABLE recaudos
ADD CONSTRAINT CHECK;

ALTER TABLE marca
ADD CONSTRAINT CHECK;

ALTER TABLE lema_comercial
ADD CONSTRAINT CHECK;

ALTER TABLE mixto
ADD CONSTRAINT CHECK;

ALTER TABLE denominativo
ADD CONSTRAINT CHECK;

ALTER TABLE grafico
ADD CONSTRAINT CHECK;