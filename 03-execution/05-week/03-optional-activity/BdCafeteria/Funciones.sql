CREATE OR REPLACE FUNCTION fn_total_ventas_cliente(p_customer_id UUID)
RETURNS NUMERIC AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(total_amount), 0)
    INTO v_total
    FROM "order"
    WHERE customer_id = p_customer_id
      AND deleted_at IS NULL;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;


SELECT fn_total_ventas_cliente('0000000f-0000-0000-0000-000000000001') AS total_gastado;
SELECT fn_total_ventas_cliente('0000000f-0000-0000-0000-000000000002') AS total_gastado;
SELECT fn_total_ventas_cliente('0000000f-0000-0000-0000-000000000008') AS total_gastado;
SELECT fn_total_ventas_cliente('0000000f-0000-0000-0000-000000000006') AS total_gastado;

SELECT
	p.first_name || ' ' || p.last_name AS cliente,
	fn_total_ventas_cliente(c.id)		AS total_gastado
FROM customer c
JOIN person p ON c.person_id = p.id
ORDER BY total_gastado DESC;