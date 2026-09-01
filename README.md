# Food Delivery SQL Analysis

SQL analysis of **15,000 food-delivery orders** using PostgreSQL, joins, subqueries, and aggregations to analyze customer distribution, restaurant performance, revenue, cuisine popularity, and ordering behavior — found **$378,350.32** in total revenue, with **Bristol** having the largest customer base (**270 customers**) and **R004** generating the highest restaurant revenue (**$2,834.81**).

## Dataset

Five relational tables:

* `customers_medium` — customer IDs, cities, and signup dates
* `restaurants` — restaurant IDs, cuisines, cities, and ratings
* `menu_items` — menu items, restaurant IDs, and item prices
* `orders_medium` — orders, customers, restaurants, order times, delivery times, and order status
* `orders_items` — items included in each order, quantities, and order-level prices

## Tools Used

* PostgreSQL

## Analysis Breakdown

**Basic**

* Total orders placed and total revenue generated
* City with the largest customer base
* Most common cuisine type
* Top 5 restaurants by rating
* Average time of day at which delivered orders arrive

**Intermediate**

* Restaurants generating the highest revenue
* Most frequently ordered menu items
* City generating the highest revenue
* Average order value per restaurant
* Customers ordering most frequently

**Advanced**

* Cuisine type generating the most revenue
* Restaurant receiving the most orders
* Average order value per customer

## Key Findings

* **15,000 orders** generated **$378,350.32** in total revenue
* **Bristol** had the largest customer base with **270 customers**
* **Thai** was the most common cuisine, offered by **26 restaurants**
* **R004** generated the highest restaurant revenue at **$2,834.81**
* **M0245** was the most frequently ordered menu item, with **102 units ordered**
* **Bristol** generated the highest city-level revenue at **$76,430.40**
* **Thai** generated the highest cuisine-level revenue at **$86,894.49**
* **R096** received the most orders, with **43 orders**
* The highest average order value for a customer was **$326.07**

## Author

Sommya Loharuka

## Acknowledgement

The dataset was sourced from Kaggle and the project was developed independently as SQL practice. The database schema was created manually from the dataset, and the queries were written and tested independently to strengthen understanding of relational database design, joins, aggregations, subqueries, and analytical SQL.

