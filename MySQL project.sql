CREATE DATABASE data_analytics_practice;

USE data_analytics_practice;

SHOW DATABASES;
SELECT DATABASE();

SHOW TABLES;

USE data_analytics_practice;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    discount_rate DECIMAL(4,2),
    sales_channel VARCHAR(30),
    payment_method VARCHAR(30),
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

select * from customers;
select * from orders;
select * from products;

select 
customers.city,
count(orders.order_id) as total_orders
from customers
inner join orders
on customers.customer_id = orders.customer_id
group by customers.city
order by total_orders desc;

select 
products.product_name,
sum(orders.quantity) as Total_quant
from products
inner join orders
on products.product_id = orders.product_id
group by product_name
order by Total_quant desc;

select
products.product_name,
sum(orders.quantity * products.unit_price * (1 - orders.discount_rate)) as total_revenue
from orders 
inner join products 
on orders.product_id = products.product_id
group by products.product_name
order by total_revenue desc;

select 
customers.customer_id,
customers.customer_name,
customers.city,
round(sum(orders.quantity * products.unit_price * (1 - orders.discount_rate))) as total_spending
from customers
join orders 
on customers.customer_id = orders.customer_id
join products
on orders.product_id = products.product_id 
group by 
customers.customer_id,
customers.customer_name,
customers.city 
order by total_spending desc
limit 10;

select 
date_format (orders.order_date,'%Y-%m') as month,
sum(orders.quantity * products.unit_price * (1 - orders.discount_rate)) as total_revenue
from orders

join products
on orders.product_id = products.product_id

GROUP BY
    YEAR(orders.order_date),
    MONTH(orders.order_date)

ORDER BY
    YEAR(orders.order_date),
    MONTH(orders.order_date);
    
    SELECT
    DATE_FORMAT(orders.order_date, '%Y-%m') AS month,

    SUM(
        orders.quantity *
        products.unit_price *
        (1 - orders.discount_rate)
    ) AS total_revenue

FROM orders

JOIN products
    ON orders.product_id = products.product_id

GROUP BY
    DATE_FORMAT(orders.order_date, '%Y-%m')

ORDER BY
    total_revenue
    limit 1;

select 
round(sum(orders.quantity *
        products.unit_price *
        (1 - orders.discount_rate)
    )),2 AS overall_revenue 
    from orders
    join products
    on orders.product_id = products.product_id;

with monthly_sales as ( 
select 
date_format(orders.order_date,'%Y-%m') as month,
sum(orders.quantity * products.unit_price * (1- orders.discount_rate)) as monthly_revenue
from orders 
join products 
on orders.product_id = products.product_id 
group by
 date_format(orders.order_date,'%Y-%m') )
select month,
round
(monthly_revenue, 2) as current_revenue,
ROUND
(LAG(monthly_revenue) over (order by month),2 ) as previous_revenue,
round
(monthly_revenue - lag(monthly_revenue) over (order by month),2) as revenue_difference,
round(
(monthly_revenue - LAG(monthly_revenue) over (order by month))
/ nullif(LAG(monthly_revenue) over (order by month),0) * 100
,2 )
as growth_percentage
from monthly_sales 
order by month;

with monthly_sales as ( 
select 
date_format(orders.order_date,'%Y-%m') as month,
sum(orders.quantity * products.unit_price * (1- orders.discount_rate)) as monthly_revenue
from orders 
join products 
on orders.product_id = products.product_id 
group by
 date_format(orders.order_date,'%Y-%m') )
select month,
round
(monthly_revenue, 2) as current_revenue,
ROUND
(LAG(monthly_revenue) over (order by month),2 ) as previous_revenue,
round
(monthly_revenue - lag(monthly_revenue) over (order by month),2) as revenue_difference,
round(
(monthly_revenue - LAG(monthly_revenue) over (order by month))
/ nullif(LAG(monthly_revenue) over (order by month),0) * 100
,2 )
as growth_percentage
from monthly_sales 
order by growth_percentage desc;

select 
products.product_name,
round(
sum(
orders.quantity * products.unit_price * ( 1 - orders.discount_rate)),2)
 as total_revenue  
from orders
join products
on orders.product_id = products.product_id
group by 
products.product_name,
products.product_id
order by total_revenue desc;

with product_sales as (
select 
products.product_name,
round(
sum(
orders.quantity * products.unit_price * ( 1 - orders.discount_rate)),2)
 as total_revenue 
 
from orders

join products
on orders.product_id = products.product_id

group by 
products.product_name,
products.product_id
)
select 
product_name,
total_revenue,
dense_rank() over (
order by total_revenue desc ) 
as product_rank 

from product_sales;

select 
products.product_id,
products.product_name,
sum(orders.quantity * products.unit_price * (1 - orders.discount_rate) )
as total_revenue
from orders
join products 
on orders.product_id = products.product_id 
group by 
products.product_id,
products.product_name
order by total_revenue desc
limit 3;


with product_sales as
 (
select 
products.product_name,
sum(orders.quantity * products.unit_price * (1 - orders.discount_rate) )
as product_revenue
from orders
join products 
on orders.product_id = products.product_id 
group by 
products.product_id,
products.product_name
) 
select 
product_name,
product_revenue,
sum(product_revenue) over () as total_revenue,
round(
product_revenue/ sum(product_revenue) over ()  * 100 , 2 ) as revenue_percentage
from product_sales
order by revenue_percentage 
limit 1;

select 
products.product_name,
sum(orders.quantity) as total_quantity
from orders
join products
on orders.product_id = products.product_id
group by 
products.product_name
order by 
total_quantity desc
limit 3 ;

select 
customers.customer_name,
sum(orders.quantity) as total_quantity
from orders
join customers
on orders.customer_id = customers.customer_id
group by customers.customer_name
order by total_quantity desc
limit 5; 










