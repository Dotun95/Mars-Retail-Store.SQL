SELECT *
FROM 
	retail_sales_db.retail_sales_dataset;
    
# Create staging table
CREATE TABLE
	retail_sales
LIKE
	retail_sales_dataset;

INSERT
	retail_sales
SELECT *
FROM
	retail_sales_dataset;

#now we can work on the retail_sales table

/* Data cleaning: check for duplicates*/

WITH
	duplicate_cte as
(
SELECT *,
		row_number() over(partition by Transaction_ID, `Date`, Customer_ID, Gender, Age, Product_Category, Quantity, Price_perUnit, Total_Amount) as row_num
        from retail_sales
)
SELECT *
FROM	
	duplicate_cte
WHERE 
	row_num >1;

# No duplicate in the dataset,no null values , no unnecessary columns and the data set is standard and good enough to work with
	
/* Exploratory Data Analysis*/

/*
Customer Insights
1.	What is the gender distribution of customers?
2.	What is the average age of customers?
3.	Which age group spends the most?
4.	Do spending habits differ between genders?*/

#1) What is the gender distribution of customers?
SELECT
	gender, count(customer_id) as total_customers
FROM 
	retail_sales
GROUP BY 
		gender;
        
#2) What is the average age of customers?
SELECT
	avg(age) as average_customer_age
FROM
	retail_sales;
    
#3) Which age group spends the most?

SELECT
		(case 
			when age < 33 then 'young adult'
            when age between 33 and 54 then 'middle age'
            when age > 54 then 'old'
		else 'other'
        end) as age_group,
        avg(total_amount) as avg_total,
        Sum(Total_Amount) as total_spent,
        count(distinct customer_id) as unique_customer
FROM retail_sales
GROUP BY 
		age_group
ORDER BY  total_spent desc ;

#4) Do spending habits differ between genders?
SELECT
		gender,
        avg(total_amount) as avg_total,
        sum(total_amount) as total_spent,
        count(distinct customer_id) as unique_customer
FROM retail_sales
GROUP BY gender
ORDER BY total_spent desc;


/*
🛒 Product Insights
5.	Which product categories are the most popular?
6.	Which product categories generate the highest revenue?
7.	What is the average order quantity per transaction?
8.	What products are often bought in larger quantities?*/


#5) Which product categories are the most popular?
SELECT product_category,
		count(quantity) as no_of_item
FROM retail_sales
GROUP BY Product_Category
ORDER BY no_of_item desc
LIMIT 1;


#6) Which product categories generate the highest revenue?
SELECT product_category,
		sum(total_amount) as money_spent
FROM retail_sales
GROUP BY Product_Category
ORDER BY money_spent desc
LIMIT 1;

#7) What is the average order quantity per transaction?
SELECT
	transaction_id,
    avg(quantity)
FROM retail_sales
GROUP BY transaction_id;

#8) What products are often bought in larger quantities?
SELECT
		product_category,
        count(quantity) as no_of_items
FROM retail_sales
GROUP BY 
		Product_Category
ORDER BY
		no_of_items desc
LIMIT 1;

/*
💰 Sales Insights
9.	What is the total revenue over time (daily, monthly, yearly)?
10.	What is the average transaction value?
11.	Which customers contribute the most revenue (top spenders)?*/

#9) What is the total revenue over time (daily, monthly, yearly)?
# Daily Revenue
SELECT
	day(date) as day,
    month(date) as month,
    year(date) as year,
    sum(Total_Amount) as daily_sales
FROM retail_sales
GROUP BY  day(date),month(date),year(date)
ORDER BY day;

# Monthly revenue
SELECT
	 year(date) as year,
    month(date) as month,
    sum(total_amount) as monthly_sales
FROM retail_sales
GROUP BY  month(date), year(date)
order by month ;

# Yearly revenue
SELECT
    year(date) as year,
    sum(total_amount) as yearly_sales
FROM retail_sales
GROUP BY  year(date)
order by year;

#10) What is the average transaction value?
SELECT
		(sum(total_amount) /
        count(transaction_id)) as ATV
FROM retail_sales;

#11) Which customers contribute the most revenue (top spenders)?
SELECT 
		customer_id,
        sum(total_amount) as money_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY money_spent desc;



