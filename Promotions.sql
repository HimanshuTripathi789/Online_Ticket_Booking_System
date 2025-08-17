-- Example promo
INSERT INTO promotions (promo_code, description, percent_off, max_discount, valid_from, valid_to, usage_limit, active)
VALUES ('WELCOME10', '10% off for first-time users', 10.0, 200.00, NOW(), NOW() + INTERVAL 30 DAY, 1000, TRUE)
ON DUPLICATE KEY UPDATE promo_code=promo_code;

select * from promotions;