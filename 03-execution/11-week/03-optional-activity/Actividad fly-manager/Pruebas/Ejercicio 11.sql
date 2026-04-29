SELECT
    r.reservation_code,
    f.flight_number,
    f.service_date,
    fs.segment_number,
    p.first_name,
    p.last_name,
    t.ticket_number,
    ci.checked_in_at,
    bp.boarding_pass_code
FROM reservation r
INNER JOIN reservation_passenger rp
    ON rp.reservation_id = r.reservation_id
INNER JOIN person p
    ON p.person_id = rp.person_id
INNER JOIN ticket t
    ON t.reservation_passenger_id = rp.reservation_passenger_id
INNER JOIN ticket_segment ts
    ON ts.ticket_id = t.ticket_id
INNER JOIN flight_segment fs
    ON fs.flight_segment_id = ts.flight_segment_id
INNER JOIN flight f
    ON f.flight_id = fs.flight_id
INNER JOIN check_in ci
    ON ci.ticket_segment_id = ts.ticket_segment_id
INNER JOIN boarding_pass bp
    ON bp.check_in_id = ci.check_in_id
ORDER BY ci.checked_in_at DESC, f.service_date DESC;


------------------------------TRIGGER-------------------------------------

DROP TRIGGER IF EXISTS trg_ai_check_in_create_boarding_pass ON check_in;
DROP FUNCTION IF EXISTS fn_ai_check_in_create_boarding_pass();

CREATE OR REPLACE FUNCTION fn_ai_check_in_create_boarding_pass()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_boarding_pass_code varchar(40);
    v_barcode_value varchar(120);
BEGIN
    IF EXISTS (
        SELECT 1
        FROM boarding_pass bp
        WHERE bp.check_in_id = NEW.check_in_id
    ) THEN
        RETURN NEW;
    END IF;

    v_boarding_pass_code := 'BP-' || replace(NEW.check_in_id::text, '-', '');
    v_barcode_value := 'BAR-' || replace(NEW.check_in_id::text, '-', '') || '-' || to_char(NEW.checked_in_at, 'YYYYMMDDHH24MISS');

    INSERT INTO boarding_pass (
        check_in_id,
        boarding_pass_code,
        barcode_value,
        issued_at
    )
    VALUES (
        NEW.check_in_id,
        left(v_boarding_pass_code, 40),
        left(v_barcode_value, 120),
        NEW.checked_in_at
    );

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_ai_check_in_create_boarding_pass
AFTER INSERT ON check_in
FOR EACH ROW
EXECUTE FUNCTION fn_ai_check_in_create_boarding_pass();

----------------- Script del procedimiento------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_register_check_in(
    p_ticket_segment_id uuid,
    p_check_in_status_id uuid,
    p_boarding_group_id uuid,
    p_checked_in_by_user_id uuid,
    p_checked_in_at timestamptz
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM check_in ci
        WHERE ci.ticket_segment_id = p_ticket_segment_id
    ) THEN
        RAISE EXCEPTION 'Ya existe un check-in para el ticket_segment_id %', p_ticket_segment_id;
    END IF;

    INSERT INTO check_in (
        ticket_segment_id,
        check_in_status_id,
        boarding_group_id,
        checked_in_by_user_id,
        checked_in_at
    )
    VALUES (
        p_ticket_segment_id,
        p_check_in_status_id,
        p_boarding_group_id,
        p_checked_in_by_user_id,
        p_checked_in_at
    );
END;
$$;

--------------------------Script de demostración del funcionamiento-------------------------------------------------

DO $$
DECLARE
    v_ticket_segment_id uuid;
    v_check_in_status_id uuid;
    v_boarding_group_id uuid;
    v_checked_in_by_user_id uuid;
BEGIN
    SELECT ts.ticket_segment_id
    INTO v_ticket_segment_id
    FROM ticket_segment ts
    LEFT JOIN check_in ci
        ON ci.ticket_segment_id = ts.ticket_segment_id
    WHERE ci.check_in_id IS NULL
    ORDER BY ts.created_at
    LIMIT 1;

    SELECT cis.check_in_status_id
    INTO v_check_in_status_id
    FROM check_in_status cis
    ORDER BY cis.created_at
    LIMIT 1;

    SELECT bg.boarding_group_id
    INTO v_boarding_group_id
    FROM boarding_group bg
    ORDER BY bg.sequence_no
    LIMIT 1;

    SELECT ua.user_account_id
    INTO v_checked_in_by_user_id
    FROM user_account ua
    ORDER BY ua.created_at
    LIMIT 1;

    IF v_ticket_segment_id IS NULL THEN
        RAISE EXCEPTION 'No existe ticket_segment disponible sin check-in.';
    END IF;

    IF v_check_in_status_id IS NULL THEN
        RAISE EXCEPTION 'No existe check_in_status cargado.';
    END IF;

    CALL sp_register_check_in(
        v_ticket_segment_id,
        v_check_in_status_id,
        v_boarding_group_id,
        v_checked_in_by_user_id,
        now()
    );
END;
$$;

SELECT
    ci.check_in_id,
    ci.ticket_segment_id,
    ci.checked_in_at,
    bp.boarding_pass_id,
    bp.boarding_pass_code,
    bp.barcode_value
FROM check_in ci
INNER JOIN boarding_pass bp
    ON bp.check_in_id = ci.check_in_id
ORDER BY ci.created_at DESC
LIMIT 5;