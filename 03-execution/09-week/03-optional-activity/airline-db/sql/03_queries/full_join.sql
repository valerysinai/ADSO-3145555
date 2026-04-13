SELECT p.first_name, la.loyalty_account_id
FROM customer c
FULL JOIN loyalty_account la ON c.customer_id = la.customer_id
JOIN person p ON c.person_id = p.person_id;