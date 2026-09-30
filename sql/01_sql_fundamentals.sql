-- ============================================================
-- Retail Sales Analytics Portfolio Project
-- SQL Fundamentals
-- Tool: Google BigQuery
-- ============================================================


-- 1. Find all customers located in the Midwest

SELECT
    customer_id,
    customer_name,
    segment,
    region,
    state
FROM `brian-data-analytics-portfolio.retail_analytics.customers`
WHERE region = 'Midwest';


-- 2. Find Electronics products from highest to lowest list price

SELECT
    product_name,
    category,
    list_price,
    unit_cost
FROM `brian-data-analytics-portfolio.retail_analytics.products`
WHERE category = 'Electronics'
ORDER BY list_price DESC;


-- 3. Find completed Online orders with the longest shipping times

SELECT
    order_id,
    customer_id,
    order_date,
    sales_channel,
    order_status,
    shipping_days
FROM `brian-data-analytics-portfolio.retail_analytics.orders`
WHERE order_status = 'Completed'
  AND sales_channel = 'Online'
ORDER BY shipping_days DESC;


-- 4. Find order items generating the highest gross profit

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    revenue,
    gross_profit
FROM `brian-data-analytics-portfolio.retail_analytics.order_items`
ORDER BY gross_profit DESC;
