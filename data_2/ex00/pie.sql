SELECT event_type, COUNT(*) as count
FROM customers
GROUP BY event_type;
