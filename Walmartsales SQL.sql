CREATE DATABASE walmart_sales;

-- Create table
CREATE TABLE IF NOT EXISTS walmart_sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select count(*) FROM walmart_sales;

-- Changing the column name time to timing because time is predefined function in my sql

ALTER table walmart_sales RENAME COLUMN time TO timing;

-- Adding time of the day column

SELECT 
    timing,
    (CASE
        WHEN timing BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN timing BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END) AS time_of_day
FROM
    walmart_sales;
    
ALTER TABLE walmart_sales ADD COLUMN  time_of_day VARCHAR(30);

UPDATE walmart_sales 
SET 
    time_of_day = (CASE
        WHEN timing BETWEEN '00:00:00' AND '12:00:00' THEN 'morning'
        WHEN timing BETWEEN '12:01:00' AND '16:00:00' THEN 'afternoon'
        ELSE 'evening'
    END);

-- ADDING day name 
ALTER TABLE walmart_sales ADD COLUMN day_name VARCHAR(20);

UPDATE walmart_sales 
SET 
    day_name = DAYNAME(date);
    
-- Adding Month Name

ALTER TABLE walmart_sales ADD COLUMN month_name VARCHAR(20);

UPDATE walmart_sales 
SET 
    month_name = MONTHNAME(date);
    
ALTER TABLE walmart_sales ADD COLUMN day_num_of_week INT;
UPDATE walmart_sales SET day_num_of_week = DAYOFWEEK(date);

SELECT * FROM walmart_sales;

-- Q1 How many unique city do we have ?

SELECT DISTINCT(city) FROM walmart_sales;

-- Q2 How many branch in each city ?

SELECT 
    city, COUNT(branch) no_of_branch
FROM
    walmart_sales
GROUP BY city;

-- Q3 In which city is each branch?

SELECT DISTINCT
    city, branch
FROM
    walmart_sales;
  -----------------------------------------------------------------------------------------------------  
--                                  PRODUCT Analysis                                                 --
-------------------------------------------------------------------------------------------------------
-- Q1 How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line)no_of_product_line FROM walmart_sales;

-- Q3 What is the most common payment method?
SELECT 
    payment, COUNT(payment) diff_payment_count
FROM
    walmart_sales
GROUP BY payment;

-- Q3) What is the most selling product line?

SELECT * FROM walmart_sales;
SELECT 
    product_line, SUM(quantity)tot_quantity 
FROM
    walmart_sales
GROUP BY product_line
ORDER BY tot_quantity   DESC;

-- Q4 What is the total revenue by month?

SELECT 
    month_name, SUM(total) total_revenue
FROM
    walmart_sales
GROUP BY month_name;

-- Q5 What month had the largest COGS?
SELECT 
    month_name, SUM(cogs) total_cogs
FROM
    walmart_sales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- Q6 What product line had the largest revenue?

SELECT 
    product_line, SUM(total)tot_revenue
FROM
    walmart_sales
GROUP BY product_line
ORDER BY tot_revenue  DESC;

-- Q7 What is the city with the largest revenue?

SELECT 
    city, SUM(total) tot_revenue
FROM
    walmart_sales
GROUP BY city
ORDER BY city DESC;

-- Q8 Which product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM walmart_sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Q9 Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales

SELECT AVG(quantity) FROM walmart_sales;

SELECT 
    product_line,
    CASE
        WHEN
            AVG(quantity) >= (SELECT 
                    AVG(quantity)
                FROM
                    walmart_sales)
        THEN
            'Good'
        ELSE 'Bad'
    END AS sale_category
FROM
    walmart_sales
GROUP BY product_line;

-- Q10 Which branch sold more products than average product sold?

SELECT branch,AVG(quantity) FROM walmart_sales GROUP BY branch;

SELECT 
    branch, SUM(quantity)
FROM
    walmart_sales
GROUP BY branch
HAVING SUM(quantity) >= (SELECT 
        AVG(quantity)
    FROM
        walmart_sales);

-- Q11 What is the most common product line by gender?
SELECT * FROM walmart_sales;

SELECT 
    product_line, gender, SUM(quantity)total_quantity
FROM
    walmart_sales
GROUP BY product_line , gender
ORDER BY total_quantity DESC;

-- Q12 What is the average rating of each product line?

SELECT 
    product_line, AVG(rating)
FROM
    walmart_sales
GROUP BY product_line;

-------------------------------------------------------------------------------------------------------
--                                    SALES ANALYSIS                                                  --
-------------------------------------------------------------------------------------------------------

-- Q1 Number of sales made in each time of the day per weekday

SELECT 
    time_of_day, day_name, COUNT(*)
FROM
    walmart_sales
WHERE day_name NOT IN ('Saturday', 'Sunday')
GROUP BY time_of_day , day_name
ORDER BY day_name;

-- Q2 Which of the customer types brings the most revenue?

SELECT 
    customer_type, SUM(total) tot_revenue
FROM
    walmart_sales
GROUP BY customer_type
ORDER BY tot_revenue;

-- Q3 Which city has the largest tax percent/ VAT (Value Added Tax)?


SELECT 
    city, ROUND(AVG(tax_pct),2) AS tax_pct
FROM
    walmart_sales
GROUP BY city
ORDER BY tax_pct DESC;

-- Q4 Which customer type pays the most in VAT?
SELECT * FROM walmart_sales;

SELECT 
    customer_type, ROUND(AVG(tax_pct),2) tax_pct
FROM
    walmart_sales
GROUP BY customer_type
ORDER BY tax_pct DESC;

-- Q5  Which month genrates the higest revenue 

SELECT month_name , SUM(total)total_rev FROM walmart_sales GROUP BY month_name
ORDER BY total_rev DESC;

-------------------------------------------------------------------------------------------------------
--                                       Customer                                                    --
-------------------------------------------------------------------------------------------------------

-- Q1 How many unique customer types does the data have?

SELECT DISTINCT
    (customer_type)
FROM
    walmart_sales;

-- Q2 How many unique payment methods does the data have?

SELECT DISTINCT payment FROM walmart_sales;

-- Q3 Which customer type buys the most?

SELECT 
    customer_type, COUNT(*)cust_count
FROM
    walmart_sales
GROUP BY customer_type;

-- Q4 What is the gender of most of the customers?


SELECT 
    gender, COUNT(*) cnt
FROM
    walmart_sales
GROUP BY gender;

-- Q5 What is the count of the diffrent member type of different gender

SELECT 
    customer_type, gender, COUNT(*)
FROM
    walmart_sales
GROUP BY customer_type , gender;

-- Q6 What is the gender distribution per branch?
SELECT * FROM walmart_sales;
SELECT 
    branch, gender, COUNT(*) AS gener_cnt
FROM
    walmart_sales
GROUP BY branch , gender
ORDER BY branch








