

select * from [dbo].[blinkit_data]

--Since the data in the first column (i.e Item_Fat_Content) has changed for eg LF, low fat, reg etc we need to update them

Update blinkit_data
set Item_Fat_Content =
case
	when Item_Fat_Content in ('LF','low fat') then 'Low Fat'
	when Item_Fat_Content = 'reg' then 'Regular'
	else Item_Fat_Content
end

--This is done to confirm whether all the values in the column are cleaned and are in proper format or not
Select distinct(Item_Fat_Content) from blinkit_data


---KPI Requirements
-- 1. Total Sales: The overall revenue generated from all the items sold.
select sum(Sales) [Sum of Sales] from blinkit_data

--Let's convert the above value into millions as there is huge value in the output
select Concat(cast(sum(Sales)/1000000 as decimal(10,2)), ' ' ,'Milions') [Sum of Sales in Millions] from blinkit_data


-- 2. Average Sales : The average revenue per sale.
select avg(Sales) [Average Revenue Per Sale] from blinkit_data 
--This gives the rounded off value
select cast(avg(Sales) as decimal(10,0)) [Average Revenue Per Sale] from blinkit_data 


-- 3. Number of items : The total count of different items sold.
select count(Item_Type) [Count of Different Items] from blinkit_data 
select count(*) [Count of Different Items] from blinkit_data 

-- 4. Average Rating : The average customer rating for items sold
select cast(avg(Rating) as decimal(10,0)) [Average Customer Rating] from blinkit_data


select * from [dbo].[blinkit_data]
select distinct(Item_Fat_Content) from [dbo].[blinkit_data]

---Granular Requirements
--1.1 Total Sales by fat content
SELECT Item_Fat_Content,
  CONCAT(CAST(SUM(Sales) / 100000 AS DECIMAL(10,2)), ' Lakhs') AS [Total Sales (in Lakhs)]
FROM blinkit_data
--WHERE Item_Fat_Content IN ('Low Fat', 'Regular')
GROUP BY Item_Fat_Content
Order By [Total Sales (in Lakhs)]
----- OR -----

SELECT 
  CONCAT(CAST(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Sales ELSE 0 END) / 100000 AS DECIMAL(10,2)), ' Lakhs') AS [Low Fat Sales],
  CONCAT(CAST(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Sales ELSE 0 END) / 100000 AS DECIMAL(10,2)), ' Lakhs') AS [Regular Fat Sales]
FROM blinkit_data;

--1.2 Average Sales by fat content
SELECT Item_Fat_Content,
  CAST(Avg(Sales) AS DECIMAL(10,0)) AS [Average Sales by fat content]
FROM blinkit_data
WHERE Item_Fat_Content IN ('Low Fat', 'Regular')
GROUP BY Item_Fat_Content;

--1.3 Number of Items by fat content
SELECT Item_Fat_Content,
  count(Item_Type) AS [Number of Items by fat content]
FROM blinkit_data
WHERE Item_Fat_Content IN ('Low Fat', 'Regular')
GROUP BY Item_Fat_Content;

--1.4 Average Rating by fat content
SELECT Item_Fat_Content,
  CAST(Avg(Rating) AS DECIMAL(10,2)) AS [Average Rating by fat content]
FROM blinkit_data
WHERE Item_Fat_Content IN ('Low Fat', 'Regular')
GROUP BY Item_Fat_Content;


select * from [dbo].[blinkit_data]
select distinct(Item_Type) from [dbo].[blinkit_data]

--2.1 Total Sales by Item Type
SELECT Item_Type,
  CONCAT(CAST(SUM(Sales) / 100000 AS DECIMAL(10,2)), ' Lakhs') AS [Total Sales (in Lakhs)]
FROM blinkit_data
WHERE Item_Type IN ('Snack Foods', 'Seafood','Breads','Canned','Dairy','Baking Goods','Others','Breakfast',
'Fruits and Vegetables','Frozen Foods','Health and Hygiene','Meat','Starchy Foods','Soft Drinks','Hard Drinks',
'Household')
GROUP BY Item_Type;

--2.2 Average Sales by Item Type
SELECT Item_Type,
  CAST(avg(Sales) AS DECIMAL(10,0)) AS [Average Sales by Item Type]
FROM blinkit_data
WHERE Item_Type IN ('Snack Foods', 'Seafood','Breads','Canned','Dairy','Baking Goods','Others','Breakfast',
'Fruits and Vegetables','Frozen Foods','Health and Hygiene','Meat','Starchy Foods','Soft Drinks','Hard Drinks',
'Household')
GROUP BY Item_Type;

--2.3 No. of Items by Item Type
SELECT Item_Type,
  count(Item_Type) AS [No. of Items by Item Type]
FROM blinkit_data
WHERE Item_Type IN ('Snack Foods', 'Seafood','Breads','Canned','Dairy','Baking Goods','Others','Breakfast',
'Fruits and Vegetables','Frozen Foods','Health and Hygiene','Meat','Starchy Foods','Soft Drinks','Hard Drinks',
'Household')
GROUP BY Item_Type;

--2.4 Average Rating by Item Type
SELECT Item_Type,
  cast(avg(Rating) as decimal(10,2)) AS [Average Rating by Item Type]
FROM blinkit_data
WHERE Item_Type IN ('Snack Foods', 'Seafood','Breads','Canned','Dairy','Baking Goods','Others','Breakfast',
'Fruits and Vegetables','Frozen Foods','Health and Hygiene','Meat','Starchy Foods','Soft Drinks','Hard Drinks',
'Household')
GROUP BY Item_Type;


select * from [dbo].[blinkit_data]
select distinct(Outlet_Type) from [dbo].[blinkit_data]

--3.1 Fat Content by Outlet for Total Sales
SELECT Outlet_Location_Type, Item_Fat_Content,
  CONCAT(CAST(SUM(Sales) / 100000 AS DECIMAL(10,2)), ' Lakhs') AS [Total Sales (in Lakhs)]
FROM blinkit_data
GROUP BY Item_Fat_Content, Outlet_Location_Type;

--Use this

SELECT 
    Outlet_Location_Type,
    ISNULL([Low Fat], 0) AS Low_Fat,
    ISNULL([Regular], 0) AS Regular
FROM (
    SELECT 
        Outlet_Location_Type, 
        Item_Fat_Content, 
        CAST(SUM(Sales) AS DECIMAL(10, 2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT (
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


--3.2 Fat Content by Outlet for Avg. Sales
SELECT Item_Fat_Content, Outlet_Type,
  CAST(avg(Sales)AS DECIMAL(10,0)) AS [Avg. Sales]
FROM blinkit_data
WHERE Outlet_Type IN ('Supermarket Type1', 'Supermarket Type2', 'Supermarket Type3', 'Grocery Store')
GROUP BY Item_Fat_Content, Outlet_Type;

--3.3 Fat Content by Outlet for No. Of Items
SELECT Item_Fat_Content, Outlet_Type,
  count(Item_Type) AS [No. Of Items]
FROM blinkit_data
WHERE Outlet_Type IN ('Supermarket Type1', 'Supermarket Type2', 'Supermarket Type3', 'Grocery Store')
GROUP BY Item_Fat_Content, Outlet_Type;

--3.4 Fat Content by Outlet for Average Rating
SELECT Item_Fat_Content, Outlet_Type,
  CAST(avg(Rating) AS DECIMAL(10,2)) AS [Average Rating]
FROM blinkit_data
WHERE Outlet_Type IN ('Supermarket Type1', 'Supermarket Type2', 'Supermarket Type3', 'Grocery Store')
GROUP BY Item_Fat_Content, Outlet_Type;


select * from [dbo].[blinkit_data]
select distinct(Outlet_Establishment_Year) from [dbo].[blinkit_data]

--4.1 Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year,
  CONCAT(CAST(SUM(Sales) / 100000 AS DECIMAL(10,2)), ' Lakhs') AS [Total Sales (in Lakhs)]
FROM blinkit_data
WHERE Outlet_Establishment_Year IN (2022, 2016, 2014, 2020, 2011, 2017, 2012, 2018, 2015)
GROUP BY Outlet_Establishment_Year
Order By Outlet_Establishment_Year


select * from [dbo].[blinkit_data]

--5 Percentage of Sales by Outlet Size

SELECT 
    Outlet_Size,
    Cast(SUM(Sales) as decimal(10,0)) AS Outlet_Sales,
    Concat(Cast((SUM(Sales) * 100.0) / (SELECT SUM(Sales) FROM blinkit_data) as decimal(10,0)), ' ','%') AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
order by Outlet_Sales Desc

--6 Sales by Outlet Location
SELECT Outlet_Location_Type,
    Cast(SUM(Sales) as decimal(10,0)) AS Outlet_Sales
    --Concat(Cast((SUM(Sales) * 100.0) / (SELECT SUM(Sales) FROM blinkit_data) as decimal(10,0)), ' ','%') AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Location_Type
order by Outlet_Sales Desc
