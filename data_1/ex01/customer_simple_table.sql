DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    event_time TIMESTAMP WITH TIME ZONE,
    event_type VARCHAR(20),
    product_id INTEGER,
    price DECIMAL(10,2),
    user_id BIGINT,
    user_session UUID
);

INSERT INTO customers
SELECT * FROM data_2022_oct
UNION ALL
SELECT * FROM data_2022_nov
UNION ALL
SELECT * FROM data_2022_dec
UNION ALL
SELECT * FROM data_2023_jan;


-- Add more UNION ALL statements for each data_* table you want to combine;
