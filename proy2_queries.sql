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
SELECT 
    s.número_de_solicitud AS "Solicitud número",
    TO_CHAR(s.fecha_solicitud, 'DD-Mon-YYYY') AS "Solicitud fecha",
    TO_CHAR(pe.fecha_pe, 'DD-Mon-YYYY') AS "PE fecha",
    pe.número_pe AS "PE número",
    pe.país_origen AS "PE país"
FROM 
    solicitud s
JOIN 
    prioridad_extranjera pe ON s.número_de_solicitud = pe.fk_solicitud
ORDER BY 
    s.número_de_solicitud ASC, 
    pe.fecha_pe ASC;

-- /*Sentencia 4:pero filtrando solamente las filas en donde la fecha de la PE sea mayor o igual que la fecha de la
-- solicitud. */
-- SELECT 
--     s.numero_solicitud AS "Solicitud número",
--     TO_CHAR(s.fecha_solicitud, 'DD-Mon-YYYY') AS "Solicitud fecha",
--     TO_CHAR(pe.fecha_pe, 'DD-Mon-YYYY') AS "PE fecha",
--     pe.numero_pe AS "PE número",
--     pe.pais_pe AS "PE país"
-- FROM 
--     solicitud s
-- JOIN 
--     prioridad_extranjera pe ON s.id_solicitud = pe.solicitud
-- WHERE 
--     pe.fecha_pe >= s.fecha_solicitud
-- ORDER BY 
--     s.numero_solicitud ASC, pe.fecha_pe ASC;



-- /*Sentencia 5:Por mes, la lista de solicitantes que no presentaron marcas durante ese mes. */

-- WITH meses AS (
--     SELECT DISTINCT TO_CHAR(fecha_solicitud, 'Mon-YYYY') AS mes
--     FROM solicitud
-- ),
-- solicitantes AS (
--     SELECT DISTINCT s.solicitante, s.país_domicilio
--     FROM solicitud s
-- ),
-- solicitudes_por_mes AS (
--     SELECT DISTINCT TO_CHAR(s.fecha_solicitud, 'Mon-YYYY') AS mes, s.solicitante
--     FROM solicitud s
-- )
-- SELECT 
--     m.mes AS "Año Mes",
--     sol.solicitante AS "Solicitante",
--     sol.país_domicilio AS "País de domicilio"
-- FROM 
--     meses m
-- CROSS JOIN 
--     solicitantes sol
-- LEFT JOIN 
--     solicitudes_por_mes spm 
--     ON m.mes = spm.mes AND sol.solicitante = spm.solicitante
-- WHERE 
--     spm.solicitante IS NULL
-- ORDER BY 
--     TO_DATE(m.mes, 'Mon-YYYY') ASC, sol.solicitante ASC;
