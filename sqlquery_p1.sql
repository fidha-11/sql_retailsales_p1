-- SQL RETAIL SALES ANALYSIS
CREATE DATABASE practice;

--create table
DROP TABLE IF EXISTS retailsales;
CREATE TABLE retailsales(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time	TIME,
		customer_id INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(25),
		quantiy	INT,
		price_per_unit FLOAT,	
		cogs	FLOAT,
		total_sale FLOAT
);
select * from retailsales
limit 10;

select count(*) from retailsales;

----
select * from retailsales
where transactions_id is null;
-----
select * from retailsales
where sale_date is null;
---- data cleaning
delete from retailsales
where transactions_id is null
or
sale_date is null
or
 sale_time is null
or
customer_id is null
or
 gender is null
or
 age is null
or
 category is null
or 
quantiy is null
or
 price_per_unit is null
or
 cogs is null
or
 total_sale is null;

 --------data exploration
 --how many sales  we have?
 select count(*) as total_sales from retailsales;

 --how many unique customers we have?
 select count(distinct customer_id) as total_customer from retailsales;

 select distinct category from retailsales


--DATA ANAYLYSIS- BUSINESS KEY PROBLEMS WITH ANSWERS
--Q1 )  WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON ' 2022-11-05'

select  * from retailsales
where sale_date ='2022-11-05';

--Q2) Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select 
*
from retailsales
where category = 'Clothing'
and 
to_char(sale_date,'yyyy-mm')= '2022-11'
and
quantiy>=4

--Q3)Write a SQL query to calculate the total sales (total_sale) for each category.
select category, 
sum(total_sale) as net_sale,
count(*) as total_orders
from retailsales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
round(avg(age),2) as avg_age
from retailsales
where category ='Beauty';

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retailsales
where total_sale >1000;


--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
category,
gender,
count(transactions_id)
from retailsales
group by category, gender;

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
sale_year,
sale_month,
avgtotal_sale
from (
select 
EXTRACT (YEAR FROM sale_date) as sale_year,
EXTRACT (MONTH FROM sale_date) as sale_month,
avg (total_sale) as avgtotal_sale,
RANK() over(partition by extract(YEAR from sale_date) order by avg(total_sale) desc) as rank
from retailsales
group by 1,2) as t1
where rank = 1
--order by 1, 3 desc


--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select 
customer_id,
sum(total_sale) as totalsales
from retailsales
group by 1
order by 2 desc
limit 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) ,
category
from retailsales
group by category

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS (
    SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
    FROM retailsales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;



--end of project


