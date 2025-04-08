/*
=======================================================================================
📊 Exploratory Data Analysis (EDA) Script - SQL Data Warehouse Project
=======================================================================================

📌 Purpose:
This script performs Exploratory Data Analysis (EDA) on the final analytical layer (Gold Layer)  
of the SQL Data Warehouse. It helps uncover key insights, understand patterns, and validate  
data quality before reporting and BI.

✅ The analysis includes:
1️⃣ Database Exploration: List all tables and columns to understand the database structure.
2️⃣ Dimensions Exploration: Explore customer countries, genders, and product categories.
3️⃣ Date Exploration: Analyze order date ranges and customer age distribution.
4️⃣ Measures Exploration: Calculate core business metrics like total sales, quantity sold, average price, and total orders.
5️⃣ Magnitude Analysis: Group sales and customer counts by location, category, and demographics.
6️⃣ Ranking Analysis: Use window functions to identify top and bottom products and customers.

🗃️ Tables Used:
- gold.dim_customers: Cleaned customer data  
- gold.dim_products: Product metadata and hierarchy  
- gold.fact_sales: Sales fact table used for KPIs and aggregations

⚠️ WARNINGS:
⚠️ This script is designed for data analysis only — it does not modify any tables.  
⚠️ Results may vary if source data is updated or transformed.  
⚠️ For best use, execute queries section-by-section in SQL Server Management Studio (SSMS).

=======================================================================================
*/

-- ------------------------------------------------------------------------------------
-- Database Exploration
-- ------------------------------------------------------------------------------------
-- Explore all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all the columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'


-- ------------------------------------------------------------------------------------
-- Dimensions Exploration
-- ------------------------------------------------------------------------------------
-- Explore all countries our custommers come from
SELECT DISTINCT country FROM gold.dim_customers

--Explore all Categories "The major Divisions"
SELECT DISTINCT category FROM gold.dim_products

SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3


-- ------------------------------------------------------------------------------------
-- Date Exploration
-- ------------------------------------------------------------------------------------
-- Find the date of the first and last order
SELECT 
	MIN(order_date) AS first_order_date, 
	MAX(order_date) AS last_order_date
FROM gold.fact_sales

SELECT 
	MIN(order_date) AS first_order_date, 
	MAX(order_date) AS last_order_date,
	DATEDIFF(year, MIN(order_date),MAX(order_date)) AS total_orders_years,
	DATEDIFF(month, MIN(order_date),MAX(order_date)) AS total_orders_months
FROM gold.fact_sales

-- Find the youngest and the oldest customer
SELECT 
	MIN(birth_date) AS oldest_customer_bdate,
	DATEDIFF(year, MIN(birth_date), GETDATE()) AS older_customer_age,
	MAX(birth_date) As youngest_customer_bdate,
	DATEDIFF(year, MAX(birth_date), GETDATE()) AS youngest_customer_age
FROm gold.dim_customers


-- ------------------------------------------------------------------------------------
-- Measures Exploration
-- ------------------------------------------------------------------------------------
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


-- ------------------------------------------------------------------------------------
-- Magnitude Analysis
-- ------------------------------------------------------------------------------------
SELECT * FROM gold.dim_customers 
SELECT * FROM gold.dim_products
SELECT * FROM gold.fact_Sales

-- Find total number customers by countries
SELECT 
	country, 
	COUNT(customer_key) As total_customers 
FROM gold.dim_customers 
GROUP BY country
ORDER BY total_customers DESC

-- Find total customers by gender
SELECT 
	gender, 
	COUNT(customer_key) As total_customers 
FROM gold.dim_customers 
GROUP BY gender
ORDER BY total_customers DESC

-- Find total products by category
SELECT 
	category, 
	COUNT(product_key) As total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

-- What is the average cost in each category?
SELECT 
	category, 
	AVG(cost) As average_cost 
FROM gold.dim_products 
GROUP BY category
ORDER BY average_cost DESC

-- What is the total revenue generated for each category?
SELECT 
	pr.category, 
	SUM(s.sales_amount) As total_revenue 
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products As pr
ON s.product_key = pr.product_key
GROUP BY pr.category
ORDER BY total_revenue DESC

-- Find total revenue is generated by each customer
SELECT 
	cu.customer_key, 
	cu.first_name,
	cu.last_name,
	SUM(s.sales_amount) As total_revenue 
FROM gold.fact_sales AS s 
LEFT JOIN gold.dim_customers As cu
ON s.customer_key = cu.customer_key
GROUP BY cu.customer_key, cu.first_name, cu.last_name
ORDER BY total_revenue DESC

-- What is the distribution of sold items across countries?
SELECT 
	cu.country, 
	SUM(s.quantity) AS sold_items 
FROM gold.fact_sales AS s 
LEFT JOIN gold.dim_customers As cu
ON s.customer_key = cu.customer_key
GROUP BY cu.country
ORDER BY sold_items DESC

-- ------------------------------------------------------------------------------------
-- Ranking Analysis
-- ------------------------------------------------------------------------------------
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
