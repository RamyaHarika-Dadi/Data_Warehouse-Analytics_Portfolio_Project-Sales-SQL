/*
====================================================================================================
DDL Script: Create Bronze Layer Tables
====================================================================================================

📌 PURPOSE:
This script creates raw staging (bronze) tables used for initial data ingestion in the Data Warehouse pipeline. 

It performs the following actions:
1. Drops existing tables in the 'bronze' schema if they exist.
2. Creates fresh staging tables for raw CRM and ERP data ingestion.
These tables reflect the source data from CRM and ERP systems.

🧱 LAYER: Bronze
- crm_cust_info: CRM customer information
- crm_prd_info: CRM product data
- crm_sales_details: CRM sales transactions
- erp_cust_az12: ERP customer basic data
- erp_loc_a101: ERP location data
- erp_px_cat_g1v2: ERP product category and maintenance data

Warnings:
⚠️ This script will DROP and RE-CREATE the listed tables in the 'bronze' schema.
⚠️ All existing data in these tables will be permanently lost.
⚠️ Ensure you are running this script in a safe development or test environment.

*/

-- Create CRM tables in bronze layer
IF OBJECT_ID ('bronze.crm_cust_info' , 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_num NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATETIME
);

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_shit_date INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

-- Create ERP tables in bronze layer
IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101
CREATE TABLE bronze.erp_loc_a101(
cid NVARCHAR(50),
cntry NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50)
);
