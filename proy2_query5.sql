-- SELECT
--     TO_CHAR(fecha_solicitud, 'Mon-YYYY') as fecha,
--     slct.id_solicitante as slct_interno
-- FROM solicitud sol
-- JOIN solicitud_solicitante ss ON sol.número_de_solicitud = ss.fk_solicitud
-- JOIN solicitante slct ON ss.fk_solicitante = slct.id_solicitante
-- ORDER BY
--     TO_CHAR(fecha_solicitud, 'Mon-YYYY'),
--     slct.id_solicitante;

SELECT DISTINCT
    TO_CHAR(fecha_solicitud, 'Mon-YYYY'),
    slct2.id_solicitante,
    COALESCE(pn.nombre, pj.razón_social)
FROM solicitud
CROSS JOIN solicitante slct2
LEFT JOIN persona_natural pn ON slct2.id_solicitante = pn.solicitante AND slct2.tipo = 'Persona Natural'
LEFT JOIN persona_jurídica pj ON slct2.id_solicitante = pj.solicitante AND slct2.tipo = 'Persona Jurídica'
WHERE NOT EXISTS (
    SELECT
        1
    FROM (  SELECT
                TO_CHAR(fecha_solicitud, 'Mon-YYYY') as fecha,
                slct.id_solicitante as slct_interno
            FROM solicitud sol
            JOIN solicitud_solicitante ss ON sol.número_de_solicitud = ss.fk_solicitud
            JOIN solicitante slct ON ss.fk_solicitante = slct.id_solicitante
        )
    WHERE
        fecha = TO_CHAR(fecha_solicitud, 'Mon-YYYY') AND
        slct2.id_solicitante = slct_interno
    
)
ORDER BY
    TO_CHAR(fecha_solicitud, 'Mon-YYYY'),
    slct2.id_solicitante;






-- SELECT 
--     TO_CHAR(fecha_solicitud, 'Mon-YYYY'),
--     slct.id_solicitante,
--     COALESCE(pn.nombre, pj.razón_social)
-- FROM solicitud sol
-- JOIN solicitud_solicitante ss ON sol.número_de_solicitud = ss.fk_solicitud
-- JOIN solicitante slct ON ss.fk_solicitante = slct.id_solicitante
-- LEFT JOIN persona_natural pn ON slct.id_solicitante = pn.solicitante AND slct.tipo = 'Persona Natural'
-- LEFT JOIN persona_jurídica pj ON slct.id_solicitante = pj.solicitante AND slct.tipo = 'Persona Jurídica'
-- ORDER BY 
--     slct.id_solicitante;








-- SELECT 
--     mes AS "Año",
--     CASE 
--         WHEN s.tipo = 'Persona Natural' THEN sn.nombre
--         WHEN s.tipo = 'Persona Jurídica' THEN sj.razón_social
--         ELSE NULL
--     END AS "Solicitante",
--     s.país_de_domicilio AS "País de domicilio"
-- FROM (
--     -- Selecciona todos los distintos meses usados en las solicitudes
--     SELECT 
--         DISTINCT TO_CHAR(fecha_solicitud, 'Mon-YYYY') AS mes
--     FROM solicitud
-- )
-- CROSS JOIN solicitante s
-- LEFT JOIN persona_natural sn ON sn.solicitante = s.id_solicitante AND s.tipo = 'Persona Natural' 
-- LEFT JOIN persona_jurídica sj ON sj.solicitante = s.id_solicitante AND s.tipo = 'Persona Jurídica'
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM (
--             -- Selecciona cada mes con los solicitantes que SI solicitaron en dicho mes
--             SELECT 
--                 TO_CHAR(sol2.fecha_solicitud, 'Mon-YYYY') AS fecha,
--                 id_solicitante
--             FROM solicitante s2
--             JOIN solicitud_solicitante so2 ON s2.id_solicitante = so2.fk_solicitante
--             JOIN solicitud sol2 ON sol2.número_de_solicitud = so2.fk_solicitud
--         ) s2
--     WHERE fecha = mes
--     AND s2.id_solicitante = s.id_solicitante
-- )
-- ORDER BY TO_DATE(mes, 'Mon-YYYY') ASC, "Solicitante" ASC 
-- ;



