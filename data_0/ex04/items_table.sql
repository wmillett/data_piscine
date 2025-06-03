DROP TABLE IF EXISTS items;

CREATE TABLE items (
    product_id INTEGER,
    category_id BIGINT,
    category_code VARCHAR(255),
    brand VARCHAR(255)
);

COPY items (product_id, category_id, category_code, brand)
FROM 'item/item.csv'
WITH (FORMAT csv, HEADER true);
