/*
===============================================================================
Performance Analysis
===============================================================================

📌 Purpose:
This script evaluates product performance trends over time.  
It compares each product’s **yearly sales** to its **average historical performance**  
and identifies year-over-year changes. This helps reveal whether a product is  
performing above or below expectations, and if it's growing or declining.

✅ Key Analyses:
1️⃣ Compare yearly sales to historical average per product  
2️⃣ Detect year-over-year sales growth, decline, or consistency  
3️⃣ Segment performance into "Above Avg", "Below Avg", or "No Change"

🛠️ SQL Techniques Used:
- `Common Table Expressions (CTE)`
- `Window Functions`: `AVG() OVER()`, `LAG() OVER()`
- `CASE` logic for segmentation

🗃️ Tables Used:
- `gold.fact_sales`
- `gold.dim_products`

===============================================================================
*/

/* Analyze the yearly performance of products by comparing each product's sales 
to both its average sales performance and the previous year's sales */
WITH yearly_product_sales AS (
    SELECT 
        YEAR(s.order_date) AS order_year, 
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY YEAR(s.order_date), p.product_name
)

SELECT 
    order_year,
    product_name,
    current_sales,

    -- Average historical sales per product
    AVG(current_sales) OVER(PARTITION BY product_name) AS average_sales,

    -- Difference from average
    current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,

    -- Label: Above/Below/Avg
    CASE
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Previous year sales using LAG()
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_sales,

    -- Difference from previous year
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py_sales,

    -- Label: Increase/Decrease/No Change
    CASE
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
        WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS sales_change

FROM yearly_product_sales
ORDER BY product_name, order_year;
