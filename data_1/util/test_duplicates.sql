DO $$
DECLARE
    count_result BIGINT;
BEGIN
    RAISE NOTICE 'Testing for duplicates in the customers table...';
    RAISE NOTICE 'The following count should be of 1 if there are no duplicates:';

    SELECT COUNT(*) INTO count_result
    FROM customers
    WHERE event_time = '2022-10-01 00:00:30'
      AND event_type = 'remove_from_cart'
      AND product_id = 5809103;
    RAISE NOTICE 'Count: %', count_result;

    RAISE NOTICE 'The following count should be of 1 and 0 if there are no duplicates:';

    SELECT COUNT(*) INTO count_result
    FROM customers
    WHERE event_time = '2022-10-01 00:00:32'
      AND event_type = 'remove_from_cart'
      AND product_id = 5779403;
    RAISE NOTICE 'Count: %', count_result;

    SELECT COUNT(*) INTO count_result
    FROM customers
    WHERE event_time = '2022-10-01 00:00:33'
      AND event_type = 'remove_from_cart'
      AND product_id = 5779403;
    RAISE NOTICE 'Count: %', count_result;

    RAISE NOTICE 'The following count should be of 1 and 1 and not lower:';

    SELECT COUNT(*) INTO count_result
    FROM customers
    WHERE event_time = '2022-10-01 00:04:15'
      AND event_type = 'remove_from_cart'
      AND product_id = 5692893;
    RAISE NOTICE 'Count: %', count_result;

    SELECT COUNT(*) INTO count_result
    FROM customers
    WHERE event_time = '2022-10-01 00:04:15'
      AND event_type = 'remove_from_cart'
      AND product_id = 5802443;
    RAISE NOTICE 'Count: %', count_result;

    RAISE NOTICE 'The following count should be between 18500000 and 19200000:';

    SELECT COUNT(*) INTO count_result
    FROM customers;
    RAISE NOTICE 'Count: %', count_result;
END $$;
