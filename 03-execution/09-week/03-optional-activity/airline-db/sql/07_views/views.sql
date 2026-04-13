CREATE OR REPLACE VIEW vw_reservation_summary AS
SELECT r.reservation_id, p.first_name, p.last_name,
       f.service_date, a.airport_name AS origin
FROM reservation r
JOIN reservation_passenger rp ON r.reservation_id = rp.reservation_id
JOIN person p ON rp.person_id = p.person_id
...;