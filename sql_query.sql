-- SQL Retail Sales Analysis --
CREATE DATABASE sql_proj2;

--Create Table
CREATE TABLE retail_sales(
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id	INT,
gender VARCHAR(15),	
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;


--Data Cleaning

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

-- Data Exploration
-- How many Sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales;

--How many unique Customers we have?
SELECT COUNT(DISTINCT customer_id) as unique_customers FROM retail_sales;

--How many unique Categories do we have?
SELECT COUNT(DISTINCT category)as diff_categories FROM retail_sales;

-- What are the different Categories we have?
SELECT DISTINCT category as categories FROM retail_sales;

--Data Analysis & Business problems and solutions

-- My Analysis & Findings
-- 1.write a SQL query to retrieve all columns for sales made on '2022-11-05'.

SELECT * FROM retail_sales WHERE sale_date='2022-11-05';

-- 2.write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022.

SELECT * FROM retail_sales WHERE category='Clothing' AND TO_CHAR(sale_date,'YYYY-MM')='2022-11' AND quantiy>3;

-- 3.write a SQL query to calculate the total sales(total_sale) for each category.

SELECT category,SUM(total_sale) as net_sales,COUNT(*) FROM retail_sales GROUP BY category;

-- 4.write a SQL query to find the avergae age of customers who purchased items from the 'Beauty' category.

SELECT category,ROUND(AVG(age)) as average_age FROM retail_sales WHERE category='Beauty' GROUP BY category;

-- 5.write a SQL query to find all transcations where total_sale is greater than 1000.

SELECT * FROM retail_sales WHERE total_sale>1000;

-- 6.write a SQL query to find the total no of transcations (transcation_id) made by each gender in each category.

SELECT category,gender,COUNT(*) as transactions FROM retail_sales GROUP BY gender,category;

-- 7.write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT* FROM 
(
SELECT EXTRACT(YEAR FROM sale_date)as year,
EXTRACT(MONTH FROM sale_date) as month,AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)as rank
FROM retail_sales 
GROUP BY year,month
) AS t1
WHERE rank=1;
--ORDER BY year,avg_sale DESC;

-- 8.write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,SUM(total_sale) as total_sales FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5;

-- 9.write a SQL query to find the no of unique customers who purchased items from each category.

SELECT category,COUNT(DISTINCT customer_id) FROM retail_sales GROUP BY category;

-- 10.write a SQL query to to create each shift and number of orders (Eg. Morning <=12,Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT shift,COUNT(*) as total_orders FROM hourly_sale GROUP BY shift ;

--END of Project--