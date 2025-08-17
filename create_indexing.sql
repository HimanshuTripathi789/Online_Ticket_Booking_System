-- 4) INDEXES

 CREATE INDEX idx_users_email ON users(email); 
CREATE INDEX idx_events_venue_time ON events(venue_id, starts_at);
CREATE INDEX idx_event_seats_status ON event_seats(event_id, status);
CREATE INDEX idx_bookings_user ON bookings(user_id, created_at);
CREATE INDEX idx_payments_booking_status ON payments(booking_id, status);