CREATE DATABASE IF NOT EXISTS ticketing;
USE ticketing;

CREATE TABLE IF NOT EXISTS users (
    user_id         CHAR(36) PRIMARY KEY,
    full_name       VARCHAR(255) NOT NULL,
    email           VARCHAR(255) UNIQUE NOT NULL,
    phone_e164      VARCHAR(20),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS venues (
    venue_id        CHAR(36) PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    address_line1   VARCHAR(255),
    address_line2   VARCHAR(255),
    city            VARCHAR(100),
    state           VARCHAR(100),
    country         VARCHAR(50) DEFAULT 'IN',
    postal_code     VARCHAR(20),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS events (
    event_id        CHAR(36) PRIMARY KEY,
    venue_id        CHAR(36) NOT NULL,
    title           VARCHAR(255) NOT NULL,
    category        ENUM('Movie','Concert','Bus','Train','Flight','Sports','Theatre','Other') NOT NULL,
    starts_at       DATETIME NOT NULL,
    ends_at         DATETIME NOT NULL,
    status          ENUM('DRAFT','ONSALE','CLOSED','CANCELLED') NOT NULL,
    base_currency   VARCHAR(10) DEFAULT 'INR',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_event_times CHECK (ends_at > starts_at),
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id)
);

CREATE TABLE IF NOT EXISTS seats (
    seat_id         CHAR(36) PRIMARY KEY,
    venue_id        CHAR(36) NOT NULL,
    section         VARCHAR(50) NOT NULL,
    row_label       VARCHAR(10) NOT NULL,
    seat_number     VARCHAR(10) NOT NULL,
    seat_type       ENUM('REGULAR','VIP','PREMIUM','ACCESSIBLE') NOT NULL,
    base_price      DECIMAL(10,2) NOT NULL,
    UNIQUE (venue_id, section, row_label, seat_number),
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id)
);

CREATE TABLE IF NOT EXISTS event_seats (
    event_id        CHAR(36) NOT NULL,
    seat_id         CHAR(36) NOT NULL,
    price_override  DECIMAL(10,2),
    status          ENUM('AVAILABLE','HELD','BOOKED') DEFAULT 'AVAILABLE',
    held_until      DATETIME,
    PRIMARY KEY (event_id, seat_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

CREATE TABLE IF NOT EXISTS promotions (
    promo_code      VARCHAR(50) PRIMARY KEY,
    description     VARCHAR(255),
    percent_off     DECIMAL(5,2),
    max_discount    DECIMAL(10,2),
    valid_from      DATETIME NOT NULL,
    valid_to        DATETIME NOT NULL,
    usage_limit     INT,
    used_count      INT DEFAULT 0,
    active          BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_id      CHAR(36) PRIMARY KEY,
    user_id         CHAR(36) NOT NULL,
    event_id        CHAR(36) NOT NULL,
    status          ENUM('PENDING','HELD','CONFIRMED','CANCELLED') DEFAULT 'PENDING',
    hold_expires_at DATETIME,
    total_amount    DECIMAL(12,2) DEFAULT 0,
    currency        VARCHAR(10) DEFAULT 'INR',
    promo_code      VARCHAR(50),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (promo_code) REFERENCES promotions(promo_code)
);

CREATE TABLE IF NOT EXISTS booking_items (
    booking_item_id CHAR(36) PRIMARY KEY,
    booking_id      CHAR(36) NOT NULL,
    seat_id         CHAR(36) NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    tax_amount      DECIMAL(10,2) DEFAULT 0,
    fee_amount      DECIMAL(10,2) DEFAULT 0,
    UNIQUE (booking_id, seat_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id      CHAR(36) PRIMARY KEY,
    booking_id      CHAR(36) NOT NULL,
    method          ENUM('CARD','UPI','NETBANKING','WALLET','COD') NOT NULL,
    amount          DECIMAL(12,2) NOT NULL,
    status          ENUM('INITIATED','AUTHORIZED','CAPTURED','FAILED','REFUNDED','PARTIALLY_REFUNDED') DEFAULT 'INITIATED',
    txn_ref         VARCHAR(100),
    paid_at         DATETIME,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE IF NOT EXISTS refunds (
    refund_id       CHAR(36) PRIMARY KEY,
    payment_id      CHAR(36) NOT NULL,
    amount          DECIMAL(12,2) NOT NULL,
    status          ENUM('REQUESTED','PROCESSING','COMPLETED','FAILED') NOT NULL,
    processed_at    DATETIME,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
);
