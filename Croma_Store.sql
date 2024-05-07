-- Q1. Total net sales in Value of each quarter 2023.

-- Most sales as per city
select city, SUM(gross_revenue) as revenue from sales s group by city order by revenue desc;

SELECT
    EXTRACT(YEAR FROM date) AS Year,
    EXTRACT(QUARTER FROM date) AS Quarter,
    SUM(gross_revenue) AS TotalNetSales
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(QUARTER FROM date)
ORDER BY Year, Quarter;
-- -------------------------------------------------------------------
-- Q2. Total Quantity Sold in each quarter 2023.

SELECT
    EXTRACT(YEAR FROM date) AS Year,
    EXTRACT(QUARTER FROM date) AS Quarter,
    SUM(quantity) AS TotalQuantity
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(QUARTER FROM date)
ORDER BY Year, Quarter;
-- --------------------------------------------------------------------
-- Q3. Highest sales of each store from each state in value and quantity.

SELECT
    sm.store_name,
    s.city,
    MAX(s.gross_revenue) AS highest_sales_value,
    MAX(s.quantity) AS highest_sales_quantity
FROM sales s
JOIN store_master sm ON s.site = sm.store_code
GROUP BY sm.store_name, s.city
ORDER BY highest_sales_value DESC;
-- --------------------------------------------------------------------
-- Q4. Lowest sales of each store from each state in value and quantity.

SELECT
    sm.store_name,
    s.city,
    MIN(s.Gross_revenue) AS lowest_sales_value,
    MIN(s.quantity) AS lowest_sales_quantity
FROM sales s JOIN store_master sm ON s.site = sm.store_code
GROUP BY sm.store_name, s.city
ORDER BY lowest_sales_value asc;
-- --------------------------------------------------------------------
-- Q5. Top 3 stores in sales from each state

WITH RankedStores AS (
    SELECT
        sm.store_name,
        s.city,
        sm.region,
        s.Gross_revenue,
        ROW_NUMBER() OVER (PARTITION BY sm.region ORDER BY s.Gross_revenue DESC) AS sales_rank
    FROM sales s
    JOIN store_master sm ON s.site = sm.store_code
)
SELECT
    store_name,
    city,
    region,
    Gross_revenue
FROM RankedStores
WHERE sales_rank <= 3
ORDER BY region, sales_rank;

-- --------------------------------------------------------------------
-- Q6 (a). top 3 Least sold products overall in 2023 by quanity.

SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY product_name
ORDER BY total_quantity_sold
LIMIT 3;
-- --------------------------------------------------------------------
-- Q6 (b). top 3 Least sold products overall in 2023 by value.

SELECT
    product_name,
    SUM(gross_revenue) AS total_gross_revenue
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY product_name
ORDER BY total_gross_revenue
LIMIT 3;
-- --------------------------------------------------------------------
-- Q7 (a). top 3 most sold products overall in 2023 by quantity

SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY product_name
ORDER BY total_quantity_sold DESC
LIMIT 3;
-- --------------------------------------------------------------------
-- Q7(b). top 3 most sold products overall in 2023 by value

SELECT
    product_name,
    SUM(gross_revenue) AS total_gross_revenue
FROM sales
WHERE EXTRACT(YEAR FROM date) = 2023
GROUP BY product_name
ORDER BY total_gross_revenue DESC
LIMIT 3;

-- --------------------------------------------------------------------
-- Q8. Top 3 Highest unit of products in all stores

SELECT
    Store_name,
    SUM(qty) AS total_quantity_across_articles
FROM stock
WHERE Store_name NOT LIKE '%DC%'
GROUP BY Store_name
ORDER BY total_quantity_across_articles DESC
LIMIT 3;

-- --------------------------------------------------------------------
-- Q9. Top 3 Lowest unit of products in all stores. 

SELECT
    Store_name,
    SUM(qty) AS total_quantity_across_articles
FROM stock
WHERE Store_name NOT LIKE '%DC%'
GROUP BY Store_name
ORDER BY total_quantity_across_articles
LIMIT 3;

-- --------------------------------------------------------------------
-- Q10. List of all products and quantity available in DC / Warehouse

SELECT
    article_desc,
    SUM(qty) AS total_quantity_available
FROM stock
WHERE Store_name LIKE '%DC%'
GROUP BY article_desc;
