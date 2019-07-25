SELECT table_name, engine, row_format, table_rows, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "size (mb)"
FROM information_schema.tables
WHERE table_schema = "<database>"
ORDER BY (data_length + index_length) DESC;
