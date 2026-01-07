use superstore_db ;
select count(*)
from superstore ;



-- 1) 
-- What percentage of total orders were shipped on the same date?
SELECT 
  ROUND(
    COUNT(DISTINCT CASE WHEN Order_Date = Ship_Date THEN Order_ID END) / COUNT(DISTINCT Order_ID) * 100, 2
		) AS Same_Day_Percentage
FROM superstore;

-- 2) 
-- Name the top 3 customers with the highest total order value.
SELECT Customer_ID, Customer_Name, 
       ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Sales DESC
LIMIT 3;

-- 3) 
-- Find the average order value for each customer, and rank customers by that metric.
SELECT 
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Avg_Order_Value,
    RANK() OVER (ORDER BY SUM(Sales) / COUNT(DISTINCT Order_ID) DESC) AS Rank_By_AOV
FROM superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Avg_Order_Value DESC;


-- 4) 
-- Which customer in each city has placed the highest‑ and lowest‑value orders?
SELECT 
    City, 
    Customer_Name, 
    Order_Value,
    CASE 
        WHEN rnk_high = 1 THEN 'Highest'
        WHEN rnk_low = 1 THEN 'Lowest'
    END AS Rank_Type
FROM (
    SELECT 
        City,
        Customer_Name,
        ROUND(SUM(Sales),2) AS Order_Value,
        RANK() OVER (PARTITION BY City ORDER BY SUM(Sales) DESC) AS rnk_high,
        RANK() OVER (PARTITION BY City ORDER BY SUM(Sales) ASC)  AS rnk_low
    FROM superstore
    GROUP BY City, Customer_Name
) t
WHERE rnk_high = 1 OR rnk_low = 1
ORDER BY City, Order_Value DESC;


-- 5) 
-- What is the most demanded sub‑category in the West region?
SELECT Sub_Category, COUNT(*) AS Order_Count
FROM superstore
WHERE Region = 'West'
GROUP BY Sub_Category
ORDER BY Order_Count DESC
LIMIT 1;


-- 6) 
-- Which order has the highest number of items?
SELECT Order_ID, COUNT(*) AS Item_Count
FROM superstore
GROUP BY Order_ID
ORDER BY Item_Count DESC
LIMIT 1;


-- 7) 
-- Which order has the highest cumulative value?
SELECT Order_ID, ROUND(SUM(Sales), 2) AS Heighest_Total_Value
FROM superstore
GROUP BY Order_ID
ORDER BY Heighest_Total_Value DESC
LIMIT 1;

-- 8) 
-- Which customer segment places the most “First Class” shipments?
SELECT Segment, COUNT(*) AS Shipment_Count
FROM superstore
WHERE Ship_Mode = 'First Class'
GROUP BY Segment
ORDER BY Shipment_Count DESC
LIMIT 1;


-- 9) 
-- Which city contributes the least to total revenue?
SELECT City, ROUND(SUM(Sales), 2) AS contribution
FROM superstore
GROUP BY City
ORDER BY contribution ASC
LIMIT 1;



-- 10) 
-- Which segment places the highest number of orders in each state?
SELECT State, Segment, Order_Count
FROM (
    SELECT 
        State,
        Segment,
        COUNT(DISTINCT Order_ID) AS Order_Count,
        RANK() OVER (PARTITION BY State ORDER BY COUNT(DISTINCT Order_ID) DESC) AS rnk
    FROM superstore
    GROUP BY State, Segment
) t
WHERE rnk = 1
ORDER BY State;

