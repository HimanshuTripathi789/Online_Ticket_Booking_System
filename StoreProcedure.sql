-- store procedure --


DELIMITER //

CREATE PROCEDURE sp_create_booking(
    IN p_user_id CHAR(36),
    IN p_event_id CHAR(36),
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE new_booking_id CHAR(36);
    SET new_booking_id = UUID();

    -- Insert booking
    INSERT INTO bookings (booking_id, user_id, event_id, status, total_amount)
    VALUES (new_booking_id, p_user_id, p_event_id, 'PENDING', p_amount);

    -- Insert payment
    INSERT INTO payments (payment_id, booking_id, amount, method, status)
    VALUES (UUID(), new_booking_id, p_amount, 'CARD', 'INITIATED');

    SELECT new_booking_id AS booking_id;
END;//

DELIMITER ;

