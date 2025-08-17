-- 6) VIEWS

CREATE OR REPLACE VIEW v_event_inventory AS
SELECT e.event_id, e.title, e.starts_at,
       SUM(es.status='AVAILABLE') AS available,
       SUM(es.status='HELD') AS held,
       SUM(es.status='BOOKED') AS booked,
       COUNT(*) AS total_seats
FROM events e
JOIN event_seats es ON es.event_id = e.event_id
GROUP BY e.event_id;

CREATE OR REPLACE VIEW v_revenue_by_event AS
SELECT e.event_id, e.title,
       SUM(b.total_amount) AS total_revenue,
       SUM(b.status='CONFIRMED') AS confirmed_bookings,
       SUM(b.status='CANCELLED') AS cancelled_bookings
FROM events e
LEFT JOIN bookings b ON b.event_id = e.event_id
GROUP BY e.event_id, e.title;

CREATE OR REPLACE VIEW v_user_booking_history AS
SELECT u.user_id, u.full_name, u.email, b.booking_id, b.status, b.total_amount, b.created_at,
       e.title AS event_title, e.starts_at
FROM users u
JOIN bookings b ON b.user_id = u.user_id
JOIN events e ON e.event_id = b.event_id;
