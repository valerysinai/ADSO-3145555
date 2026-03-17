--View
CREATE OR REPLACE VIEW v_clientes AS
SELECT
    c.id,
    p.first_name || ' ' || p.last_name  AS nombre_completo,
    p.email,
    p.phone,
    c.loyalty_points                     AS puntos,
    c.notes                              AS observaciones
FROM customer c
JOIN person p ON c.person_id = p.id;

--Prueba
SELECT * FROM v_clientes;
SELECT * FROM v_clientes WHERE puntos > 500;