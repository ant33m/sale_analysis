-- queries related to whole business operation
-- 1) What were our total sales and total profit this year?
SELECT SUM(sales) AS total_sold,
    SUM(profit) AS total_profit
FROM superstore_analysis
WHERE EXTRACT(
        YEAR
        FROM ordering_date
    ) = 2017;


-- 2)  Are sales growing month over month?
SELECT months,
    LAG(monthly_sale) OVER(
        ORDER BY months
    ) AS prev_month_sales,
    CASE
        WHEN monthly_sale > LAG(monthly_sale) OVER (
            ORDER BY months
        ) THEN 'increasing'
        WHEN monthly_sale < LAG(monthly_sale) OVER (
            ORDER BY months
        ) THEN 'decreasing'
        WHEN monthly_sale = LAG(monthly_sale) OVER (
            ORDER BY months
        ) THEN 'stagnant'
        ELSE 'insufficient data'
    END AS trend
FROM(
        SELECT EXTRACT(
                MONTH
                FROM ordering_date
            ) AS months,
            SUM(sales) AS monthly_sale
        FROM superstore_analysis
        GROUP BY EXTRACT(
                MONTH
                FROM ordering_date
            )
        ORDER BY EXTRACT(
                MONTH
                FROM ordering_date
            )
    );


-- 3) Which regions contribute the most revenue?
   SELECT region,
    sub.regional_sales
FROM (
        select region,
            SUM(sales) AS regional_sales
        FROM superstore_analysis
        GROUP BY region
    ) AS sub
ORDER BY sub.regional_sales DESC;

-- 4) Which product categories generate the highest profit?
    SELECT category,
    p.total_profit
FROM(
        SELECT category,
            SUM(profit) AS total_profit
        FROM superstore_analysis
        GROUP BY category
    ) AS p
ORDER BY p.total_profit DESC;

-- 5) Which states are underperforming?
SELECT state,
    s.state_sales,
    CASE
        WHEN s.state_sales < s.benchmark THEN 'underperforming'
        WHEN s.state_sales > s.benchmark THEN 'above average'
        ELSE 'N/A'
    END AS performance
FROM (
        SELECT state,
            SUM(sales) AS state_sales,
            AVG(SUM(sales)) OVER () AS benchmark
        FROM superstore_analysis
        group by state
    ) AS s
ORDER BY s.state_sales;


-- 6) Which products should we stop selling?
SELECT product_name,
    p.numnber_of_items_sold,
    p.profit_gained
FROM (
        SELECT product_name,
            SUM(quantity) AS numnber_of_items_sold,
            SUM(profit) AS profit_gained
        FROM superstore_analysis
        GROUP BY product_name
    ) AS P
ORDER BY p.profit_gained;

-- 7) Are we making money overall or losing money?
SELECT SUM(profit) AS total_profit
FROM superstore_analysis;