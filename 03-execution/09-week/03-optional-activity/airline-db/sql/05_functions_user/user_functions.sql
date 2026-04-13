-- ============================================================
-- FUNCIONES DE USUARIO (USER-DEFINED FUNCTIONS)
-- Base de Datos: Sistema de Aerolíneas
-- ============================================================
-- Son funciones creadas por el desarrollador para encapsular
-- lógica de negocio reutilizable en la base de datos.
-- ============================================================

-- ============================================================
-- FUNCIÓN 1: Obtener el nombre completo de una persona
-- ============================================================
/*
  Recibe: person_id (uuid)
  Retorna: full_name (text)
  Uso: Evita repetir la concatenación de nombres en cada consulta
*/

CREATE OR REPLACE FUNCTION fn_get_full_name(p_person_id uuid)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    v_full_name text;
BEGIN
    SELECT
        TRIM(
            first_name
            || CASE WHEN middle_name IS NOT NULL THEN ' ' || middle_name ELSE '' END
            || ' ' || last_name
            || CASE WHEN second_last_name IS NOT NULL THEN ' ' || second_last_name ELSE '' END
        )
    INTO v_full_name
    FROM person
    WHERE person_id = p_person_id;

    RETURN v_full_name;
END;
$$;

-- USO:
-- SELECT fn_get_full_name('uuid-de-la-persona');


-- ============================================================
-- FUNCIÓN 2: Calcular la edad de una persona
-- ============================================================
/*
  Recibe: p_birth_date (date)
  Retorna: edad en años (integer)
*/

CREATE OR REPLACE FUNCTION fn_calculate_age(p_birth_date date)
RETURNS integer
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_birth_date IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN DATE_PART('year', AGE(CURRENT_DATE, p_birth_date))::integer;
END;
$$;

-- USO:
-- SELECT fn_calculate_age('1990-05-15');
-- SELECT first_name, fn_calculate_age(birth_date) AS age FROM person LIMIT 5;


-- ============================================================
-- FUNCIÓN 3: Calcular el total de una factura
-- ============================================================
/*
  Recibe: p_invoice_id (uuid)
  Retorna: total con impuestos (numeric)
  Nota: invoice_line no almacena totales derivados (3FN),
        por eso esta función los calcula dinámicamente.
*/

CREATE OR REPLACE FUNCTION fn_get_invoice_total(p_invoice_id uuid)
RETURNS numeric(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total numeric(12,2);
BEGIN
    SELECT COALESCE(
        SUM(
            il.quantity * il.unit_price *
            (1 + COALESCE(t.rate_percentage, 0) / 100)
        ), 0
    )
    INTO v_total
    FROM invoice_line il
    LEFT JOIN tax t ON il.tax_id = t.tax_id
    WHERE il.invoice_id = p_invoice_id;

    RETURN v_total;
END;
$$;

-- USO:
-- SELECT invoice_number, fn_get_invoice_total(invoice_id) AS total FROM invoice LIMIT 5;


-- ============================================================
-- FUNCIÓN 4: Verificar si un asiento está disponible
-- ============================================================
/*
  Recibe: p_aircraft_seat_id (uuid), p_flight_segment_id (uuid)
  Retorna: boolean (true = disponible, false = ocupado)
*/

CREATE OR REPLACE FUNCTION fn_is_seat_available(
    p_aircraft_seat_id  uuid,
    p_flight_segment_id uuid
)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    v_count integer;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM seat_assignment
    WHERE aircraft_seat_id  = p_aircraft_seat_id
      AND flight_segment_id = p_flight_segment_id;

    RETURN v_count = 0;
END;
$$;

-- USO:
-- SELECT fn_is_seat_available('uuid-asiento', 'uuid-segmento');


-- ============================================================
-- FUNCIÓN 5: Obtener el saldo de millas de una cuenta loyalty
-- ============================================================
/*
  Recibe: p_loyalty_account_id (uuid)
  Retorna: saldo total de millas (integer)
  Lógica: suma créditos y resta débitos de miles_transaction
*/

CREATE OR REPLACE FUNCTION fn_get_miles_balance(p_loyalty_account_id uuid)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    v_balance integer;
BEGIN
    SELECT COALESCE(
        SUM(
            CASE
                WHEN transaction_type = 'CREDIT' THEN miles_amount
                WHEN transaction_type = 'DEBIT'  THEN -miles_amount
                ELSE 0
            END
        ), 0
    )
    INTO v_balance
    FROM miles_transaction
    WHERE loyalty_account_id = p_loyalty_account_id;

    RETURN v_balance;
END;
$$;

-- USO:
-- SELECT account_number, fn_get_miles_balance(loyalty_account_id) AS balance
-- FROM loyalty_account LIMIT 5;


-- ============================================================
-- FUNCIÓN 6: Obtener el estado actual del vuelo
-- ============================================================
/*
  Recibe: p_flight_id (uuid)
  Retorna: status_name (text)
*/

CREATE OR REPLACE FUNCTION fn_get_flight_status(p_flight_id uuid)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    v_status text;
BEGIN
    SELECT fs.status_name
    INTO v_status
    FROM flight f
    JOIN flight_status fs ON f.flight_status_id = fs.flight_status_id
    WHERE f.flight_id = p_flight_id;

    RETURN COALESCE(v_status, 'UNKNOWN');
END;
$$;

-- USO:
-- SELECT flight_number, fn_get_flight_status(flight_id) AS status FROM flight LIMIT 5;


-- ============================================================
-- FUNCIÓN 7: Calcular duración de un segmento de vuelo (en minutos)
-- ============================================================
/*
  Recibe: p_flight_segment_id (uuid)
  Retorna: duración en minutos (integer)
  Usa: actual si está disponible, scheduled si no.
*/

CREATE OR REPLACE FUNCTION fn_get_segment_duration_minutes(p_flight_segment_id uuid)
RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
    v_minutes integer;
BEGIN
    SELECT
        EXTRACT(EPOCH FROM (
            COALESCE(actual_arrival_at, scheduled_arrival_at) -
            COALESCE(actual_departure_at, scheduled_departure_at)
        )) / 60
    INTO v_minutes
    FROM flight_segment
    WHERE flight_segment_id = p_flight_segment_id;

    RETURN v_minutes;
END;
$$;

-- USO:
-- SELECT flight_segment_id, fn_get_segment_duration_minutes(flight_segment_id) AS duration_min
-- FROM flight_segment LIMIT 5;


-- ============================================================
-- FUNCIÓN 8: Verificar si una reserva tiene todos los pasajeros
--            con check-in hecho
-- ============================================================
/*
  Recibe: p_reservation_id (uuid)
  Retorna: boolean (true = todos hicieron check-in)
*/

CREATE OR REPLACE FUNCTION fn_all_passengers_checked_in(p_reservation_id uuid)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_segments    integer;
    v_checked_segments  integer;
BEGIN
    -- Total de ticket_segments asociados a la reserva
    SELECT COUNT(*)
    INTO v_total_segments
    FROM ticket t
    JOIN reservation_passenger rp   ON t.reservation_passenger_id = rp.reservation_passenger_id
    JOIN ticket_segment ts          ON t.ticket_id = ts.ticket_id
    WHERE rp.reservation_id = p_reservation_id;

    -- Total de ticket_segments con check-in completado
    SELECT COUNT(*)
    INTO v_checked_segments
    FROM ticket t
    JOIN reservation_passenger rp   ON t.reservation_passenger_id = rp.reservation_passenger_id
    JOIN ticket_segment ts          ON t.ticket_id = ts.ticket_id
    JOIN check_in ci                ON ts.ticket_segment_id = ci.ticket_segment_id
    JOIN check_in_status cis        ON ci.check_in_status_id = cis.check_in_status_id
    WHERE rp.reservation_id = p_reservation_id
      AND cis.status_code = 'COMPLETED';

    RETURN v_total_segments > 0 AND v_total_segments = v_checked_segments;
END;
$$;

-- USO:
-- SELECT reservation_code, fn_all_passengers_checked_in(reservation_id) AS all_checked_in
-- FROM reservation LIMIT 5;


-- ============================================================
-- VERIFICAR FUNCIONES CREADAS
-- ============================================================

SELECT
    routine_name        AS function_name,
    routine_type        AS type,
    data_type           AS return_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_type   = 'FUNCTION'
ORDER BY routine_name;