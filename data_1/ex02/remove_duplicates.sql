-- DO $$
-- BEGIN
--     CREATE TABLE customers_dedup AS
--     WITH ordered AS (
--         SELECT *,
--                LAG(event_time) OVER (
--                    PARTITION BY user_id, product_id, user_session
--                    ORDER BY event_time
--                ) AS prev_event_time
--         FROM customers
--     ),
--     grouped AS (
--         SELECT *,
--             CASE
--                 WHEN prev_event_time IS NULL THEN 1
--                 WHEN EXTRACT(EPOCH FROM (event_time - prev_event_time)) > 1 THEN 1
--                 ELSE 0
--             END AS new_group_marker
--         FROM ordered
--     ),
--     numbered AS (
--         SELECT *,
--                SUM(new_group_marker) OVER (
--                    PARTITION BY user_id, product_id, user_session
--                    ORDER BY event_time
--                    ROWS UNBOUNDED PRECEDING
--                ) AS group_num
--         FROM grouped
--     ),
--     deduped AS (
--         SELECT *,
--                ROW_NUMBER() OVER (
--                    PARTITION BY user_id, product_id, user_session, group_num
--                    ORDER BY event_time
--                ) AS rn
--         FROM numbered
--     )
--     SELECT event_time, event_type, product_id, price, user_id, user_session
--     FROM deduped
--     WHERE rn = 1;

--     DROP TABLE customers;
--     ALTER TABLE customers_dedup RENAME TO customers;

--     RAISE NOTICE 'Duplicates removed from customers table successfully (time-window based, ignoring event_type).';
-- END $$;



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

SELECT COUNT(*) AS remaining_rows FROM customers;
RAISE NOTICE 'Duplicates removed from customers table successfully (time-window based, ignoring event_type).';
