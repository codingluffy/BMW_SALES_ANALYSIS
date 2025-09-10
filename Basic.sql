use sqlproject;


-- List all distinct BMW models available in the dataset.

SELECT DISTINCT
    (Model)
FROM
    bmw;
    
    
    
   --  Find the total number of cars sold in 2024
   SELECT 
    COUNT(*) AS Total_car_sold
FROM
    bmw
WHERE
    Year = 2024;
    
    
-- Display the top 5 most expensive BMW cars by Price_USD
SELECT 
    Model, Price_USD
FROM
    bmw
ORDER BY Price_USD DESC
LIMIT 5;


-- Show all cars with Fuel_Type as 'Diesel' and Transmission as 'Automatic'

SELECT 
    *
FROM
    bmw
WHERE
    Fuel_Type = 'Diesel'
        AND Transmission = 'Automatic';



-- Count how many cars were sold in each Region.

SELECT 
    Region, COUNT(*) AS Car_Sold
FROM
    bmw
GROUP BY Region;

-- Find the cummalative Sales_volume by Year(Running Total) using a window function.

select  distinct Year,sum(sales_volume)over(order by Year desc)as Running_Total
from bmw;



-- Find the average Price_USD for each Model

SELECT 
    Model, AVG(Price_USD) AS Avg_Price
FROM
    bmw
GROUP BY model;


-- Show the total Sales_Volume for each Year, sorted in descending order.

SELECT 
    Year, SUM(Sales_Volume) AS Total_Sales_Volume
FROM
    bmw
GROUP BY Year
ORDER BY Total_Sales_Volume DESC;

-- Find the top 3 Regions with the highest total Sales_Volume.
SELECT 
    Region, SUM(Sales_Volume) AS Total_Sales_Volume
FROM
    bmw
GROUP BY Region
ORDER BY Total_Sales_Volume DESC
LIMIT 3;

-- Calculate the average Engine_Size_L for Petrol cars vs Diesel cars.
SELECT 
    Fuel_Type, AVG(Engine_Size_L) AS Avg_Engine_Size
FROM
    bmw
WHERE
    Fuel_Type = 'Petrol'
        OR Fuel_Type = 'Diesel'
GROUP BY Fuel_Type;


-- Find models that have an average Mileage_KM greater than 100,000.

SELECT 
    Model, AVG(Mileage_KM) AS Mileage
FROM
    bmw
GROUP BY Model
HAVING Mileage > 100000;


-- Get the minimum and maximum Price_USD for each Fuel_Type.

SELECT 
    Fuel_Type,
    MAX(Price_USD) AS Maximum_Price,
    MIN(Price_USD) AS Minimum_Price
FROM
    bmw
GROUP BY Fuel_Type;

-- Display the Year and Model with the highest Sales_Volume.
SELECT 
    Model, Year, SUM(Sales_Volume) AS Total_Sales_Volume
FROM
    bmw
GROUP BY Model , Year
ORDER BY Total_Sales_Volume DESC;







-- Rank all Models based on their total Sales_Volume (use RANK or DENSE_RANK).

select Model,sum(Sales_Volume) as Total_Sales,  dense_rank() over (order by sum(Sales_Volume)desc) as Sales_Based_Rank
from bmw 
group by Model;


-- Identify the top-selling Model in each Region (use PARTITION BY).
select Model,Region,sum(Sales_Volume) as Total_Sale, rank() over (partition by Region order by sum(sales_Volume)desc)as  Regional_Rank
from bmw
group by Model,Region;


-- Percentage Contribution of Each Region to Total Sales
SELECT 
    Region,
    SUM(Sales_Volume) AS Region_Sales,
    ROUND((SUM(Sales_Volume) * 100.0 / SUM(SUM(Sales_Volume)) OVER ()), 2) AS Percentage_Contribution
FROM BMw
GROUP BY Region
ORDER BY Percentage_Contribution DESC;

-- Year-over-Year Sales Growth (%)

SELECT 
    Year,
    SUM(Sales_Volume) AS Total_Sales,
    LAG(SUM(Sales_Volume)) OVER (ORDER BY Year) AS Previous_Year_Sales,
    ROUND(((SUM(Sales_Volume) - LAG(SUM(Sales_Volume)) OVER (ORDER BY Year)) * 100.0 /
           LAG(SUM(Sales_Volume)) OVER (ORDER BY Year)), 2) AS YoY_Growth_Percent
FROM BMW
GROUP BY Year
ORDER BY Year;

-- Correlation Between Engine_Size_L and Price_USD

SELECT 
    (COUNT(*) * SUM(Engine_Size_L * Price_USD) - SUM(Engine_Size_L) * SUM(Price_USD)) /
    SQRT((COUNT(*) * SUM(POWER(Engine_Size_L, 2)) - POWER(SUM(Engine_Size_L), 2)) *
         (COUNT(*) * SUM(POWER(Price_USD, 2)) - POWER(SUM(Price_USD), 2))) AS Correlation
FROM BMW;


-- Classify Cars as Affordable, Mid-Range, or Luxury

SELECT 
    Model,
    Price_USD,
    CASE 
        WHEN Price_USD < 40000 THEN 'Affordable'
        WHEN Price_USD BETWEEN 40000 AND 80000 THEN 'Mid-Range'
        ELSE 'Luxury'
    END AS Price_Category
FROM BMW;

-- Create a View for Price Above Average for Each Model

CREATE VIEW ModelPriceComparison AS
SELECT 
    Model,
    Year,
    Price_USD,
    CASE 
        WHEN Price_USD > AVG(Price_USD) OVER (PARTITION BY Model) THEN 'Above Average'
        ELSE 'Below Average'
    END AS Price_Status
FROM BMW;



