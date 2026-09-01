CREATE TABLE IF NOT EXISTS customers_medium(
		customer_id VARCHAR(10) PRIMARY KEY,
		city text,
		signup_date DATE 
);

CREATE TABLE IF NOT EXISTS restaurants(
		restaurant_id VARCHAR(10) PRIMARY KEY,
		cuisines text,
		city text,
		rating float
);



CREATE TABLE IF NOT EXISTS menu_items (
		item_id VARCHAR(10) PRIMARY KEY,
		restaurant_id VARCHAR(10)   ,
		price NUMERIC(10, 2),
		
		CONSTRAINT fk_restaurant 
				FOREIGN KEY (restaurant_id)
				REFERENCES restaurants(restaurant_id));


CREATE TABLE IF NOT EXISTS orders_medium(
		order_id VARCHAR(10) PRIMARY KEY,
		customer_id VARCHAR(10),
		restaurant_id VARCHAR(10),
		order_time DATE,
		delivery_time TIMESTAMP,
		status text,
		
		FOREIGN KEY (customer_id) REFERENCES customers_medium(customer_id),
		
		FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);


CREATE TABLE IF NOT EXISTS orders_items (
		order_id VARCHAR(10) ,
		item_id VARCHAR(10),
		quantity INT,
		price NUMERIC(10, 2),
		
		CONSTRAINT fk_order 
				FOREIGN KEY (order_id)
				REFERENCES orders_medium(order_id),
				
		CONSTRAINT fk_item 
				FOREIGN KEY (item_id)
				REFERENCES menu_items(item_id),
				
		PRIMARY KEY (order_id, item_id)
);


select oi.order_id, c.customer_id, r.restaurant_id, oi.item_id, o.order_time, o.status,
c.city as customer_city,
r.city as restaurant_city, r.cuisines,  
oi.quantity as quantity_ordered, mi.price as item_price, oi.price as order_price
from orders_medium o join customers_medium c on o.customer_id = c.customer_id
join restaurants r on o.restaurant_id = r.restaurant_id
join orders_items oi on o.order_id = oi.order_id
join menu_items mi on oi.item_id = mi.item_id



-- 1.How many total orders were placed?
select 
count(*) from 
orders_medium o


-- 2.Which cities have the most customers?
select c.city, count(c.customer_id) 
as total_customers from 
customers_medium c group by 
c.city having count(c.customer_id) =(
select max(total_customers) from (
select count(c.customer_id) 
as total_customers from 
customers_medium c 
group by c.city) t)


-- 3.Which cuisine types are most common?
select r.cuisines, count(r.cuisines) 
as cuisine_count from 
restaurants r group by 
r.cuisines having 
count(r.cuisines) =(
select max(cuisine_count) from (
select count(r.cuisines)
as cuisine_count from 
restaurants r 
group by r.cuisines) t)

select r.cuisines, count(r.restaurant_id) as cuisine_count from 
restaurants r group by r.cuisines order by cuisine_count desc limit 1


-- 4.What are the top 5 restaurants by rating?
select r.restaurant_id, r.rating 
from restaurants r 
order by r.rating 
desc limit 5


-- 5.What is the average time of day at which delivered orders arrive?

select round(avg(extract (hour from delivery_time) * 60 +
	   extract (minute from delivery_time))::numeric,2)
as avg_time from orders_medium where status = 'Delivered'   -- ::numeric is used to type cast into numeric

/* for extracting time taken for deivery in minutes
select extract (hour from delivery_time) * 60 +
	   extract (minute from delivery_time) as time_taken from orders_medium*/



-- 6.Which restaurants generate the most revenue?
select r.restaurant_id, sum(oi.price * oi.quantity) 
as total_revenue from restaurants r 
join orders_medium o on 
r.restaurant_id = o.restaurant_id
join orders_items oi 
on o.order_id = oi.order_id
where o.status = 'Delivered'
group by r.restaurant_id 
order by total_revenue desc


-- 7.What are the most ordered menu items?
select item_id, sum(quantity) as 
counts from orders_items 
group by item_id
having sum(quantity) = (
select max(counts) from (
select sum(quantity) as counts 
from orders_items 
group by item_id ) t)



-- 8.Which cities generate the highest revenue?
select c.city, sum(oi.quantity * oi.price) 
as total_revenue from orders_items oi 
join orders_medium o on 
oi.order_id = o.order_id 
join customers_medium c on 
c.customer_id = o.customer_id
where o.status in ('Delivered', 'Late')
group by c.city having 
sum(oi.quantity * oi.price) = (
	select max(total_revenue) from(
	   select sum(oi.quantity * oi.price)
	   as total_revenue from 
	   orders_items oi join 
	   orders_medium o on 
	   oi.order_id = o.order_id 
	   join customers_medium c on 
       c.customer_id = o.customer_id
       where o.status in ('Delivered', 'Late') 
    group by c.city ) t)



-- 9.What is the average order value per restaurant?
select t.restaurant_id, round(avg(order_values),2)
as avg_order_values from (
select o.order_id, 
o.restaurant_id, sum(oi.price * oi.quantity) 
as order_values
from orders_medium o join 
orders_items oi on 
o.order_id = oi.order_id 
group by o.order_id, o.restaurant_id 
) t group by t.restaurant_id order by 
avg_order_values desc;



-- 10.Which customers order most frequently?
select o.customer_id, count(o.order_id) as 
order_count from orders_medium o 
group by o.customer_id having 
count(o.order_id) = (
select max(order_count) from (select
count(o.order_id) as 
order_count from orders_medium o 
group by o.customer_id) t
)



-- 11.Which cuisine type generates the most revenue?
select r.cuisines, sum(oi.price * oi.quantity) as total_revenue
from restaurants r join orders_medium o 
on r.restaurant_id = o.restaurant_id
join orders_items oi on 
o.order_id = oi.order_id
where o.status in ('Delivered','Late')
group by r.cuisines having 
sum(oi.price * oi.quantity) = (
select max (total_revenue) from (
select sum(oi.price * oi.quantity) as total_revenue
from restaurants r join orders_medium o 
on r.restaurant_id = o.restaurant_id
join orders_items oi on 
o.order_id = oi.order_id
where o.status in ('Delivered','Late')
group by r.cuisines) t
)



-- 12.Which restaurant receives the most orders?
select restaurant_id, count(order_id) 
as order_count from orders_medium
WHERE status IN ('Delivered', 'Late')
group by restaurant_id 
having count(order_id) = (
select max(order_count) from (
select count(order_id) 
as order_count from orders_medium
WHERE status IN ('Delivered', 'Late')
group by restaurant_id ) t
)



-- 13. What is the average order value per customer?
select t.customer_id , round(avg(t.customer_spends),2)
as avg_customer_spends from
(select o.customer_id, o.order_id, 
sum(oi.price * oi.quantity)
as customer_spends from 
orders_medium o join orders_items oi
on o.order_id = oi.order_id 
group by o.customer_id, o.order_id) t
group by t.customer_id order by avg_customer_spends

