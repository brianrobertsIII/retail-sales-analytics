-- ============================================================
-- Retail Sales Analytics Portfolio Project
-- Customer Analysis
-- Tool: Google BigQuery
-- ============================================================

-- 1. Analyze customer performance by segment
SELECT
    c.segment,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.revenue), 2) AS total_revenue,
    ROUND(SUM(oi.gross_profit), 2) AS total_gross_profit,
    ROUND(
        SUM(oi.revenue) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM `brian-data-analytics-portfolio.retail_analytics.customers` AS c
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON c.customer_id = o.customer_id
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY c.segment
ORDER BY total_revenue DESC;

-- 2. Identify repeat customers and calculate lifetime revenue
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.revenue), 2) AS lifetime_revenue
FROM `brian-data-analytics-portfolio.retail_analytics.customers` AS c
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON c.customer_id = o.customer_id
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY lifetime_revenue DESC;

-- 3. Calculate repeat customer rate using a CTE
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS completed_orders
    FROM `brian-data-analytics-portfolio.retail_analytics.orders`
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,
    COUNTIF(completed_orders > 1) AS repeat_customers,
    ROUND(
        COUNTIF(completed_orders > 1) / COUNT(*) * 100,
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;

-- 4. Identify the top 10 customers by lifetime revenue
SELECT
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    ROUND(SUM(oi.revenue), 2) AS lifetime_revenue,
    ROUND(SUM(oi.gross_profit), 2) AS lifetime_gross_profit
FROM `brian-data-analytics-portfolio.retail_analytics.customers` AS c
JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON c.customer_id = o.customer_id
JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.segment,
    c.region
ORDER BY lifetime_revenue DESC
LIMIT 10;
