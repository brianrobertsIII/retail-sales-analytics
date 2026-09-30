-- ============================================================
-- Retail Sales Analytics Portfolio Project
-- Advanced Analysis
-- Tool: Google BigQuery
-- ============================================================

-- 1. Calculate return rate by product category
SELECT
    p.category,
    COUNT(DISTINCT oi.order_item_id) AS items_sold,
    COUNT(DISTINCT r.order_item_id) AS returned_items,
    ROUND(
        COUNT(DISTINCT r.order_item_id)
        / COUNT(DISTINCT oi.order_item_id) * 100,
        2
    ) AS return_rate_pct
FROM `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi

JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    ON oi.order_id = o.order_id

JOIN `brian-data-analytics-portfolio.retail_analytics.products` AS p
    ON oi.product_id = p.product_id

LEFT JOIN `brian-data-analytics-portfolio.retail_analytics.returns` AS r
    ON oi.order_item_id = r.order_item_id

WHERE o.order_status = 'Completed'

GROUP BY p.category

ORDER BY return_rate_pct DESC;

-- 2. Rank the top 5 products within each category by gross profit
WITH product_performance AS (
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity) AS units_sold,
        ROUND(SUM(oi.revenue), 2) AS total_revenue,
        ROUND(SUM(oi.gross_profit), 2) AS total_gross_profit
    FROM `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi

    JOIN `brian-data-analytics-portfolio.retail_analytics.orders` AS o
        ON oi.order_id = o.order_id

    JOIN `brian-data-analytics-portfolio.retail_analytics.products` AS p
        ON oi.product_id = p.product_id

    WHERE o.order_status = 'Completed'

    GROUP BY
        p.category,
        p.product_name
),

ranked_products AS (
    SELECT
        category,
        product_name,
        units_sold,
        total_revenue,
        total_gross_profit,

        RANK() OVER (
            PARTITION BY category
            ORDER BY total_gross_profit DESC
        ) AS profit_rank

    FROM product_performance
)

SELECT
    category,
    product_name,
    units_sold,
    total_revenue,
    total_gross_profit,
    profit_rank
FROM ranked_products
WHERE profit_rank <= 5
ORDER BY
    category,
    profit_rank;

-- 3. Calculate month-over-month revenue growth using LAG()
WITH monthly_sales AS (
    SELECT
        FORMAT_DATE('%Y-%m', o.order_date) AS order_month,
        ROUND(SUM(oi.revenue), 2) AS total_revenue
    FROM `brian-data-analytics-portfolio.retail_analytics.orders` AS o
    JOIN `brian-data-analytics-portfolio.retail_analytics.order_items` AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'Completed'
    GROUP BY order_month
),

monthly_comparison AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)
        / previous_month_revenue * 100,
        2
    ) AS month_over_month_growth_pct
FROM monthly_comparison
WHERE previous_month_revenue IS NOT NULL
ORDER BY month_over_month_growth_pct DESC;

