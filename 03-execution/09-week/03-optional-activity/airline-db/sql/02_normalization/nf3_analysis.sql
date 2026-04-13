-- ============================================================
-- ANÁLISIS DE TERCERA FORMA NORMAL (3FN)
-- Base de Datos: Sistema de Aerolíneas
-- ============================================================
-- 
-- REGLAS DE NORMALIZACIÓN:
-- 1FN: Valores atómicos, sin grupos repetitivos, PK definida.
-- 2FN: Sin dependencias parciales (todo atributo depende de toda la PK).
-- 3FN: Sin dependencias transitivas (atributo no clave no depende de otro atributo no clave).
--
-- ============================================================

-- ============================================================
-- MÓDULO 1: GEOGRAFÍA
-- ============================================================

/*
  TABLA: country
  PK: country_id
  
  1FN ✅ - Cada columna tiene valor atómico (iso_alpha2, iso_alpha3, country_name son simples)
  2FN ✅ - PK es simple (country_id), no hay dependencias parciales posibles
  3FN ✅ - continent_id no determina transitivamente ningún otro campo;
           iso_alpha2 e iso_alpha3 son identificadores alternativos (UQ), no generan transitividad
           porque no determinan atributos descriptivos aquí.
           
  EVIDENCIA: Si continent_name estuviera en country, sería violación 3FN:
             country_id → continent_id → continent_name  (transitiva ❌)
             SOLUCIÓN APLICADA: continent_name vive en la tabla continent separada. ✅
*/

-- Consulta que demuestra que country NO tiene dependencia transitiva:
SELECT 
    c.country_id,
    c.iso_alpha2,
    c.country_name,
    co.continent_name   -- continent_name viene de JOIN, no de country directamente
FROM country c
JOIN continent co ON c.continent_id = co.continent_id
LIMIT 5;


-- ============================================================
-- MÓDULO 2: IDENTIDAD / PERSONAS
-- ============================================================

/*
  TABLA: person
  PK: person_id
  
  1FN ✅ - Nombres separados (first_name, middle_name, last_name, second_last_name) → atómicos
  2FN ✅ - PK simple, no hay dependencias parciales
  3FN ✅ - No hay dependencias transitivas.
           person_type_id → type_name NO está en person (vive en person_type). ✅
           nationality_country_id → country_name NO está en person (vive en country). ✅

  EVIDENCIA de 3FN: Si type_name estuviera en person sería:
                   person_id → person_type_id → type_name  (transitiva ❌)
*/

-- Consulta que evidencia la separación correcta:
SELECT
    p.person_id,
    p.first_name || ' ' || p.last_name AS full_name,
    pt.type_name,       -- viene de person_type (no de person)
    c.country_name      -- viene de country (no de person)
FROM person p
JOIN person_type pt  ON p.person_type_id = pt.person_type_id
LEFT JOIN country c  ON p.nationality_country_id = c.country_id
LIMIT 5;


/*
  TABLA: person_document
  PK: person_document_id
  UQ: (document_type_id, issuing_country_id, document_number)
  
  1FN ✅ - Cada columna es atómica
  2FN ✅ - PK simple, no dependencias parciales
  3FN ✅ - type_name y country_name están en sus propias tablas.
           document_number no determina ningún otro atributo no clave.
*/


-- ============================================================
-- MÓDULO 3: SEGURIDAD
-- ============================================================

/*
  TABLA: user_role  (tabla puente N:M)
  PK: user_role_id
  UQ: (user_account_id, security_role_id)
  
  1FN ✅ - Valores atómicos
  2FN ✅ - Todos los atributos (assigned_at, assigned_by_user_id) dependen 
           del par completo (user_account_id, security_role_id), no de uno solo.
  3FN ✅ - No hay dependencias transitivas entre atributos no clave.

  EVIDENCIA de 2FN: Si role_name estuviera aquí dependería solo de security_role_id → violación 2FN ❌
                   SOLUCIÓN APLICADA: role_name vive en security_role. ✅
*/

SELECT
    ua.username,
    sr.role_name,       -- viene de security_role
    ur.assigned_at
FROM user_role ur
JOIN user_account ua    ON ur.user_account_id = ur.user_account_id
JOIN security_role sr   ON ur.security_role_id = sr.security_role_id
LIMIT 5;


-- ============================================================
-- MÓDULO 4: CLIENTE Y LEALTAD
-- ============================================================

/*
  TABLA: loyalty_account_tier
  PK: loyalty_account_tier_id
  
  1FN ✅ - Atributos atómicos
  2FN ✅ - PK simple
  3FN ✅ - Este es el caso más importante del diseño.
  
  PROBLEMA QUE SE EVITÓ (dependencia transitiva):
  Si loyalty_account tuviera directamente loyalty_tier_id + tier_name + priority_level:
      loyalty_account_id → loyalty_tier_id → tier_name     (transitiva ❌)
      loyalty_account_id → loyalty_tier_id → priority_level (transitiva ❌)
  
  SOLUCIÓN APLICADA:
  - loyalty_account_tier es una tabla de HISTORIAL separada.
  - El tier actual se obtiene por la asignación más reciente.
  - Comentario en schema: "Historial de asignacion de nivel para evitar dependencia transitiva"
*/

-- Consulta que obtiene el tier ACTUAL de cada cuenta (sin transitividad):
SELECT
    la.account_number,
    lt.tier_name,
    lt.priority_level,
    lat.assigned_at
FROM loyalty_account la
JOIN loyalty_account_tier lat ON la.loyalty_account_id = lat.loyalty_account_id
JOIN loyalty_tier lt           ON lat.loyalty_tier_id = lt.loyalty_tier_id
WHERE lat.assigned_at = (
    SELECT MAX(lat2.assigned_at)
    FROM loyalty_account_tier lat2
    WHERE lat2.loyalty_account_id = la.loyalty_account_id
)
LIMIT 5;


-- ============================================================
-- MÓDULO 5: AERONAVES
-- ============================================================

/*
  TABLA: aircraft
  PK: aircraft_id
  
  1FN ✅ - Atributos simples y atómicos
  2FN ✅ - PK simple
  3FN ✅ - model_name, manufacturer_name NO están en aircraft:
           aircraft_id → aircraft_model_id → model_name   (evitado ✅)
           aircraft_id → aircraft_model_id → manufacturer (evitado ✅)
           
  TABLA: aircraft_seat
  PK: aircraft_seat_id
  UQ: (aircraft_cabin_id, seat_row_number, seat_column_code)
  
  3FN ✅ - cabin_class_name NO está en aircraft_seat:
           aircraft_seat_id → aircraft_cabin_id → cabin_class_id → class_name (transitiva evitada ✅)
*/

-- Evidencia: jerarquía aeronave sin transitividades
SELECT
    ac.registration_number,
    am.model_name,              -- de aircraft_model
    aman.manufacturer_name,     -- de aircraft_manufacturer
    acab.cabin_code,
    cc.class_name,              -- de cabin_class
    ase.seat_row_number,
    ase.seat_column_code
FROM aircraft ac
JOIN aircraft_model am          ON ac.aircraft_model_id = am.aircraft_model_id
JOIN aircraft_manufacturer aman ON am.aircraft_manufacturer_id = aman.aircraft_manufacturer_id
JOIN aircraft_cabin acab        ON ac.aircraft_id = acab.aircraft_id
JOIN cabin_class cc             ON acab.cabin_class_id = cc.cabin_class_id
JOIN aircraft_seat ase          ON acab.aircraft_cabin_id = ase.aircraft_cabin_id
LIMIT 10;


-- ============================================================
-- MÓDULO 6: VUELOS
-- ============================================================

/*
  TABLA: flight_segment
  PK: flight_segment_id
  
  1FN ✅ - No hay atributos multivaluados; origen y destino son FKs separadas
  2FN ✅ - PK simple
  3FN ✅ - airport_name, city_name NO están aquí:
           flight_segment_id → origin_airport_id → airport_name  (evitado ✅)
  
  TABLA: flight_delay
  PK: flight_delay_id
  
  3FN ✅ - reason_name vive en delay_reason_type, no en flight_delay:
           flight_delay_id → delay_reason_type_id → reason_name  (evitado ✅)
*/

-- Evidencia: vuelo con segmentos sin transitividad
SELECT
    f.flight_number,
    f.service_date,
    fs_status.status_name,                  -- de flight_status
    ao.airport_name  AS origin_airport,     -- de airport (origin)
    ad.airport_name  AS dest_airport,       -- de airport (destination)
    fs.scheduled_departure_at,
    fs.scheduled_arrival_at
FROM flight f
JOIN flight_status fs_status    ON f.flight_status_id = fs_status.flight_status_id
JOIN flight_segment fs          ON f.flight_id = fs.flight_id
JOIN airport ao                 ON fs.origin_airport_id = ao.airport_id
JOIN airport ad                 ON fs.destination_airport_id = ad.airport_id
ORDER BY f.service_date, fs.segment_number
LIMIT 10;


-- ============================================================
-- MÓDULO 7: VENTAS, RESERVAS Y TIQUETES
-- ============================================================

/*
  TABLA: ticket
  PK: ticket_id
  
  1FN ✅ - Atributos atómicos
  2FN ✅ - PK simple
  3FN ✅ - fare details (base_amount, fare_class) NO están en ticket:
           ticket_id → fare_id → base_amount  (evitado ✅)
  
  TABLA: ticket_segment  (tabla puente)
  PK: ticket_segment_id
  Comentario en schema: "Tabla puente entre ticket y segmentos de vuelo para soportar itinerarios con escalas"
  
  3FN ✅ - No hay atributos descriptivos del segmento ni del tiquete aquí.
  
  TABLA: seat_assignment
  Comentario en schema: "Asignacion de asiento normalizada por ticket_segment con control de unicidad"
  
  3FN ✅ - seat_row, seat_column NO están en seat_assignment:
           seat_assignment_id → aircraft_seat_id → seat_row_number  (evitado ✅)
*/

-- Evidencia: tiquete completo sin transitividades
SELECT
    t.ticket_number,
    p.first_name || ' ' || p.last_name  AS passenger,
    ts_status.status_name               AS ticket_status,  -- de ticket_status
    f.fare_code,                                           -- de fare
    fc.fare_class_name,                                    -- de fare_class
    cc.class_name                       AS cabin           -- de cabin_class
FROM ticket t
JOIN reservation_passenger rp   ON t.reservation_passenger_id = rp.reservation_passenger_id
JOIN person p                   ON rp.person_id = p.person_id
JOIN ticket_status ts_status    ON t.ticket_status_id = ts_status.ticket_status_id
JOIN fare f                     ON t.fare_id = f.fare_id
JOIN fare_class fc              ON f.fare_class_id = fc.fare_class_id
JOIN cabin_class cc             ON fc.cabin_class_id = cc.cabin_class_id
LIMIT 10;


-- ============================================================
-- MÓDULO 8: FACTURACIÓN
-- ============================================================

/*
  TABLA: invoice_line
  PK: invoice_line_id
  Comentario en schema: "Detalle facturable sin totales derivados persistidos, para preservar 3FN"
  
  1FN ✅ - Atributos atómicos
  2FN ✅ - PK simple
  3FN ✅ - No se almacena line_total (quantity * unit_price) porque sería atributo DERIVADO,
           lo que violaría 3FN al poder calcularse desde otros atributos de la misma tabla.
           
  EVIDENCIA: El total se calcula en consulta, no se persiste:
*/

SELECT
    i.invoice_number,
    il.line_number,
    il.line_description,
    il.quantity,
    il.unit_price,
    (il.quantity * il.unit_price)                                   AS line_total,      -- calculado, no persistido ✅
    t.rate_percentage,
    (il.quantity * il.unit_price * (1 + t.rate_percentage / 100))   AS line_total_with_tax,
    SUM(il.quantity * il.unit_price) OVER (PARTITION BY i.invoice_id) AS invoice_subtotal
FROM invoice i
JOIN invoice_line il    ON i.invoice_id = il.invoice_id
LEFT JOIN tax t         ON il.tax_id = t.tax_id
ORDER BY i.invoice_number, il.line_number
LIMIT 10;


-- ============================================================
-- RESUMEN GENERAL DE CUMPLIMIENTO 3FN
-- ============================================================

/*
┌─────────────────────────────┬──────┬──────┬──────┬─────────────────────────────────────────────┐
│ Tabla / Módulo              │  1FN │  2FN │  3FN │ Observación                                 │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ continent / country /       │  ✅  │  ✅  │  ✅  │ Jerarquía geográfica correctamente separada │
│ state_province / city       │      │      │      │                                             │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ person / person_document    │  ✅  │  ✅  │  ✅  │ Nombres atómicos, tipos en tablas propias   │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ user_role / role_permission │  ✅  │  ✅  │  ✅  │ Tablas puente N:M bien normalizadas         │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ loyalty_account_tier        │  ✅  │  ✅  │  ✅  │ Historial separado evita dependencia        │
│                             │      │      │      │ transitiva en loyalty_account               │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ aircraft / aircraft_seat    │  ✅  │  ✅  │  ✅  │ Jerarquía fabricante→modelo→aeronave→cabina │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ flight / flight_segment     │  ✅  │  ✅  │  ✅  │ airport_name no se repite en flight_segment │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ ticket / ticket_segment     │  ✅  │  ✅  │  ✅  │ Tabla puente soporta itinerarios con escalas│
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ seat_assignment             │  ✅  │  ✅  │  ✅  │ seat_row no se repite aquí                  │
├─────────────────────────────┼──────┼──────┼──────┼─────────────────────────────────────────────┤
│ invoice_line                │  ✅  │  ✅  │  ✅  │ Sin totales derivados persistidos           │
└─────────────────────────────┴──────┴──────┴──────┴─────────────────────────────────────────────┘
*/