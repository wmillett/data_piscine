DO $$
DECLARE
    -- Declare a record variable to hold table names
    table_record RECORD;
    sql_query TEXT := 'DROP TABLE IF EXISTS customers;';
BEGIN
    -- Start building the SQL query
    sql_query := sql_query || 'CREATE TABLE customers (LIKE data_2022_oct INCLUDING ALL);';

    -- Loop through all tables with the prefix 'data_'
    FOR table_record IN
        SELECT tablename
        FROM pg_tables
        WHERE tablename LIKE 'data_%'
    LOOP
        sql_query := sql_query || 'INSERT INTO customers SELECT * FROM ' || table_record.tablename || ';';
    END LOOP;

    -- Execute the dynamically generated SQL
    EXECUTE sql_query;

    -- Remove duplicates from the customers table
    --EXECUTE 'CREATE TABLE customers_temp AS SELECT DISTINCT ON (event_type, product_id, event_time) * FROM customers ORDER BY event_type, product_id, event_time;';
    --EXECUTE 'TRUNCATE TABLE customers;';
    --EXECUTE 'INSERT INTO customers SELECT * FROM customers_temp;';
    --EXECUTE 'DROP TABLE customers_temp;';

    EXECUTE 'DELETE FROM customers a USING customers b WHERE a.ctid < b.ctid AND a.event_time = b.event_time AND a.event_type = b.event_type AND a.product_id = b.product_id AND a.price = b.price AND a.user_id = b.user_id AND a.user_session = b.user_session;';

    RAISE NOTICE 'Customers table created and populated successfully.';
END $$;
