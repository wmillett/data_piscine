CREATE TABLE customer_events_enriched AS
SELECT 
    c.event_time,
    c.event_type,
    c.product_id,
    c.price,
    c.user_id,
    c.user_session,
    i.category_id,
    i.category_code,
    i.brand
FROM 
    customers c
LEFT JOIN (
    SELECT DISTINCT ON (product_id) *
    FROM items
    WHERE brand IS NOT NULL -- optional: prefer non-null brands
    ORDER BY product_id, brand DESC -- or some other criteria
) i ON c.product_id = i.product_id;


-- Replace the original customers table with the enriched version
-- Note: This will drop the original customers table and rename the enriched table
DROP TABLE IF EXISTS customers;
ALTER TABLE customer_events_enriched RENAME TO customers;