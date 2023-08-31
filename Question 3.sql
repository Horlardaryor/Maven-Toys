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
