BEGIN;

TRUNCATE TABLE booking_events RESTART IDENTITY CASCADE;
TRUNCATE TABLE hotel_bookings RESTART IDENTITY CASCADE;

INSERT INTO hotel_bookings (org_id, city, status, amount, created_at)
SELECT
    ('org' || ((n % 3) + 1))                                         AS org_id,
    (ARRAY['delhi', 'mumbai', 'pune', 'bangalore'])[(n % 4) + 1]      AS city,
    (ARRAY['booked', 'cancelled', 'completed', 'pending'])[(n % 4) + 1] AS status,
    ROUND((100 + (n * 37 % 900))::numeric, 2)                        AS amount,
    NOW() - ((n % 60) || ' days')::interval                          AS created_at
FROM generate_series(1, 100) AS n;

INSERT INTO booking_events (booking_id, event_type, event_data, created_at)
SELECT
    b.id,
    CASE b.status
        WHEN 'booked'    THEN 'booking_created'
        WHEN 'cancelled' THEN 'booking_cancelled'
        WHEN 'completed' THEN 'booking_completed'
        ELSE 'booking_pending_review'
    END AS event_type,
    jsonb_build_object('city', b.city, 'org_id', b.org_id) AS event_data,
    b.created_at
FROM hotel_bookings b;

COMMIT;