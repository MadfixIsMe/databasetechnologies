--úloha 2

SELECT
    customer_id,
    invoice_no,
    invoice_date,
    quantity,
    unit_price,
    quantity * unit_price AS revenue,
    SUM(quantity * unit_price) OVER (
        PARTITION BY customer_id
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '14 days' PRECEDING AND CURRENT ROW
    ) AS revenue_last_14_days
FROM retail_sales
WHERE customer_id IS NOT NULL
ORDER BY customer_id, invoice_date;

--uloha 3
SELECT
    stock_code,
    country,
    invoice_date,
    quantity,
    ROUND(AVG(quantity) OVER (
        PARTITION BY stock_code, country
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
    ), 2) AS avg_quantity_7_days
FROM retail_sales
WHERE quantity > 1
ORDER BY stock_code, country, invoice_date;

--úloha 4

WITH unique_orders AS (
    SELECT DISTINCT
        customer_id,
        invoice_no,
        invoice_date
    FROM retail_sales
    WHERE customer_id IS NOT NULL
),
next_orders AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,
        LEAD(invoice_date) OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date
        ) AS next_invoice_date
    FROM unique_orders
)
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    next_invoice_date,
    next_invoice_date::date - invoice_date::date AS days_to_next_invoice
FROM next_orders
WHERE next_invoice_date IS NOT NULL
ORDER BY days_to_next_invoice DESC;

--uloha 5

WITH price_changes AS (
    SELECT
        stock_code,
        invoice_no,
        invoice_date,
        unit_price AS current_price,
        LAG(unit_price) OVER (
            PARTITION BY stock_code
            ORDER BY invoice_date
        ) AS previous_price
    FROM retail_sales
)
SELECT
    stock_code,
    invoice_no,
    invoice_date,
    previous_price,
    current_price,
    current_price - previous_price AS price_difference
FROM price_changes
WHERE previous_price IS NOT NULL
AND current_price <> previous_price
ORDER BY invoice_date ASC;

--uloha 6

WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
customer_quartiles AS (
    SELECT
        customer_id,
        total_amount,
        NTILE(4) OVER (ORDER BY total_amount DESC) AS sales_quartile
    FROM customer_sales
)
SELECT
    customer_id,
    total_amount,
    sales_quartile
FROM customer_quartiles
ORDER BY total_amount DESC;

--uloha 7

WITH monthly_sales AS (
    SELECT
        country,
        DATE_TRUNC('month', invoice_date)::date AS month,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY country, DATE_TRUNC('month', invoice_date)
),
sales_quartiles AS (
    SELECT
        country,
        month,
        total_amount,
        NTILE(4) OVER (
            PARTITION BY country
            ORDER BY total_amount DESC
        ) AS sales_quartile
    FROM monthly_sales
)
SELECT
    country,
    month,
    total_amount,
    sales_quartile
FROM sales_quartiles
ORDER BY country ASC, month ASC;

--uloha 8

WITH ranked_purchases AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,
        stock_code,
        description,
        quantity,
        unit_price,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date ASC, invoice_no ASC
        ) AS rn
    FROM retail_sales
    WHERE customer_id IS NOT NULL
)
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    stock_code,
    description,
    quantity,
    unit_price
FROM ranked_purchases
WHERE rn = 1
ORDER BY customer_id ASC;
