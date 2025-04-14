/*
===============================================================================
📈 Change Over Time Analysis
===============================================================================

📌 Purpose:
This script analyzes sales trends and customer behavior over time.  
It breaks down metrics by year, month, and formatted periods to highlight  
temporal performance patterns and customer acquisition rates.

✅ Key Analyses:
1️⃣ Yearly Sales and Customer Trends  
2️⃣ Monthly Trends Using `YEAR`, `MONTH`, `DATETRUNC`, and `FORMAT`  
3️⃣ Running totals and average prices over time  
4️⃣ New customer acquisition trends year-over-year

🛠️ SQL Techniques Used:
- DATE Functions: `YEAR()`, `MONTH()`, `DATETRUNC()`, `FORMAT()`  
- Aggregations: `SUM()`, `COUNT()`  
- Filtering & Sorting

🗃️ Tables Used:
- `gold.fact_sales`
- `gold.dim_customers`

⚠️ Results reflect current data in the Gold Layer.
===============================================================================
*/

-- Analyze Sales Performance over Time
SELECT * FROM gold.fact_sales

-- Change over year
SELECT 
	YEAR(order_date) AS order_year, 
	sum(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(Quantity) AS total_quantity
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year

--change over year,month
SELECT 
	YEAR(order_date) AS order_year, 
	MONTH(order_date) AS order_month, 
	sum(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(Quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date) 
ORDER BY order_year, order_month

SELECT 
	DATETRUNC(month, order_date) AS order_date, 
	sum(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(Quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date) 
ORDER BY DATETRUNC(month, order_date)

SELECT 
	FORMAT(order_date, 'yyyy-MMM') AS order_date, 
	sum(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(Quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

-- How many new customers were added each year
SELECT 
	YEAR(create_date) AS create_year, 
	COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY YEAR(create_date)
ORDER BY YEAR(create_date)
