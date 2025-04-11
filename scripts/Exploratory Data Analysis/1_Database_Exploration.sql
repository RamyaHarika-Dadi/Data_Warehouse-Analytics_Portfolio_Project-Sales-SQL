-- Explore all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore all the columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Explore columns of specific table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';