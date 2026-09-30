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

--úloha 6
SELECT 
    product_category, 
    total_sales
FROM (
    SELECT 
        product_category, 
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS subquery
WHERE total_sales > 50000000
ORDER BY total_sales DESC;

--úloha 7
SELECT 
    f1.product_name, 
    f1.product_category, 
    f1.total_amount
FROM flourmills_sales f1
WHERE f1.total_amount > (
    SELECT AVG(f2.total_amount)
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
);

--úloha 8
SELECT 
    f1.product_name, 
    f1.region, 
    f1.total_amount, 
    (
        SELECT MIN(f2.total_amount)
        FROM flourmills_sales f2
        WHERE f2.region = f1.region
    ) AS region_min_amount
FROM flourmills_sales f1;

--úloha 9
SELECT *
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_name = f1.product_name
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM f2.sale_date)) > 1
);

--úloha 10
SELECT *
FROM flourmills_sales f1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
      AND f2.total_amount > 200000
);