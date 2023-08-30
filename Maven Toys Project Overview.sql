•	Question 1:
/* Which product categories drive the biggest profits? Is this the same across store locations? */

WITH category_profit AS (
    SELECT
        products.product_category,
        stores.store_location,
        SUM(products.product_price - products.product_cost) AS category_profit
    FROM
        products
    JOIN inventory ON products.product_id = inventory.product_id
    JOIN stores ON inventory.store_id = stores.store_id
    GROUP BY
        products.product_category,
        stores.store_location
)

SELECT
    cp.product_category,
    cp.store_location,
    cp.category_profit
FROM
    category_profit AS cp
ORDER BY category_profit DESC
  
 /* Result: Toys category drives the biggest profits amongst the product categories at Maven Toys. Also, Toys drives the biggest profits across store locations.


/* Q2: How much money is tied up in inventory at the toy stores? How long will it last? */
	
SELECT
		SUM (stock_on_hand * product_cost) AS money_tied_up
    FROM
        inventory
    JOIN products ON products.product_id = inventory.product_id 
	WHERE
    product_category = 'Toys'
	
/* Part A Result: $99,861.47 is tied up in inventory at the Toys stores. */

WITH average_daily_sales AS (
    SELECT
        product_id,
        AVG(units) AS average_daily_sales
    FROM
        sales
    GROUP BY
        product_id
)

SELECT
    AVG(i.stock_on_hand / s.average_daily_sales) AS estimated_days_last
FROM
    inventory AS i
JOIN
    products AS p ON p.product_id = i.product_id
JOIN
    average_daily_sales AS s ON s.product_id = p.product_id
WHERE
    p.product_category = 'Toys';

/* Part B Result: It would last for about 14 days. */



/* Q3: Are sales being lost with out-of-stock products at certain locations? */
 
WITH sales_inventory AS (
    SELECT
        s.sale_id,
        i.stock_on_hand,
        s.date,
        st.store_location,
        p.product_name
    FROM
        sales AS s
    JOIN
        stores AS st ON s.store_id = st.store_id
    JOIN
        products AS p ON s.product_id = p.product_id
    LEFT JOIN
        inventory AS i ON s.store_id = i.store_id AND s.product_id = i.product_id
    WHERE
        i.stock_on_hand IS NULL
        OR i.stock_on_hand = 0
)

SELECT *
FROM sales_inventory;


/* Yes. The data shows that sales are being lost in certain location as a result of out to stock products. Running a further query as shown below, it
it was discovered that 31866 sales was lost across 4 different locations */


WITH lost_sales_by_location AS (
SELECT
    DISTINCT (st.store_location) AS store_location,
	COUNT (s.sale_id) AS lost_sales
FROM
    sales AS s
JOIN
    stores AS st ON s.store_id = st.store_id
JOIN
    products AS p ON s.product_id = p.product_id
LEFT JOIN
    inventory AS i ON s.store_id = i.store_id AND s.product_id = i.product_id
WHERE
    i.stock_on_hand IS NULL
    OR i.stock_on_hand = 0
GROUP BY st.store_location
)

SELECT 
	*
FROM
	lost_sales_by_location

/* While further analysis showed that there was sales lost accross the four store locations, Downstown store lost the most sales (19017) 
and Airport Store had the least lost sales (1569). The query below  provides the business insights*/


