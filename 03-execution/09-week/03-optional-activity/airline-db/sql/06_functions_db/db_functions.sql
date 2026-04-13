-- ============================================================
-- FUNCIONES DE BASE DE DATOS (DATABASE BUILT-IN FUNCTIONS)
-- Base de Datos: Sistema de Aerolíneas
-- ============================================================
-- Son funciones nativas de PostgreSQL organizadas por categoría:
-- - Texto, Fecha/Hora, Matemáticas, Agregación, Ventana, JSON
-- ============================================================


-- ============================================================
-- CATEGORÍA 1: FUNCIONES DE TEXTO
-- ============================================================

-- UPPER / LOWER / INITCAP: Manejo de mayúsculas
SELECT
    UPPER(airline_code)         AS code_upper,
    LOWER(airline_name)         AS name_lower,
    INITCAP(airline_name)       AS name_title
FROM airline
LIMIT 5;

-- CONCAT / || : Concatenación
SELECT
    CONCAT(first_name, ' ', last_name)          AS full_name_concat,
    first_name || ' ' || last_name              AS full_name_operator
FROM person
LIMIT 5;

-- LENGTH / CHAR_LENGTH: Longitud de cadena
SELECT
    username,
    LENGTH(username)            AS username_length,
    LENGTH(password_hash)       AS hash_length
FROM user_account
LIMIT 5;

-- TRIM / LTRIM / RTRIM: Eliminar espacios
SELECT
    TRIM('   airline   ')       AS trimmed,
    LTRIM('   airline')         AS left_trimmed,
    RTRIM('airline   ')         AS right_trimmed;

-- SUBSTRING: Extraer parte de un texto
SELECT
    ticket_number,
    SUBSTRING(ticket_number FROM 1 FOR 3)   AS ticket_prefix
FROM ticket
LIMIT 5;

-- REPLACE: Reemplazar texto
SELECT
    contact_value,
    REPLACE(contact_value, '@', '[at]')     AS masked_email
FROM person_contact
LIMIT 5;

-- SPLIT_PART: Dividir por delimitador
SELECT
    contact_value,
    SPLIT_PART(contact_value, '@', 1)       AS email_user,
    SPLIT_PART(contact_value, '@', 2)       AS email_domain
FROM person_contact
LIMIT 5;

-- POSITION: Encontrar posición de un carácter
SELECT
    contact_value,
    POSITION('@' IN contact_value)          AS at_position
FROM person_contact
LIMIT 5;

-- LPAD / RPAD: Rellenar texto
SELECT
    ticket_number,
    LPAD(ticket_number, 20, '0')            AS padded_ticket
FROM ticket
LIMIT 5;

-- FORMAT: Formatear string con placeholders
SELECT
    FORMAT('Pasajero: %s | Vuelo: %s', first_name, 'AA-001') AS formatted_msg
FROM person
LIMIT 3;


