/*
===============================================================================
Customer Report (gold.report_customers)
===============================================================================

📌 Purpose:
This script creates a reporting view that consolidates detailed customer metrics  
for performance analysis, segmentation, and business intelligence reporting.

✅ Highlights:
1️⃣ Gathers key customer information (name, age, orders, sales, etc.)  
2️⃣ Segments customers into:
    - Age Groups: Under 20, 20–29, 30–39, 40–49, 50+  
    - Behavior Segments: VIP, Regular, New  
3️⃣ Calculates KPIs including:
    - Total Orders, Sales, Quantity  
    - Recency (months since last order)  
    - Average Order Value  
    - Average Monthly Spend  

🗃️ Tables Used:
- gold.fact_sales  
- gold.dim_customers  

===============================================================================
*/

-- =============================================================================
-- 🛠️ Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

-- 1️⃣ Base Query: Join fact and dimension data
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE order_date IS NOT NULL
),

-- 2️⃣ Aggregation per customer
customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)

-- 3️⃣ Final View Output
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- 🎯 Age Banding
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20–29'
        WHEN age BETWEEN 30 AND 39 THEN '30–39'
        WHEN age BETWEEN 40 AND 49 THEN '40–49'
        ELSE '50 and above'
    END AS age_group,

    -- 🧠 Customer Segmentation based on sales & lifespan
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    last_order_date,
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    -- Average Order Value (AOV)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,

    -- Average Monthly Spend
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;
