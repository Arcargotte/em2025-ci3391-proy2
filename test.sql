SELECT 
    número_de_solicitud
    
FROM solicitud s
JOIN
    marca m on m.id_marca = s.marca;
