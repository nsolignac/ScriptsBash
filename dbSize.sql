/*
SOURCE: https://www.a2hosting.com/kb/developer-corner/mysql/determining-the-size-of-mysql-databases-and-tables
*/

SELECT table_schema AS "Database",
ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 2) AS "Size (GB)"
FROM information_schema.TABLES
GROUP BY table_schema;
