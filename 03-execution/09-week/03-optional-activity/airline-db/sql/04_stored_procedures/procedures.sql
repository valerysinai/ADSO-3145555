CREATE OR REPLACE PROCEDURE sp_register_checkin(
    p_ticket_segment_id uuid,
    p_status_code varchar
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO check_in (ticket_segment_id, check_in_status_id, ...)
    VALUES (...);
END;
$$;