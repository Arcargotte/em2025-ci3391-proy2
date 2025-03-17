-- Sentencia 1: Cantidad de solicitudes de marcas por tipo de signo distintivo en cada mes
-- Se agrupan las solicitudes por mes y se cuenta cuántas corresponden a cada tipo de signo distintivo.
SELECT 
    TO_CHAR(s.fecha_solicitud, 'Mon-YYYY') AS mes, -- Formatea la fecha para agrupar por mes y año
    SUM(CASE WHEN sd.tipo = 'denominativa' THEN 1 ELSE 0 END) AS "Cantidad signo denominativa",
    SUM(CASE WHEN sd.tipo = 'grafica' THEN 1 ELSE 0 END) AS "Cantidad signo grafica",
    SUM(CASE WHEN sd.tipo = 'mixta' THEN 1 ELSE 0 END) AS "Cantidad signo mixta"
FROM 
    solicitud s
JOIN 
    signo_distintivo sd ON s.marca = sd.marca -- Relaciona la solicitud con el signo distintivo de la marca
GROUP BY 
    TO_CHAR(s.fecha_solicitud, 'Mon-YYYY')
ORDER BY 
    MIN(s.fecha_solicitud) ASC; -- Ordena los resultados cronológicament


-- Sentencia 2: Top 3 de países con más solicitudes por mes
-- Se obtiene la cantidad de solicitudes por país de domicilio y se seleccionan los tres con mayor volumen.
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
    TO_DATE(mes, 'Mon-YYYY') ASC; -- Convierte el mes a fecha para ordenarlo correctamente

-- Sentencia 3: Detalle de solicitudes con prioridad extranjera (PE)
-- Se listan las solicitudes junto con la información de sus prioridades extranjeras, si las tienen.

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

-- /*Se usa solicitud_prioridad como tabla intermedia en la relación solicitud - prioridad_extranjera.
-- Se ajustan los nombres de columnas según proy2_tables.sql*/

-- Sentencia 4: Igual que la Sentencia 3, pero filtrando solo prioridades extranjeras con fecha mayor o igual a la solicitud
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
    pe.fecha_de_prioridad >= s.fecha_solicitud -- Solo se incluyen prioridades extranjeras con fecha igual o posterior a la solicitud
ORDER BY 
ORDER BY 
    s.número_de_solicitud ASC, 
    pe.fecha_de_prioridad ASC;





-- Sentencia 5: Solicitantes que no presentaron solicitudes en un mes dado
-- Se listan los solicitantes que no tienen registros de solicitud en el mes analizado.



/*solicitud_solicitante se usa como tabla intermedia entre solicitud y solicitante.
solicitante usa id_solicitante en vez de solicitante.
país_de_domicilio en vez de país_domicilio (según proy2_tables.sql).
TO_DATE(m.mes, 'Mon-YYYY', 'NLS_DATE_LANGUAGE=English') asegura la conversión correcta de los meses.*/