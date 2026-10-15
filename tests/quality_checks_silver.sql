--- Check silver table  after claning and transfrming process
-- Cleaning Process

----------------------------------------------------------------------------------------------------------
----Table: bronze.crm_cust_info
--- Check for nulls or duplicates in primary key
--- Expectation: No result 
select cst_id, 
count(*)
from silver.crm_cust_info
group by cst_id
having count (*) > 1 or cst_id is null
;

-- check for unwanted spaces 
-- expectation: no results
select cst_gndr
from silver.crm_cust_info
where cst_gndr != trim(cst_gndr)
;

--Data Standardization & Consisteny 
select distinct cst_gndr
from silver.crm_cust_info
;

select distinct cst_marital_status
from silver.crm_cust_info
;


select * 
from silver.crm_cust_info
order by cst_id asc;

--- Check for nulls or duplicates in primary key
--- Expectation: No result 
select prd_id, 
count(*)
from silver.crm_prd_info
group by prd_id
having count (*) > 1 or prd_id is null
;

-- check for unwanted spaces 
-- expectation: no results
select prd_nm
from silver.crm_prd_info
where prd_nm != trim(prd_nm)
;

-- check for nulls or negative numbers
-- expectation: no results
select prd_cost
from silver.crm_prd_info
where prd_cost < 0 or prd_cost is null
;

--Data Standardization & cosistency 
select distinct prd_line
from silver.crm_prd_info
;

--Check for invalid date orders 
select *
from silver.crm_prd_info
where prd_end_dt < prd_start_dt
;

select * from silver.crm_prd_info;

------------------------------------------------------------------------
----Table: silver.crm_sales_details

select * from silver.crm_sales_details;

--- Check for isues in the key 
--- Expectation: No result 
select *
from silver.crm_sales_details
where sls_prd_key not in (select prd_key from silver.crm_prd_info)
;

--- Check for issues in the key 
--- Expectation: No result 
select *
from silver.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info)
;

---Check for invalid dates
select 
nullif(sls_order_dt, 0) sls_order_dt
from silver.crm_sales_details
where sls_order_dt <= 0 or len (sls_order_dt) !=8 
or sls_order_dt > 20500101
or sls_order_dt < 19000101
;

---Check for invalid dates
select 
nullif(sls_ship_dt, 0) sls_ship_dt
from silver.crm_sales_details
where sls_ship_dt <= 0 or len (sls_ship_dt) !=8 
or sls_ship_dt > 20500101
or sls_ship_dt < 19000101
;

---Check for invalid dates
select 
nullif(sls_due_dt, 0) sls_due_dt
from silver.crm_sales_details
where sls_due_dt <= 0 or len (sls_due_dt) !=8 
or sls_due_dt > 2050-01-01
or sls_due_dt < 1900-01-01
;

---Check for invalid dates orders
select *
from silver.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt
;

----check data consistency: between sales, qty, and price
---- >> sales = qty * price
---- >> values must not be null, zero or negative

select distinct
sls_sales,
sls_quantity,
sls_price 
from silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
order by sls_sales, sls_quantity, sls_price
;

---------------------------------------
--identify out of range dates 

select distinct 
bdate 
from silver.erp_cust_az12
where bdate < '1924-01-01' or bdate > GETDATE()
;


---- Data Standardization & Consistency 
select distinct 
gen
from silver.erp_cust_az12

select distinct * from silver.erp_cust_az12;

-----------------------------------------
---Table: bronze.erp_loc_a101
--- validating key
SELECT  
 cid,
[cntry]
FROM [DataWarehouse].[silver].[erp_loc_a101]
;

---Data standardization & Consistency 
select distinct 
cntry
from silver.erp_loc_a101
order by cntry
;

select * from silver.erp_loc_a101;

------------------------------------
select * from silver.erp_px_cat_g1v2;
