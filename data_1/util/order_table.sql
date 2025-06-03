-- After deduplication:

CREATE TABLE customers_ordered AS
SELECT *
FROM customers
ORDER BY event_time;

DROP TABLE customers;
ALTER TABLE customers_ordered RENAME TO customers;

-- Optionally create an index on event_time for faster sorting/searching
--CREATE INDEX idx_customers_event_time ON customers(event_time);
