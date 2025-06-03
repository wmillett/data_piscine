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

    RAISE NOTICE 'Customers table created and populated successfully.';
END $$;
