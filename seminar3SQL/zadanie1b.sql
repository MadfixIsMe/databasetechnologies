-- Active: 1790169003103@@127.0.0.1@5432@datacraftinglab_db
--database: datacraftinglab_db

--uloha 1
WITH daily_sales AS (
    SELECT sale_date, SUM(total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY sale_date
)
SELECT sale_date, total_daily_sales
FROM daily_sales
WHERE total_daily_sales > 3000000
ORDER BY total_daily_sales DESC;

--uloha 2
WITH category_sales AS (
    SELECT product_category, SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
)
SELECT product_category, total_sales
FROM category_sales
ORDER BY total_sales DESC;

---uloha 3
WITH product_sales AS (
    SELECT product_category, product_name, SUM(total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY product_category, product_name
),
ranked_products AS (
    SELECT product_category, product_name, total_product_sales,
    RANK() OVER (PARTITION BY product_category ORDER BY total_product_sales DESC) AS category_rank
    FROM product_sales
)
SELECT product_category, total_product_sales, category_rank
FROM ranked_products
WHERE category_rank BETWEEN 1 AND 3
ORDER BY product_category, category_rank;

---uloha 4
WITH customer_sales AS (
    SELECT customer_type, SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY customer_type
),
sales_percentages AS (
    SELECT customer_type, revenue,
    SUM(revenue) OVER () AS total_revenue,
    ROUND((revenue * 100.0 / SUM(revenue) OVER ())::numeric, 2) AS revenue_percentage
    FROM customer_sales
)
SELECT customer_type, revenue, total_revenue, revenue_percentage
FROM sales_percentages
ORDER BY revenue DESC;

--uloha 5
WITH customer_transactions AS (
    SELECT customer_id, product_name, sale_date, total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date DESC) AS rn
    FROM flourmills_sales
)
SELECT customer_id, product_name, sale_date, total_amount
FROM customer_transactions
WHERE rn = 1
ORDER BY customer_id ASC;

---uloha 6
WITH RECURSIVE date_range AS (
    SELECT MIN(sale_date) AS start_date, MAX(sale_date) AS end_date
    FROM flourmills_sales
),
calendar AS (
    SELECT start_date AS sale_date, end_date
    FROM date_range
    UNION ALL
    SELECT sale_date + 1, end_date
    FROM calendar
    WHERE sale_date < end_date
)
SELECT sale_date
FROM calendar
ORDER BY sale_date ASC;

--uloha 7
WITH RECURSIVE monthly_revenue AS (
    SELECT DATE_TRUNC('month', sale_date)::date AS month,
    SUM(total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', sale_date)
),
ordered_months AS (
    SELECT ROW_NUMBER() OVER (ORDER BY month) AS rn, month, revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT rn, month, revenue, revenue AS cumulative_revenue
    FROM ordered_months
    WHERE rn = 1

    UNION ALL

    SELECT next.rn, next.month, next.revenue,
    current.cumulative_revenue + next.revenue AS cumulative_revenue
    FROM cumulative_target current
    JOIN ordered_months next ON next.rn = current.rn + 1
    WHERE current.cumulative_revenue < 500000000
)
SELECT rn, month, revenue, cumulative_revenue
FROM cumulative_target
ORDER BY rn;