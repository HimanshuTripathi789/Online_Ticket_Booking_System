-- joins --

SELECT 
    u.full_name,
    u.email,
    e.title AS event_title,
    e.category,
    b.status AS booking_status,
    b.total_amount,
    b.created_at
FROM users u
JOIN bookings b ON u.user_id = b.user_id
JOIN events e ON b.event_id = e.event_id;

SELECT 
    b.booking_id,
    u.full_name,
    e.title AS event_name,
    p.amount,
    p.method,
    p.status AS payment_status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN events e ON b.event_id = e.event_id
LEFT JOIN payments p ON b.booking_id = p.booking_id;

SELECT 
    e.title AS event_name,
    SUM(p.amount) AS total_revenue,
    COUNT(b.booking_id) AS total_bookings
FROM events e
JOIN bookings b ON e.event_id = b.event_id
JOIN payments p ON b.booking_id = p.booking_id
WHERE p.status = 'SUCCESS'
GROUP BY e.title;

SELECT 
    b.booking_id,
    u.full_name,
    e.title AS event_name,
    s.seat_number,
    s.seat_type,
    s.price
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN events e ON b.event_id = e.event_id
JOIN booking_items bi ON b.booking_id = bi.booking_id
JOIN seats s ON bi.seat_id = s.seat_id;
