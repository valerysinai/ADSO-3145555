SELECT a.airport_name, fs.flight_id
FROM flight_segment fs
RIGHT JOIN airport a ON fs.origin_airport_id = a.airport_id;