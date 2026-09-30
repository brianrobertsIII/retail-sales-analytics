-- 1. Count total completed orders

SELECT
    COUNT(*) AS completed_orders
FROM `brian-data-analytics-portfolio.retail_analytics.orders`
WHERE order_status = 'Completed';


-- 2. Calculate total revenue from completed orders

SELECT
    SUM(oi.revenue) AS total_revenue
FROM `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';


-- 3. Calculate total gross profit from completed orders

SELECT
    SUM(oi.gross_profit) AS total_gross_profit
FROM `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';


-- 4. Calculate average order value

SELECT
    SUM(oi.revenue) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';


-- 5. Calculate gross margin

SELECT
    SUM(oi.gross_profit) / SUM(oi.revenue) AS gross_margin
FROM `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed';
