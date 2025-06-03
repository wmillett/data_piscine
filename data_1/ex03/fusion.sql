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
LEFT JOIN 
    items i ON c.product_id = i.product_id;
