/*
---------------------------------------------------------------------------------------------
Create Database and Schemas
---------------------------------------------------------------------------------------------

 Purpose:
 --------
 This script is used to set up the foundational environment for the Data Warehouse project.
 It performs the following actions:
 1. Drops the existing 'DataWarehouse_Sales' database if it exists.
 2. Creates a fresh 'DataWarehouse_Sales' database.
 3. Adds the Medallion Architecture schemas: bronze, silver, and gold.

 Warnings:
 --------
 ⚠️ This script will permanently delete the existing 'DataWarehouse_Sales' database 
    and all its data.
 ⚠️ Make sure to back up any important data before running this script.
 ⚠️ Run this script on a safe development or test environment — not in production!

 How to Run:
 -----------
 1. Open SQL Server Management Studio (SSMS).
 2. Execute this script step-by-step or all at once.
 3. Ensure you are connected to the 'master' database initially.

*/


USE master;
-- first execute the first command completely and then GO to the next statement
GO  

-- Drop and recreate the 'DataWarehouse_Sales' database
IF EXISTS (
	SELECT 1 
	FROM sys.databases 
	WHERE name = 'DataWarehouse_Sales'
)
BEGIN
    ALTER DATABASE DataWarehouse_Sales 
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse_Sales;
END;
GO

-- Create Database 'DataWarehouse_Sales'
CREATE DATABASE DataWarehouse_Sales;
GO
  
USE DataWarehouse_Sales;
GO

-- Create Schemas 'bronze, silver, gold'
CREATE SCHEMA bronze;
GO                           
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
