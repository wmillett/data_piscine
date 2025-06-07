WITH Duplicates as (
    SELECT ctid
    FROM (
        SELECT
            ctid,
            event_type,
            product_id,
            event_time,
            LAG(event_time) OVER (
                PARTITION BY user_id, product_id, user_session
                ORDER BY event_time
            ) AS prev_event_time
        FROM customers
    ) sub 
    WHERE
        prev_event_time IS NOT NULL AND ABS(
            EXTRACT(EPOCH FROM (event_time - prev_event_time))
        ) <= 1
)
DELETE FROM customers
WHERE ctid IN (SELECT ctid FROM Duplicates);



-- Remove duplicates from items table
DELETE FROM items
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM items
    GROUP BY product_id, category_id, category_code, brand
);




--- Check remaining rows in customers and items tables
SELECT COUNT(*) AS remaining_rows FROM customers;
SELECT COUNT(*) AS remaining_items FROM items;


--RAISE NOTICE 'Duplicates removed from customers table successfully (time-window based, ignoring event_type).';
