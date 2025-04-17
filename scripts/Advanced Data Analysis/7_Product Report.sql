/*
===============================================================================
Product Report (gold.report_products)
===============================================================================

📌 Purpose:
This script creates a product-level reporting view in the Gold Layer that aggregates  
key metrics, segments product performance, and helps support BI reporting and insights.

✅ Highlights:
1️⃣ Extracts key product metadata (name, category, subcategory, cost)  
2️⃣ Segments products based on total sales:
    - High-Performer: > $50,000  
    - Mid-Range: $10,000–$50,000  
    - Low-Performer: < $10,000  
3️⃣ Calculates performance indicators:
    - Total Orders, Sales, Quantity  
    - Unique Customers  
    - Lifespan (months since first to last sale)  
    - Recency (months since last sale)  
    - Average Selling Price  
    - AOR: Average Order Revenue  
    - Monthly Revenue  

🗃️ Tables Used:
- gold.fact_sales  
- gold.dim_products  

===============================================================================
*/

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

-- 1️⃣ Base Query: Join fact and dimension tables
WITH base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
),

-- 2️⃣ Product Aggregation Metrics
product_aggregations AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- 3️⃣ Final Output: Metrics + Segmentation
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,

    -- Product Segmentation based on revenue
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    -- Average Order Revenue (AOR)
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    -- 📆 Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregations;
