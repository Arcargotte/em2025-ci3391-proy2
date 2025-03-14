--Cambia al usuario proy2 desde el usuario que inicio la instancia de psql.
--Se asegura de que sea el usuario proy2 el que manipule el esquema.
SET ROLE proy2;

/*
Agrega las restricciones sobre las claves foráneas y valores de los atributos 
definidas en el esquema de la base de datos e implementadas en el script
proy2_tables.sql.
*/

ALTER TABLE solicitud
ADD CONSTRAINT CHECK;

ALTER TABLE persona_natural
ADD CONSTRAINT CHECK;

ALTER TABLE persona_juridica
ADD CONSTRAINT CHECK;

ALTER TABLE publica
ADD CONSTRAINT CHECK;

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