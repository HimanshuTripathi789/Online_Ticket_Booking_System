-- 5) TRIGGERS

DELIMITER //

-- Prevent double-booking seats
CREATE TRIGGER trg_prevent_double_booking BEFORE INSERT ON booking_items
FOR EACH ROW
BEGIN
    DECLARE v_status VARCHAR(20);
    SELECT status INTO v_status FROM event_seats es
    JOIN bookings b ON b.event_id = es.event_id
    WHERE b.booking_id = NEW.booking_id AND es.seat_id = NEW.seat_id FOR UPDATE;

    IF v_status = 'BOOKED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Seat already booked';
    END IF;

    UPDATE event_seats es
    JOIN bookings b ON b.event_id = es.event_id
    SET es.status='HELD', es.held_until=DATE_ADD(NOW(), INTERVAL 15 MINUTE)
    WHERE b.booking_id = NEW.booking_id AND es.seat_id = NEW.seat_id;
END;//

-- Release seats when booking cancelled
CREATE TRIGGER trg_release_seats AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF NEW.status='CANCELLED' AND OLD.status <> 'CANCELLED' THEN
        UPDATE event_seats es
        JOIN booking_items bi ON bi.seat_id = es.seat_id
        SET es.status='AVAILABLE', es.held_until=NULL
        WHERE bi.booking_id = NEW.booking_id;
    END IF;
END;//

DELIMITER ;

