Use activity;

# How can you identify null values in your dataset?

SELECT *   									 
FROM customers
Where customer_id is null 
or city_id is null;

Select *
From products
where product_id IS NULL 
OR price is null;

SELECT *   
FROM
    sales
WHERE
    Sale_id IS NULL 
		OR sale_date IS NULL
        OR product_id IS NULL
        OR quantity IS NULL
        OR customer_id IS NULL
        OR total_amount IS NULL
        OR rating IS NULL ;   

#How can you check for duplicate entries in the customers table?

Select count(*) As total_duplicate_count  			
From ( Select customer_name, count(customer_name)
From customers
Group by customer_name 
Having  count(customer_name) > 1 ) As duplicate_count;  

 # How do you check for mismatches between total_amount and the calculated value of price × quantity?

SELECT s.sale_id ,p.price, s.quantity, s. total_amount , p.price * s.quantity As Actual_total  
FROM sales s
join Products p on s.product_id = p.product_id
where p.price * s.quantity <> s.total_amount;

#How do you create a comprehensive sales report with customer and product details?

Select s.sale_id, s.sale_date, p.product_name, c.city_name, p.price, s.total_amount,
SUM(s.total_amount) OVER (PARTITION BY p.product_name ORDER BY s.sale_date) AS Product_Total_Sales
From sales s
join customers cu on s.customer_id = cu. customer_id
join city c on cu.city_id = c.city_id
join Products p on s.product_id = p.product_id;

# Activity 4
# Total Sales per City

Select  c.city_name, Sum(s.total_amount) AS city_total_sales
From sales s
join customers cu on s.customer_id = cu. customer_id
join city c on cu.city_id = c.city_id
Group by c.city_name;

#Total Transactions per City

Select c.city_name ,count(s.sale_id) AS Transactions_per_City
from sales s
join customers cu on s.customer_id = cu. customer_id
join city c on cu.city_id = c.city_id
Group by c.city_name;

#Unique Customers per City
Select c.city_name,count( distinct cu.customer_id) AS Unique_Customers_per_City
From customers cu
join city c on cu.city_id = c.city_id
Group by c.city_name;

# Average Order Value per City
Select c.city_name, round(avg(s.total_amount), 2) as average_order_value
from sales s 
join customers cu on s.customer_id = cu. customer_id
join city c on cu.city_id = c.city_id
Group by  c.city_name
order by c.city_name;

# Product Demand per City
select c.city_name, p.product_name,sum(s.quantity) as total_quantity
from sales s
join products p on s.product_id = p.product_id
join customers cu on s.customer_id = cu.customer_id
join city c on cu.city_id = c.city_id
group by c.city_name , p.product_name
order by c.city_name asc,total_quantity desc;

# Monthly Sales Trend
update sales
set sale_date = STR_TO_DATE(sale_date, '%m/%d/%Y');

Select date_format(sale_date,'%Y, %m') as new_month, sum(total_amount) as amount from activity.sales
group by new_month 
order by new_month asc;

# Customer Rating Analysis
Select c.city_name, round(avg(s.rating),2) AS Customer_Rating_Analysis
from sales s
join customers cu on s.customer_id = cu .customer_id
join city c on cu.city_id = c.city_id
group by c.city_name
order by Customer_Rating_Analysis desc;

# Activity 5 
# Top Cities Selection
select c.city_name,sum(s.total_amount) AS total_sales, count(distinct(cu.customer_id)) As Number_of_customer, count(s.sale_id) AS Number_of_Order
From sales s
join customers cu on s.customer_id = cu .customer_id
join  city c on cu.city_id = c.city_id 
Group by c.city_name
Order by total_sales Desc 
Limit 3;

# Final Recommendations
# Based on the analysis, Pune is the strongest candidate for expansion due to its highest sales and transaction volume. 
# Chennai and Bangalore should be considered as the next priority cities because they also demonstrate strong business performance. 
# Monday Coffee should continue to stock high-demand products, monitor monthly sales trends for better planning, maintain customer satisfaction, and improve data quality to support future growth.

