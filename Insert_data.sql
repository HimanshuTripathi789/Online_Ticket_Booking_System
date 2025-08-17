-- 7) SAMPLE DATA

INSERT INTO users (user_id, full_name, email, phone_e164)
VALUES (UUID(), 'Aarav Mehta', 'aarav@example.com', '+919876543210')
ON DUPLICATE KEY UPDATE email=email;

-- select * from users; --

INSERT INTO venues (venue_id, name, address_line1, city, state, country, postal_code)
VALUES (UUID(), 'City Multiplex Hall 1', 'MG Road', 'Bengaluru', 'KA', 'IN', '560001')
ON DUPLICATE KEY UPDATE name=name;

select * from venues;