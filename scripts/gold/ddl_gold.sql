/*
===============================================================================
DDL Script: Create Gold Layer Views
===============================================================================
Purpose:
    Creates views for the Gold layer - the final business-ready layer.
    These views form the star schema with dimension and fact tables.

What it does:
    - Transforms and cleans data from the Silver layer
    - Combines related tables to create enriched datasets
    - Produces analytics-ready views for reporting and BI tools

Layer Structure:
    Gold = Dimension tables (customers, products) + Fact tables (sales)
    
Usage:
    Run this script to create or update all Gold layer views.
    Query these views directly for analytics, dashboards, and reports.

Notes:
    - All transformations happen at query time (views don't store data)
    - Only active records are included (filtered by end dates where applicable)
    - Surrogate keys are generated using ROW_NUMBER() for dimension tables
===============================================================================
*/

-- Create Dimension: gold.dim_customers

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;

GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	la.cntry AS country,
	ca.bdate AS birthdate,
	ci.cst_create_date AS date_created
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid

GO

-- Create Dimension: gold.dim_products

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY prd_id) AS product_key,
	pn.prd_id AS product_number,
	pn.prd_cat_key AS product_category_key,
	pn.prd_info_key AS product_information_key,
	pn.prd_nm AS product_name,
	pn.prd_line AS product_line,
	cg.cat AS product_category,
	cg.subcat AS sub_category,
	pn.prd_cost AS product_cost,
	cg.maintenance,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS cg
ON pn.prd_cat_key = cg.id
WHERE prd_end_dt IS NULL

GO

-- Create Dimension: gold.fact_sales

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	c.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_customers AS c
ON sd.sls_cust_id = c.customer_id
LEFT JOIN gold.dim_products AS pr
ON sd.sls_prd_key = pr.product_information_key

