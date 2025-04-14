/*
===============================================================================
Cumulative Analysis
===============================================================================

📌 Purpose:
This script calculates cumulative metrics to track progressive performance over time.  
It includes monthly total sales, running totals, and moving average prices to identify  
growth trends and seasonal patterns.

✅ Key Analyses:
1️⃣ Monthly Aggregation of Sales and Average Prices  
2️⃣ Running Total of Sales (Unpartitioned and Partitioned by Year)  
3️⃣ Moving Average Pricing Over Time  

🛠️ SQL Techniques Used:
- Window Functions: `SUM() OVER()`, `AVG() OVER()`  
- Date Functions: `DATETRUNC()`, `YEAR()`  
- Subqueries for monthly groupings

🗃️ Tables Used:
- `gold.fact_sales`

⚠️ Results reflect trends based on current Gold Layer data.
===============================================================================
*/


-- Calculate the total sales per month and the running total of sales over time, moving average price
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
	AVG(average_price) OVER(ORDER BY order_Date) AS moving_average_price
FROM
(SELECT 
	DATETRUNC(month, order_date) AS order_date, 
	SUM(sales_amount) AS total_sales,
	AVG(price) AS average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date))t

--------------------------------------------------------------
-- Analyze growth patterns within each year by resetting running totals and averages yearly

SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales,
	AVG(average_price) OVER(PARTITION BY YEAR(order_date) ORDER BY order_Date) AS moving_average_price
FROM
(SELECT 
	DATETRUNC(month, order_date) AS order_date, 
	SUM(sales_amount) AS total_sales,
	AVG(price) AS average_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date))t


-
