DROP TABLE IF EXISTS {table_name};

CREATE TABLE {table_name} (
    event_time TIMESTAMP WITH TIME ZONE,
    event_type VARCHAR(20),
    product_id INTEGER,
    price DECIMAL(10,2),
    user_id BIGINT,
    user_session UUID
);

COPY {table_name} (event_time, event_type, product_id, price, user_id, user_session) 
FROM '{csv_path}' 
WITH (FORMAT csv, HEADER true);
