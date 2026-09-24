--úloha 2
SELECT o.order_id, c.customer_name, o.sales
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.sales > 500
ORDER BY o.sales DESC;

--úloha 3
SELECT o.order_id, c.customer_name, p.category, o.sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

--úloha 4
SELECT c.region, SUM(o.sales) AS celk_hodnota
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;   

--úloha 5
SELECT p.product_name, SUM(o.sales) as celk_hodnota
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_name;

--úloha 6
SELECT c.customer_name, o.order_id, o.sales
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

--úloha 7
SELECT c.region, SUM(o.sales) AS celk_hodnota
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

--úloha 8
SELECT  c.customer_name, COUNT(o.order_id) AS pocet_objednavok
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

--úloha 9
SELECT p.category, AVG(o.discount) AS priem_zlava
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.category;
--test SELECT category FROM products;

--úloha 10
SELECT c.customer_name, SUM(o.sales) AS celk_hodnota
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING SUM(o.sales) > 2000;

--úloha 11
SELECT c.region, SUM(o.sales) AS celk_hodnota, AVG(o.discount) AS priem_zlava, COUNT(o.order_id) AS pocet_objednavok
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

--úloha 12
SELECT c.region, COUNT(CASE WHEN o.sales > 1000 THEN 1 END) AS high_value, COUNT(CASE WHEN o.sales <= 1000 THEN 1 END) AS low_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;

--úloha 13
SELECT c.customer_name, SUM(o.sales) AS celk_hodnota, AVG(o.discount) AS priem_zlava, COUNT(o.order_id) AS pocet_objednavok,
CASE WHEN SUM(o.sales) > 2500 THEN 'VIP' ELSE 'REGULAR' END AS typ_zakaznika
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY celk_hodnota DESC;

