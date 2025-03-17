/*Sentencia 1: Por mes, presentar el número de solicitudes de marcas por tipo de signo distintivo (denominativa, gráfica, mixta). */
SELECT 
    TO_CHAR(s.fecha_solicitud, 'Mon-YYYY') AS mes,
    SUM(CASE WHEN sd.tipo = 'denominativa' THEN 1 ELSE 0 END) AS "Cantidad signo denominativa",
    SUM(CASE WHEN sd.tipo = 'grafica' THEN 1 ELSE 0 END) AS "Cantidad signo grafica",
    SUM(CASE WHEN sd.tipo = 'mixta' THEN 1 ELSE 0 END) AS "Cantidad signo mixta"
FROM 
    solicitud s
JOIN 
    signo_distintivo sd ON s.marca = sd.marca
GROUP BY 
    TO_CHAR(s.fecha_solicitud, 'Mon-YYYY')
ORDER BY 
    MIN(s.fecha_solicitud) ASC;


/*Sentencia 2:Por mes, presentar el top 3 de los países de domicilio de solicitantes con mayor número de solicitudes. */

WITH solicitudes_por_pais AS (
    SELECT 
        TO_CHAR(s.fecha_solicitud, 'Mon-YYYY') AS mes,
        sol.país_de_domicilio AS pais,
        COUNT(*) AS cantidad
    FROM 
        solicitud s
    JOIN 
        solicitud_solicitante ss ON s.número_de_solicitud = ss.fk_solicitud
    JOIN 
        solicitante sol ON ss.fk_solicitante = sol.id_solicitante
    GROUP BY 
        TO_CHAR(s.fecha_solicitud, 'Mon-YYYY'), sol.país_de_domicilio
), 
ranking AS (
    SELECT 
        mes,
        pais,
        cantidad,
        RANK() OVER (PARTITION BY mes ORDER BY cantidad DESC, pais ASC) AS ranking
    FROM 
        solicitudes_por_pais
)
SELECT 
    mes,
    MAX(CASE WHEN ranking = 1 THEN pais || ' (' || cantidad || ')' END) AS "País top 1",
    MAX(CASE WHEN ranking = 2 THEN pais || ' (' || cantidad || ')' END) AS "País top 2",
    MAX(CASE WHEN ranking = 3 THEN pais || ' (' || cantidad || ')' END) AS "País top 3"
FROM 
    ranking
WHERE 
    ranking <= 3
GROUP BY 
    mes
ORDER BY 
    TO_DATE(mes, 'Mon-YYYY') ASC;

/*Sentencia 3:Detalles de los números de solicitud con sus prioridades extranjeras (PE) */
/*Adaptación considerando la relación entre solicitud y prioridad_extranjera,
que ahora se maneja a través de solicitud_prioridad*/

SELECT 
    s.número_de_solicitud AS "Solicitud número",
    TO_CHAR(s.fecha_solicitud, 'DD-Mon-YYYY') AS "Solicitud fecha",
    TO_CHAR(pe.fecha_de_prioridad, 'DD-Mon-YYYY') AS "PE fecha",
    pe.número_de_prioridad AS "PE número",
    pe.país AS "PE país"
FROM 
    solicitud s
JOIN 
    solicitud_prioridad sp ON s.número_de_solicitud = sp.solicitud
JOIN 
    prioridad_extranjera pe ON sp.prioridad = pe.número_de_prioridad
ORDER BY 
    s.número_de_solicitud ASC, 
    pe.fecha_de_prioridad ASC;

/*Se usa solicitud_prioridad como tabla intermedia en la relación solicitud - prioridad_extranjera.
Se ajustan los nombres de columnas según proy2_tables.sql*/

-- /*Sentencia 4:pero filtrando solamente las filas en donde la fecha de la PE sea mayor o igual que la fecha de la
-- solicitud. */
SELECT 
    s.número_de_solicitud AS "Solicitud número",
    TO_CHAR(s.fecha_solicitud, 'DD-Mon-YYYY') AS "Solicitud fecha",
    TO_CHAR(pe.fecha_de_prioridad, 'DD-Mon-YYYY') AS "PE fecha",
    pe.número_de_prioridad AS "PE número",
    pe.país AS "PE país"
FROM 
    solicitud s
JOIN 
    solicitud_prioridad sp ON s.número_de_solicitud = sp.solicitud
JOIN 
    prioridad_extranjera pe ON sp.prioridad = pe.número_de_prioridad
WHERE 
    pe.fecha_de_prioridad >= s.fecha_solicitud
ORDER BY 
    s.número_de_solicitud ASC, 
    pe.fecha_de_prioridad ASC;

--Igual que la Sentencia 3, pero agregando WHERE pe.fecha_de_prioridad >= s.fecha_solicitud.



-- /*Sentencia 5:Por mes, la lista de solicitantes que no presentaron marcas durante ese mes. */
-- Adaptación considerando que solicitante y solicitud están relacionados a través de solicitud_solicitante
-- WITH meses AS (
    SELECT DISTINCT TO_CHAR(fecha_solicitud, 'Mon-YYYY') AS mes
    FROM solicitud
),
solicitantes AS (
    SELECT DISTINCT s.id_solicitante, s.país_de_domicilio
    FROM solicitante s
),
solicitudes_por_mes AS (
    SELECT DISTINCT TO_CHAR(s.fecha_solicitud, 'Mon-YYYY') AS mes, ss.fk_solicitante
    FROM solicitud s
    JOIN solicitud_solicitante ss ON s.número_de_solicitud = ss.fk_solicitud
)
SELECT 
    m.mes AS "Año Mes",
    sol.id_solicitante AS "Solicitante",
    sol.país_de_domicilio AS "País de domicilio"
FROM 
    meses m
CROSS JOIN 
    solicitantes sol
LEFT JOIN 
    solicitudes_por_mes spm 
    ON m.mes = spm.mes AND sol.id_solicitante = spm.fk_solicitante
WHERE 
    spm.fk_solicitante IS NULL
ORDER BY 
    TO_DATE(m.mes, 'Mon-YYYY', 'NLS_DATE_LANGUAGE=English') ASC, sol.id_solicitante ASC;

/*solicitud_solicitante se usa como tabla intermedia entre solicitud y solicitante.
solicitante usa id_solicitante en vez de solicitante.
país_de_domicilio en vez de país_domicilio (según proy2_tables.sql).
TO_DATE(m.mes, 'Mon-YYYY', 'NLS_DATE_LANGUAGE=English') asegura la conversión correcta de los meses.*/