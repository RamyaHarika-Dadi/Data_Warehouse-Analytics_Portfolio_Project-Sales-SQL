/*
===============================================================================
Measures Exploration
===============================================================================
Purpose:
    - To calculate business performance metrics such as sales, quantity, price, and volume.

SQL Functions Used:
    - SUM(), AVG(), COUNT()
    - UNION ALL

Tables Used:
    - gold.fact_sales
    - gold.dim_products
    - gold.dim_customers
===============================================================================
*/

-- Find the total sales
SELECT SUM(sales_amount) As total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

-- Find the total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total numbers of products
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(DISTINCT customer_key) As total_customers FROM gold.dim_customers

-- Find the total number of customers that placed an order
SELECT COUNT(DISTINCT customer_key) As total_customers FROM gold.fact_sales

-- Generate Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Products' AS measure_name, COUNT(DISTINCT product_key) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Customers' AS measure_name, COUNT(DISTINCT customer_key) As measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Order Placed Customers' AS measure_name, COUNT(DISTINCT customer_key) As measure_value FROM gold.fact_sales
