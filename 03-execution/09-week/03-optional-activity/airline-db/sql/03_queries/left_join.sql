SELECT f.flight_id, fs.segment_number
FROM flight f
LEFT JOIN flight_segment fs ON f.flight_id = fs.flight_id;