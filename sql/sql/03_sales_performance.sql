-- ============================================================
-- Retail Sales Analytics Portfolio Project
-- Sales Performance Analysis
-- Tool: Google BigQuery
-- ============================================================

-- 1. Analyze revenue, gross profit, and gross margin by region
SELECT
    c.region,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(oi.gross_profit) / SUM(oi.revenue) * 100,
        2
    ) AS gross_margin_pct
FROM `brian-data-analytics-portfolio.retail_analytics.orders` AS o
JOIN `brian-data-analytics-portfolio.retail_analytics.customers` AS c
    ON o.customer_id = c.customer_id
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.region
ORDER BY total_revenue DESC;

-- 2. Analyze revenue, gross profit, and gross margin by product category
SELECT
    p.category,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(oi.gross_profit) / SUM(oi.revenue) * 100,
        2
    ) AS gross_margin_pct
FROM `brian-data-analytics-portfolio.retail_analytics.orders` AS o
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
JOIN `brian-data-analytics-portfolio.retail_analytics.products` AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'Completed'
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 3. Analyze revenue, gross profit, and gross margin by sales channel
SELECT
    o.sales_channel,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(oi.gross_profit) / SUM(oi.revenue) * 100,
        2
    ) AS gross_margin_pct
FROM `brian-data-analytics-portfolio.retail_analytics.orders` AS o
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY o.sales_channel
ORDER BY total_revenue DESC;

-- 4. Analyze monthly revenue, gross profit, and gross margin
SELECT
    FORMAT_DATE('%Y-%m', o.order_date) AS order_month,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(oi.gross_profit) / SUM(oi.revenue) * 100,
        2
    ) AS gross_margin_pct
FROM `brian-data-analytics-portfolio.retail_analytics.orders` AS o
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY order_month
ORDER BY order_month;

-- 5. Identify the highest-revenue month
SELECT
    FORMAT_DATE('%Y-%m', o.order_date) AS order_month,
    ROUND(SUM(oi.revenue), 2) AS total_revenue
FROM `brian-data-analytics-portfolio.retail_analytics.orders` AS o
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY order_month
ORDER BY total_revenue DESC
LIMIT 1;
