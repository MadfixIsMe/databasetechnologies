--úloha 1
SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);

--Úloha 2
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;

--úloha 3
SELECT 
    product_name, 
    total_amount, 
    (SELECT AVG(total_amount) FROM flourmills_sales) AS avg_amount
FROM flourmills_sales;

--úloha 4
SELECT 
    product_name, 
    total_amount, 
    total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM flourmills_sales;

--úloha 5
SELECT 
    month, 
    monthly_sales
FROM (
    SELECT 
        EXTRACT(MONTH FROM sale_date) AS month, 
        SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS subquery
ORDER BY monthly_sales DESC;

