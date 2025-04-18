# 📊 Data Warehouse & Analytics Portfolio Project

🚀  Welcome to my **Data Warehouse and Analytics Project**! 
This project showcases a complete data warehousing and analytics solution — from raw data ingestion to building insightful business reports. It is built using **SQL Server** and follows industry best practices in **ETL, data modeling**, and **data analysis**.

---

## 🏗️ Data Architecture – Medallion Layers

The project implements the **Medallion Architecture**, separating the data into three layers for better management and scalability:

![Data Architecture](docs/data_warehouse_data_architecture.png)


- **🔹 Bronze Layer**  
  Raw data ingestion from CSV files (ERP and CRM) into SQL Server without transformation.

- **🔸 Silver Layer**  
  Cleansed and standardized data prepared for modeling.

- **⭐ Gold Layer**  
  Business-ready data modeled into a **star schema** for reporting and analytics.

---

## 📖 Project Overview

This project includes:

- 🏛️ **Data Architecture**  
  Designing a modern data warehouse using the **Medallion Architecture** with Bronze, Silver, and Gold layers to organize and transform data effectively.
  
- 🔄 **ETL Pipelines**  
  Building SQL-based ETL pipelines for extracting, transforming, and loading data.

- 🏗️ **Data Modeling**  
  Designing fact and dimension tables based on star schema principles for optimized analytical queries.

- 📊 **Data Analysis & Insights**  
  - Exploratory Data Analysis (EDA) to validate and understand data trends, metrics, and anomalies.
  - Advanced Analysis for cumulative metrics, change-over-time trends, segmentation, and performance deep dives.
  - Reporting views for customer and product summaries using SQL views.

---

## 🎯 Skills Demonstrated

- SQL Development  
- ETL Pipeline Creation  
- Data Cleansing and Transformation  
- Dimensional Data Modeling (Star Schema)  
- Data Warehousing Concepts
- Exploratory & Advanced Analytics  
- Business Intelligence and Analytics

---

## 🛠️ Tools & Technologies

- **SQL Server Express** – Hosting the data warehouse  
- **SQL Server Management Studio (SSMS)** – Query writing and management  
- **CSV Files** – Source data from ERP and CRM systems  
- **Draw.io** – Designing ETL workflows, data models, and architecture diagrams  
- **Notion / Markdown** – For project planning and documentation

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

**Objective**  
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

**Specifications**

- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.  
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.  
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.  
- **Scope**: Focus on the latest dataset only; historization of data is not required.  
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.  

---

### BI: Analytics & Reporting (Data Analysis)

**Objective**  
Develop SQL-based analytics to deliver detailed insights into:

- Customer Behavior  
- Product Performance  
- Sales Trends  

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

---
## 📁 Repository Structure

```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                               # Project documentation and architecture details
│   ├── etl.drawio                      # Draw.io file shows all different techniques and methods of ETL
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_models.drawio              # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── init_database.sql               # Script for database initialization and schema setup
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│   ├── Exploratory Data Analysis.sql   # EDA queries to analyze trends, metrics, and insights for business understanding
│       ├── 0_EDA_Intro.md                  # EDA overview, purpose, and usage notes
│       ├── 1_Database_Exploration.sql      # Explore tables, views, and columns
│       ├── 2_Dimensions_Exploration.sql    # Explore categorical dimensions (country, category, gender)
│       ├── 3_Date_Exploration.sql          # Order and customer timeline analysis
│       ├── 4_Measures_Exploration.sql      # Totals, averages, and key KPIs
│       ├── 5_Magnitude_Analysis.sql        # Aggregation by geography, products, and customers
│       ├── 6_Ranking_Analysis.sql          # Top-N and bottom-N revenue/product/customer rankings
│   ├── Advanced Data Analysis/         # Advanced analytical SQL scripts for deeper business insights
│       ├── 0_Adv_Intro.md                  # Intro, purpose, and methodology for advanced analysis
│       ├── 1_Change_Over_Time_Analysis.sql # Analyze sales and customer metrics over time
│       ├── 2_Cumulative_Analysis.sql       # Running totals and moving averages
│       ├── 3_Performance_Analysis.sql      # Evaluate performance vs. average and previous year
│       ├── 4_Part-to-Whole_Analysis.sql    # Proportional breakdowns by category
│       ├── 5_Data_Segmentation.sql         # Segment customers and products by behavior and pricing
│       ├── 6_Customer_Report.sql           # Final aggregated customer report
│       ├── 7_Product_Report.sql            # Final aggregated product performance report
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
```
</details>

## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me on the following platform:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ramyaharikadadi/)

