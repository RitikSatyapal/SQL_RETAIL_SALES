-- Create Database
CREATE DATABASE RETAIL_SHOP;
 
-- Create Table
CREATE TABLE retail (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Retrieve all records from the retail table
SELECT * FROM retail;

-- Count total transactions
SELECT COUNT(*) FROM retail;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q1: Retrieve all columns for sales made on '2023-05-23'
SELECT * FROM retail 
WHERE sale_date = '2023-05-23';

-- Q2: Retrieve transactions where the category is 'Clothing' and quantity sold is more than 3 in Nov 2022
SELECT * FROM retail 
WHERE category = 'Clothing' 
AND quantity > 3 
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

-- Q3: Calculate the total sales for each category
SELECT category, SUM(total_sale) AS total_sales, COUNT(category) AS total_transactions 
FROM retail 
GROUP BY category;

-- Q4: Find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age), 2) AS avg_age 
FROM retail 
WHERE category = 'Beauty';

-- Q5: Find transactions where total_sale is greater than 1000
SELECT * FROM retail  
WHERE total_sale > 1000;

-- Q6: Find the total number of transactions made by each gender in each category
SELECT gender, category, COUNT(transactions_id) AS total_transactions 
FROM retail 
GROUP BY gender, category 
ORDER BY total_transactions DESC;

-- Q7: Calculate the average sale for each month and find the best-selling month in each year
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sales
    FROM retail 
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_sales AS (
    SELECT 
        year, 
        month, 
        RANK() OVER(PARTITION BY year ORDER BY avg_sales DESC) AS ranked,
        avg_sales
    FROM monthly_sales
)
SELECT * FROM ranked_sales
WHERE ranked = 1;

-- Q8: Find the top 5 customers based on highest total sales
SELECT customer_id, SUM(total_sale) AS total_sales 
FROM retail 
GROUP BY customer_id 
ORDER BY total_sales DESC 
LIMIT 5;

-- Q9: Find the number of unique customers who purchased items from each category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers 
FROM retail 
GROUP BY category;

-- Q10: Categorize sales into shifts and count the number of orders per shift
SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift,
    COUNT(*) AS total_orders 
FROM retail 
GROUP BY Shift;

-- END OF THE PROJECT