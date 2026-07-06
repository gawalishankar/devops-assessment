BEGIN;

CREATE TABLE IF NOT EXISTS hotel_bookings (
    id          BIGSERIAL PRIMARY KEY,
    org_id      TEXT NOT NULL,
    city        TEXT NOT NULL,
    status      TEXT NOT NULL CHECK (status IN ('booked', 'cancelled', 'completed', 'pending')),
    amount      NUMERIC(10, 2) NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS booking_events (
    id          BIGSERIAL PRIMARY KEY,
    booking_id  BIGINT NOT NULL REFERENCES hotel_bookings(id) ON DELETE CASCADE,
    event_type  TEXT NOT NULL,
    event_data  JSONB DEFAULT '{}'::jsonb,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_booking_events_booking_id ON booking_events(booking_id);

COMMIT;