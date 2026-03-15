WITH cte AS (
    SELECT 
        pd.product,
        pd.Category,
        pd.Brand,
        pd.Description,
        pd.Sale_Price,
        pd.Cost_Price,
        pd.Image_url,
        ps.Date,
        ps.Customer_Type,
        ps.Discount_Band,
        ps.Country,
        ps.Units_Sold,
        (pd.Sale_Price * ps.Units_Sold) AS Revenue,
        (pd.Cost_Price * ps.Units_Sold) AS Total_Cost,
        -- Fix 1: Use DATENAME instead of FORMAT (more reliable)
        DATENAME(month, ps.Date) AS Month,
        -- Fix 2: Use YEAR function
        YEAR(ps.Date) AS Year
    FROM Product_data pd  -- Fix 3: Consistent alias 'pd'
    JOIN product_sales ps  -- Fix 4: Consistent alias 'ps'
        ON pd.Product_ID = ps.Product
)

SELECT * ,
(1- Discount*1.0/100)* Revenue as  Discount_revenue
FROM cte a
-- Fix 5: Use LEFT JOIN to keep all data even if no discount match
LEFT JOIN discount_data b
    ON a.Discount_Band = b.Discount_Band 
    AND a.Month = b.Month;  -- Now both are text month names