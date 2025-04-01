-------------------------------------------------------------------------
--silver.crm_cust_info
-------------------------------------------------------------------------
--Check for NULLs or Duplicates in Primary Key
--Expectation: No Result
SELECT cst_id, COUNT(*) FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;

--Check for unwanted spaces in strings
--Expectation: No Result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

--Data Standardization & Consistency
-- Check low cardinality columns
SELECT DISTINCT(cst_marital_status)
FROM silver.crm_cust_info;

SELECT DISTINCT(cst_gndr)
FROM silver.crm_cust_info;

SELECT COUNT(*) FROM silver.crm_cust_info;


-------------------------------------------------------------------------
-- silver.crm_prd_info
-------------------------------------------------------------------------
--Check for NULLs or Duplicates in Primary Key
--Expectation: No Result
SELECT prd_id, COUNT(prd_id) FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1 AND prd_id IS NULL

--Check for unwanted spaces in strings
--Expectation: No Result
SELECT prd_nm FROM silver.crm_prd_info
WHERE prd_nm!= TRIM(prd_nm)

-- Check for NULLS or Negative Numbers
--Expectation: No Result
SELECT prd_cost FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS Null 

-- Data Standardization & Consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info

-- Check for Invalid Data Orders
--Expectation: No Result
SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info;


-------------------------------------------------------------------------
-- bronze.crm_sales_details
-------------------------------------------------------------------------
SELECT 
	sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

--Check for Invalid Dates
--Expectation: No Result
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Between Sales, Quantity, Price
-- Business Rule: sales = quantity *  price
-- Values must not be NULL or Zero or Negative numbers
SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales! = sls_quantity * sls_price OR
sls_sales <= 0 OR sls_Sales IS NULL OR
sls_quantity <= 0 OR sls_quantity IS NULL OR
sls_price <= 0 OR sls_price IS NULL

SELECT DISTINCT
	sls_sales AS old_sls_Sales,
	sls_quantity,
	sls_price As old_sls_price,
	CASE 
		WHEN sls_sales <= 0 OR sls_sales IS NULL Or sls_sales!= sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE 
		WHEN sls_price <= 0 OR sls_price IS NULL  THEN sls_sales / NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS sls_price
FROM silver.crm_sales_details

SELECT * FROM silver.crm_sales_details;


-------------------------------------------------------------------------
-- silver.erp_cust_az12
-------------------------------------------------------------------------
SELECT CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END AS cid
	FROM silver.erp_cust_az12
WHERE CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END NOT IN (SELECT cst_key FROM silver.crm_cust_info)

-- Check for Invalid Dates or Out of Range Dates
SELECT bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE() 

--  Data Standardization & Consistency (low cardinality)
SELECT 
	DISTINCT gen	
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12


-------------------------------------------------------------------------
--silver.erp_loc_a101
-------------------------------------------------------------------------
SELECT cid 
FROM silver.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)

--  Data Standardization & Consistency 
SELECT 
	DISTINCT cntry AS old_cntry,
	CASE 
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US' , 'USA') THEN 'United States'
		WHEN TRIM(cntry) ='' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM silver.erp_loc_a101;

SELECT * FROM silver.erp_loc_a101;


-------------------------------------------------------------------------
-- silver.erp_px_cat_g1v2
-------------------------------------------------------------------------
-- Check for Unwanted Spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat!= TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Stanardization & Consistency
SELECT
	DISTINCT cat
FROM silver.erp_px_cat_g1v2

SELECT
	DISTINCT subcat
FROM silver.erp_px_cat_g1v2

SELECT
	DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

SELECT * FROM silver.erp_px_cat_g1v2
