-- 1. customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255)
);

-- 2. products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    description TEXT,
    stockQuantity INT
);

-- 3. cart table
CREATE TABLE cart (
    cart_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 4. orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_price DECIMAL(10, 2),
    shipping_address TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 5. order_items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
	Amount DECIMAl(10,2)
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- Insert into customers table
INSERT INTO customers 
VALUES
    (1, 'John Doe', 'john.doe@email.com', 'password123'),
    (2, 'Jane Smith', 'jane.smith@email.com', 'pass456'),
    (3, 'Alice Johnson', 'alice.j@email.com', 'pass789'),
    (4, 'Bob Williams', 'bob.w@email.com', 'secretword'),
    (5, 'Eva Davis', 'eva.d@email.com', 'evapass'),
    (6, 'Mike Brown', 'mike.b@email.com', 'mikepass'),
    (7, 'Sara Miller', 'sara.m@email.com', 'sarapass'),
    (8, 'Daniel White', 'daniel.w@email.com', 'danielpass'),
    (9, 'Olivia Martinez', 'olivia.m@email.com', 'oliviapass'),
    (10, 'Chris Taylor', 'chris.t@email.com', 'chrispass');

-- Insert into products table
INSERT INTO products (product_id, name, description, price, stockQuantity)
VALUES
    (1, 'Laptop', 'High-performance laptop', 800.00, 10),
    (2, 'Smartphone', 'Latest smartphone', 600.00, 15),
    (3, 'Tablet', 'Portable tablet', 300.00, 20),
    (4, 'Headphones', 'Noise-canceling', 150.00, 30),
    (5, 'TV', '4K Smart TV', 900.00, 5),
    (6, 'Coffee Maker', 'Automatic coffee maker', 50.00, 25),
    (7, 'Refrigerator', 'Energy-efficient', 700.00, 10),
    (8, 'Microwave Oven', 'Countertop microwave', 80.00, 1),
    (9, 'Blender', 'High-speed blender', 70.00, 20),
    (10, 'Vacuum Cleaner', 'Bagless vacuum cleaner', 120.00, 10);
	

-- Insert into cart table
INSERT INTO cart (cart_id, customer_id, product_id, quantity)
VALUES
    (1, 1, 1, 2),
    (2, 1, 3, 1),
    (3, 2, 2, 3),
    (4, 3, 4, 4),
    (5, 3, 5, 2),
    (6, 4, 6, 1),
    (7, 5, 1, 1),
    (8, 6, 10, 2),
    (9, 6, 9, 3),
    (10, 7, 7, 2);


-- Insert into orders table
INSERT INTO orders (order_id, customer_id, order_date, total_price, shipping_address)
VALUES
    (1, 1, '2023-01-05', 1200.00, '123 Main St, Cityville'),
    (2, 2, '2023-02-10', 900.00, '456 Oak St, Townsville'),
    (3, 3, '2023-03-15', 300.00, '789 Pine St, Villageton'),
    (4, 4, '2023-04-20', 150.00, '101 Cedar Ave, Hamletville'),
    (5, 5, '2023-05-25', 1800.00, '202 Maple Ln, Townburg'),
    (6, 6, '2023-06-30', 400.00, '303 Oak Blvd, Citytown'),
    (7, 7, '2023-07-05', 700.00, '404 Elm St, Villaville'),
    (8, 8, '2023-08-10', 160.00, '505 Birch Rd, Townville'),
    (9, 9, '2023-09-15', 140.00, '606 Pine Ave, Hamletburg'),
    (10, 10, '2023-10-20', 1400.00, '707 Maple Dr, Cityville');


-- Insert into order_items table with itemAmount
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, Amount)
VALUES
    (1, 1, 1, 2, 1600.00),
    (2, 1, 3, 1, 300.00),
    (3, 2, 2, 3, 1800.00),
    (4, 3, 5, 2, 1800.00),
    (5, 4, 4, 4, 600.00),
    (6, 4, 6, 1, 50.00),
    (7, 5, 1, 1, 800.00),
    (8, 5, 2, 2, 1200.00),
    (9, 6, 10, 2, 240.00),
    (10, 6, 9, 3, 210.00);

--Q1
update products
set price=800.00 where name='Refrigerator';
--Q2
DELETE From cart where customer_id=5;
--Q3
select * from products where (price<100);
--Q4
select * from products where (stockQuantity>5);
--Q5
select * from orders where total_price between 500 and 1000;
--Q6
select * from products where name like '%r';
--Q7
select * from cart where customer_id=3;
--Q8
select * from customers c
join orders o on c.customer_id=o.customer_id
where year(order_date)=2023;
--Q9
select min(stockQuantity) as min_stockQuantity from products;
--Q10
select c.customer_id,c.name, sum(oi.quantity*p.price) from customers c
JOIN
  orders o ON c.customer_id = o.customer_id
JOIN
    order_items oi ON (o.order_id) = oi.order_id
JOIN
    products p ON oi.product_id = p.product_id
GROUP BY
    c.customer_id, c.name;
--Q11
select c.customer_id, c.name, avG(total_price)as total_p
from customers c
join orders o on c.customer_id=o.customer_id
Group by c.customer_id,c.name;
--Q12
SELECT c.customer_id,name,
COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
--Q13
select c.customer_id,name,
MAX(o.total_price)as max_orderAmount from customers c
join orders o on c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name;
--Q14
select c.customer_id,name from customers c
join orders o on c.customer_id=o.customer_id
where o.total_price>1000
GROUP BY c.customer_id, c.name;
--Q15
select product_id,name from products
where product_id NOT IN(select product_id from cart);
--Q16
select customer_id, name from customers
where customer_id NOT IN(select customer_id from orders);
--Q17
SELECT (SUM(oi.Amount) /tr.total_revenue) * 100 AS revenue_percentage
FROM order_items oi
CROSS JOIN
(SELECT SUM(Amount) AS total_revenue FROM order_items)tr;
--Q18
SELECT top 1 product_id,name AS product_name,stockQuantity
FROM products order by stockQuantity asc;
--Q19
select c.name,o.customer_id,total_price from orders o
join customers c on c.customer_id=o.customer_id
where total_price>(select AVG(total_price) from orders); 


	










	