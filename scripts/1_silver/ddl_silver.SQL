/*
====================================================================================================
DDL Script: Create Silver Layer Tables
====================================================================================================

📌 PURPOSE:
This script creates the cleansed and standardized (silver) tables in the Data Warehouse pipeline. 

It performs the following actions:
1. Drops existing tables in the 'silver' schema if they exist.
2. Creates fresh tables to store processed data from CRM and ERP sources.
3. Adds a metadata column [dwh_create_date] using DATETIME2 to track data load timestamp.

These tables contain cleaned, enriched, and structured data ready for analytical modeling.

🧱 LAYER: Silver
- crm_cust_info: Cleaned CRM customer information
- crm_prd_info: Enriched CRM product data with category ID
- crm_sales_details: Cleaned CRM sales transaction data with corrected dates
- erp_cust_az12: Cleaned ERP customer data
- erp_loc_a101: ERP customer location details
- erp_px_cat_g1v2: ERP product category and maintenance information

Warnings:
⚠️ This script will DROP and RE-CREATE the listed tables in the 'silver' schema.
⚠️ All existing data in these tables will be permanently lost.
⚠️ Ensure you are running this script in a safe development or test environment.

*/

---------------------------------------------------------------------------------------------------------------
--SILVER LAYER - Creating tables
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--CRM tables
---------------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('silver.crm_cust_info' , 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

---------------------------------------------------------------------------------------------------------------
--ERP tables
---------------------------------------------------------------------------------------------------------------
IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101
CREATE TABLE silver.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

