/*
===============================================================================
Data Segmentation
===============================================================================

📌 Purpose:
This analysis segments products and customers into meaningful groups  
based on cost and spending behavior. These insights help in profiling,  
targeting, and understanding business distribution across various ranges.

✅ Key Analyses:
1️⃣ Product Segmentation: Group products into cost bands  
2️⃣ Customer Segmentation: Group customers into VIP, Regular, and New  
   - VIP: At least 12 months of order history and spending > $5000  
   - Regular: At least 12 months history but spending ≤ $5000  
   - New: Less than 12 months of order history  

🛠️ SQL Techniques Used:
- Common Table Expressions (CTEs)
- Conditional logic using `CASE WHEN`
- Aggregation using `SUM()`, `COUNT()`, and `DATEDIFF()`

🗃️ Tables Used:
- `gold.dim_products`
- `gold.fact_sales`
- `gold.dim_customers`

===============================================================================
*/

/* Segment  products into cost ranges and count how many products fall into each segment */
WITH product_segments AS
(SELECT 
	product_key,
	product_name,
	cost,
	CASE 
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		ELSE 'Above 1000'
	END AS cost_range
FROM gold.dim_products)

SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based in their spending behaviour
- VIP: at least 12 months of history and spending more than 5000
- Regular: at least 12 months of history and spending 5000 or less
- New: lifespan less than 12 months
And find the total number of customers by each group
*/
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
    SELECT 
        customer_key,
        CASE 
            WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;
