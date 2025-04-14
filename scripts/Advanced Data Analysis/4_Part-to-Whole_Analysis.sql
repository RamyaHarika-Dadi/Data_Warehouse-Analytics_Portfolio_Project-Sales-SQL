/*
===============================================================================
Part-to-Whole Analysis (Proportional Analysis)
===============================================================================

📌 Purpose:
This analysis identifies how much each **product category** contributes  
to the **overall sales** by calculating proportional revenue share.  
It provides insight into which categories are driving the most value.

✅ Key Analyses:
1️⃣ Total sales by product category  
2️⃣ Contribution of each category as a percentage of overall sales  
3️⃣ Ranked output to show top contributors first

🛠️ SQL Techniques Used:
- Common Table Expressions (CTEs)
- Window functions: `SUM() OVER()`
- Percentage calculations using `CAST()` and `ROUND()`

🗃️ Tables Used:
- `gold.fact_sales`  
- `gold.dim_products`

===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales As (
SELECT 
	p.category,
	SUM(s.sales_amount) As total_sales
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products As p
ON s.product_key = p.product_key
GROUP BY p.category)

SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER())*100,2), '%') AS percentage_of_sales
FROM category_sales
ORDER BY total_sales DESC
