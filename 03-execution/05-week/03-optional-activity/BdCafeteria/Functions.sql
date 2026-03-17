--Functions

CREATE OR REPLACE FUNCTION trg_fn_set_update_at()
RETURNS TRIGGER AS $$
BEGIN
	NEW.update_at = NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_product_updated_at
    BEFORE UPDATE ON product
    FOR EACH ROW EXECUTE FUNCTION trg_fn_set_updated_at();

CREATE TRIGGER trg_order_updated_at
	BEFORE UPDATE ON "order"
	FOR EACH ROW EXECUTE FUNCTION trg_fn_set_updated_at();

CREATE TRIGGER trg_invoice_updated_at
    BEFORE UPDATE ON invoice
    FOR EACH ROW EXECUTE FUNCTION trg_fn_set_updated_at();

CREATE TRIGGER trg_inventory_updated_at
    BEFORE UPDATE ON inventory
    FOR EACH ROW EXECUTE FUNCTION trg_fn_set_updated_at();


UPDATE product SET unit_price = 5000 WHERE sku = 'CAF-001';
SELECT name, unit_price, updated_at FROM product WHERE sku = 'CAF-001';