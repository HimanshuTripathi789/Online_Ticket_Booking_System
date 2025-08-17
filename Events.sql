-- Example event
INSERT INTO events (event_id, venue_id, title, category, starts_at, ends_at, status)
SELECT UUID(), v.venue_id, 'Blockbuster Premiere', 'Movie', NOW()+INTERVAL 1 DAY, NOW()+INTERVAL 1 DAY + INTERVAL 3 HOUR, 'ONSALE'
FROM venues v WHERE v.name='City Multiplex Hall 1'
LIMIT 1;

select * from events;