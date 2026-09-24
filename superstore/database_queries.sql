SELECT o.order_id, c.customer_name, o.sales
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.sales > 500
ORDER BY o.sales DESC;

SELECT o.order_id, c.customer_name, p.category, o.sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;

SELECT c.region, SUM(o.sales) AS celk_hodnota
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.region;   