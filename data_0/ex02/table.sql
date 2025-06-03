-- import.sql
DROP TABLE IF EXISTS data_2022_oct;

CREATE TABLE data_2022_oct (
    event_time TIMESTAMP WITH TIME ZONE,
    event_type VARCHAR(20),
    product_id INTEGER,
    price DECIMAL(10,2),
    user_id BIGINT,
    user_session UUID
);

-- Verify file access first
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_ls_dir('/customer') WHERE pg_ls_dir = 'data_2022_oct.csv') THEN
        RAISE EXCEPTION 'CSV file not found in /customer/';
    END IF;
END $$;

-- Import with explicit columns
COPY data_2022_oct (event_time, event_type, product_id, price, user_id, user_session) 
FROM '/customer/data_2022_oct.csv' 
WITH (FORMAT csv, HEADER true);

-- Verify import
DO $$
BEGIN
    IF (SELECT COUNT(*) FROM data_2022_oct) = 0 THEN
        RAISE EXCEPTION 'No data imported!';
    END IF;
END $$;
