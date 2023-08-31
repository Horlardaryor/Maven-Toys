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
