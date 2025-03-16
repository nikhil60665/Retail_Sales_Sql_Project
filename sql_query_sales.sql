CREATE DATABASE sales;

CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );


SELECT * FROM retail_sales;


-- Data Cleaning

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


select count(*) from retail_sales;


-- Data Exploration

-- How many sales we have?
select count(*) as total_sales from retail_sales;


-- How many unique customers we have ?
select count(Distinct customer_id) as unique_customers from retail_sales;


SELECT DISTINCT category FROM retail_sales



-- Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales 
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

select * from retail_sales
where category = 'Clothing' 
and quantity >3 
and TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' ;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as total_sales, count(*) as total_orders from retail_sales
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	Round(avg(age),2) as average_age 
from retail_sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales 
where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(*) as total_sales from retail_sales
group by 1,2
order by category asc;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select 
	EXTRACT (year from sale_date) as year,
	EXTRACT (month from sale_date) as month,
	ROUND(AVG (total_sale), 3) as avg_sale
from retail_sales
group by 1, 2
order by 1, 3 desc;

--OR Rank
select 
	EXTRACT (year from sale_date) as year,
	EXTRACT (month from sale_date) as month,
	ROUND(AVG (total_sale), 3) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
from retail_sales
group by 1, 2;


--OR Best Selling Months
SELECT * FROM
(
		select 
	EXTRACT (year from sale_date) as year,
	EXTRACT (month from sale_date) as month,
	ROUND(AVG (total_sale), 3) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	from retail_sales
	group by 1, 2
) as t1
where rank = 1;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id, sum(total_sale) as total_sales from retail_sales
group by 1
order by total_sales desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category, count(distinct customer_id) as Unique_customers from retail_sales
group by category 



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select * ,
	case 

		when extract(hour from sale_time) < 12 then  'Morning'
		when extract(hour from sale_time) Between 12 and 17 then  'Afternoon'
		else 'Evening'

	end as shift
from retail_sales


--OR 

with hourly_sale as (
select * ,
	case 

		when extract(hour from sale_time) < 12 then  'Morning'
		when extract(hour from sale_time) Between 12 and 17 then  'Afternoon'
		else 'Evening'

	end as shift
from retail_sales
) 
select shift, count(*) as total_orders from hourly_sale
group by shift;










    