/*
===============================================================================
Date Exploration
===============================================================================
Purpose:
    - To understand the timeline of sales and customer age distribution.
    - To evaluate the time range of transactions and customer demographics.

SQL Functions Used:
    - MIN(), MAX()
    - DATEDIFF()

Tables Used:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- Find the date of the first and last order
SELECT 
    MIN(order_date) AS first_order_date, 
    MAX(order_date) AS last_order_date
FROM gold.fact_sales;

-- Order span in years and months
SELECT 
    MIN(order_date) AS first_order_date, 
    MAX(order_date) AS last_order_date,
    DATEDIFF(year, MIN(order_date),MAX(order_date)) AS total_orders_years,
    DATEDIFF(month, MIN(order_date),MAX(order_date)) AS total_orders_months
FROM gold.fact_sales;

-- Find the youngest and the oldest customer
SELECT 
    MIN(birth_date) AS oldest_customer_bdate,
    DATEDIFF(year, MIN(birth_date), GETDATE()) AS older_customer_age,
    MAX(birth_date) AS youngest_customer_bdate,
    DATEDIFF(year, MAX(birth_date), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;
