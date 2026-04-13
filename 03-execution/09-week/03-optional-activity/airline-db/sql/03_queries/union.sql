SELECT contact_value AS contacto, 'email' AS tipo FROM person_contact WHERE contact_type_id = '...'
UNION
SELECT contact_value, 'phone' FROM person_contact WHERE contact_type_id = '...';