/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To identify top and bottom performers among products and customers.
    - To utilize window functions for advanced ranking.

SQL Functions Used:
    - RANK(), DENSE_RANK()
    - JOIN, GROUP BY, ORDER BY

Tables Used:
    - gold.fact_sales
    - gold.dim_products
    - gold.dim_customers
===============================================================================
*/

-- Which 5 products generate the highest revenue?
SELECT TOP 5 pr.product_name, SUM(s.sales_amount) As revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS pr
ON s.product_key = pr.product_key
GROUP BY pr.product_name
ORDER BY revenue DESC

-- Window Function
SELECT * FROM 
(
	SELECT pr.product_name, SUM(s.sales_amount) As revenue,
	RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS product_rank
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS pr
	ON s.product_key = pr.product_key
	GROUP BY pr.product_name
)t
WHERE product_rank <=5

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5 pr.product_name, SUM(s.sales_amount) As revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS pr
ON s.product_key = pr.product_key
GROUP BY pr.product_name
ORDER BY revenue

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10 c.customer_id, c.first_name, c.last_name, SUM(s.sales_amount) As revenue
FROM gold.fact_sales AS s		
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY revenue DESC

-- Window Function
SELECT * FROM 
(
	SELECT c.customer_id, c.first_name, c.last_name, SUM(s.sales_amount) As revenue,
	DENSE_RANK() OVER(ORDER BY SUM(s.sales_amount) DESC) AS customer_rank
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key
	GROUP BY c.customer_id, c.first_name, c.last_name
)t
WHERE customer_Rank <=10

-- The 3 customers with the fewest orders placed
SELECT TOP 3 
	c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT s.order_number) As orders
FROM gold.fact_sales AS s		
LEFT JOIN gold.dim_customers AS c
ON s.customer_key = c.customer_key
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY orders
