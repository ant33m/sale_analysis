--Focused on revenue and sales performance.

--1)Who are our top 10 customers by sales?
SELECT customer_id,
    customer_name,
    p.purchase
FROM (
        SELECT customer_id,
            customer_name,
            sum(sales) AS purchase
        FROM superstore_analysis
        GROUP BY customer_id,
            customer_name
    ) AS p
ORDER BY p.purchase DESC
LIMIT 10;

--2)Which products generate the highest revenue?
SELECT product_name,
    r.revenue
FROM (
        SELECT product_name,
            sum(profit) AS revenue
        FROM superstore_analysis
        GROUP BY product_name
    ) AS r
ORDER BY r.revenue DESC;

--3)Which product categories are growing the fastest?
WITH g AS (
    SELECT EXTRACT(
            MONTH
            FROM ordering_date
        ) AS month,
        SUM(sales) AS total,
        sub_category
    FROM superstore_analysis
    WHERE EXTRACT(
            YEAR
            FROM ordering_date
        ) = 2017
    GROUP BY EXTRACT(
            MONTH
            FROM ordering_date
        ),
        sub_category
),
c AS (
    SELECT g.month,
        g.total,
        sub_category,
        lag(g.total) OVER (
            PARTITION BY sub_category
            ORDER BY month
        ) AS prev
    FROM g
)
SELECT month,
    sub_category,
    (((total - c.prev)) * 100) / c.prev AS growth
FROM c
WHERE prev IS NOT NULL
ORDER BY (((total - c.prev)) * 100) / c.prev DESC;


--Which customer segment buys the most?
SELECT segment,
    SUM(sales) AS purchased
from superstore_analysis
GROUP BY segment
ORDER BY SUM(sales) ;


--Which regions have declining sales?
WITH g AS (
    SELECT EXTRACT(
            MONTH
            FROM ordering_date
        ) AS month,
        region,
        SUM(sales) AS total
    from superstore_analysis
    WHERE EXTRACT(
            YEAR
            FROM ordering_date
        ) = 2017
    GROUP BY region,
        EXTRACT(
            MONTH
            FROM ordering_date
        )
),
c AS (
    SELECT g.month,
        region,
        g.total,
        LAG(G.total) OVER(
            PARTITION BY region
            ORDER BY g.month
        ) AS prev
    FROM g
)
SELECT month ,region,
    total,
    total - c.prev AS growth
FROM c
WHERE prev IS NOT NULL
ORDER BY (total - c.prev);


--What is the average order value?
SELECT
 AVG(sales) AS average_order_value
FROM superstore_analysis;