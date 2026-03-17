--Trigger
CREATE OR REPLACE FUNCTION trg_fn_actualizar_fecha()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--prueba
SELECT name, unit_price, updated_at
FROM product
WHERE sku = 'CAF-001';