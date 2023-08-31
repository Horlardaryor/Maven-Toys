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

