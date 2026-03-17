
CREATE OR REPLACE PROCEDURE sp_registrar_pedido(
    p_customer_id  UUID,
    p_user_id      UUID,
    p_product_id   UUID,
    p_quantity     NUMERIC,
    p_order_type   VARCHAR,
    p_method_payment_id UUID
)
LANGUAGE plpgsql AS $$
DECLARE
    v_order_id   UUID := uuid_generate_v4();
    v_invoice_id UUID := uuid_generate_v4();
    v_unit_price NUMERIC;
    v_subtotal   NUMERIC;
    v_tax        NUMERIC;
    v_total      NUMERIC;
    v_inv_number VARCHAR;
BEGIN

    SELECT unit_price INTO v_unit_price
    FROM product WHERE id = p_product_id;

    -- Calcular valores
    v_subtotal = v_unit_price * p_quantity;
    v_tax      = ROUND(v_subtotal * 0.19, 2);
    v_total    = v_subtotal + v_tax;
    v_inv_number = 'INV-' || TO_CHAR(NOW(), 'YYYY-MM-DD-HH24MISS');

    INSERT INTO "order" (id, customer_id, user_id, order_date, total_amount, order_type)
    VALUES (v_order_id, p_customer_id, p_user_id, NOW(), v_total, p_order_type);

    INSERT INTO order_item (order_id, product_id, quantity, unit_price, subtotal)
    VALUES (v_order_id, p_product_id, p_quantity, v_unit_price, v_subtotal);

    INSERT INTO invoice (id, order_id, customer_id, invoice_number, subtotal, tax_amount, total_amount, due_date)
    VALUES (v_invoice_id, v_order_id, p_customer_id, v_inv_number, v_subtotal, v_tax, v_total, CURRENT_DATE);

    INSERT INTO payment (invoice_id, method_payment_id, amount)
    VALUES (v_invoice_id, p_method_payment_id, v_total);

    RAISE NOTICE 'Pedido registrado correctamente. Factura: %', v_inv_number;
END;
$$;


CALL sp_registrar_pedido(
    '0000000f-0000-0000-0000-000000000002',  
    '00000007-0000-0000-0000-000000000002', 
    '0000000d-0000-0000-0000-000000000003',  
    1,                                        
    'mesa',                                   
    '00000010-0000-0000-0000-000000000004'   
);


SELECT o.order_type, p.name AS producto, i.invoice_number, i.total_amount
FROM invoice i
JOIN "order"     o  ON i.order_id    = o.id
JOIN order_item  oi ON oi.order_id   = o.id
JOIN product     p  ON oi.product_id = p.id
ORDER BY i.issue_date DESC
LIMIT 3;
