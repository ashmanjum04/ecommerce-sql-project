PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    address TEXT
);
INSERT INTO Users VALUES(1,'Alice Smith','alice@example.com','9876543210','New York');
INSERT INTO Users VALUES(2,'Bob Johnson','bob@example.com','8765432109','Los Angeles');
INSERT INTO Users VALUES(3,'Charlie Rose','charlie@example.com','7654321098','Chicago');
CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL
);
INSERT INTO Products VALUES(1,'Wireless Mouse','Electronics',599.0,50);
INSERT INTO Products VALUES(2,'Bluetooth Headphones','Electronics',1299.0,30);
INSERT INTO Products VALUES(3,'Coffee Mug','Kitchen',199.0,100);
INSERT INTO Products VALUES(4,'Notebook','Stationery',49.0,200);
CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    order_date TEXT,
    status TEXT, coupon_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES Users(user_id)
);
INSERT INTO Orders VALUES(1,1,'2025-06-10','Delivered',NULL);
INSERT INTO Orders VALUES(2,2,'2025-06-10','Processing',NULL);
INSERT INTO Orders VALUES(3,1,'2025-06-11','Shipped',NULL);
CREATE TABLE OrderItems (
    order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(product_id) REFERENCES Products(product_id)
);
INSERT INTO OrderItems VALUES(1,1,1,2);
INSERT INTO OrderItems VALUES(2,1,3,1);
INSERT INTO OrderItems VALUES(3,2,2,1);
INSERT INTO OrderItems VALUES(4,3,4,5);
CREATE TABLE Payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    payment_date TEXT,
    amount REAL,
    method TEXT,
    status TEXT,
    FOREIGN KEY(order_id) REFERENCES Orders(order_id)
);
INSERT INTO Payments VALUES(1,1,'2025-06-10',1397.0,'UPI','Paid');
INSERT INTO Payments VALUES(2,2,'2025-06-10',1299.0,'Card','Pending');
INSERT INTO Payments VALUES(3,3,'2025-06-11',245.0,'Cash','Paid');
CREATE TABLE Reviews (
    review_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    product_id INTEGER,
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TEXT,
    FOREIGN KEY(user_id) REFERENCES Users(user_id),
    FOREIGN KEY(product_id) REFERENCES Products(product_id)
);
INSERT INTO Reviews VALUES(1,1,1,5,'Great mouse, very responsive!','2025-06-11');
INSERT INTO Reviews VALUES(2,2,2,4,'Sound quality is good.','2025-06-11');
INSERT INTO Reviews VALUES(3,1,3,3,'Nice mug but smaller than expected.','2025-06-11');
CREATE TABLE Roles (
    role_id INTEGER PRIMARY KEY AUTOINCREMENT,
    role_name TEXT NOT NULL UNIQUE
);
INSERT INTO Roles VALUES(1,'Customer');
INSERT INTO Roles VALUES(2,'Admin');
INSERT INTO Roles VALUES(3,'Vendor');
CREATE TABLE UserRoles (
    user_id INTEGER,
    role_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
INSERT INTO UserRoles VALUES(1,1);
INSERT INTO UserRoles VALUES(2,2);
INSERT INTO UserRoles VALUES(3,3);
CREATE TABLE Coupons (
    coupon_id INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL UNIQUE,
    discount_percent INTEGER NOT NULL,
    expiry_date TEXT
);
INSERT INTO Coupons VALUES(1,'NEWUSER10',10,'2025-12-31');
INSERT INTO Coupons VALUES(2,'FESTIVE20',20,'2025-11-30');
CREATE TABLE Cart (
    cart_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    added_date TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Cart VALUES(1,1,2,1,'2025-06-11');
INSERT INTO Cart VALUES(2,2,1,3,'2025-06-10');
CREATE TABLE InventoryLog (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER,
    change_type TEXT,         -- 'Restock' or 'Order'
    quantity_change INTEGER,
    change_date TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO InventoryLog VALUES(1,1,'Restock',50,'2025-06-01');
INSERT INTO InventoryLog VALUES(2,1,'Order',-3,'2025-06-10');
CREATE TABLE Shipments (
    shipment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    status TEXT,
    shipped_date TEXT,
    delivery_date TEXT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Shipments VALUES(1,1,'Shipped','2025-06-09',NULL);
INSERT INTO Shipments VALUES(2,2,'Delivered','2025-06-05','2025-06-07');
CREATE TABLE Tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT NOT NULL UNIQUE
);
INSERT INTO Tags VALUES(1,'Electronics');
INSERT INTO Tags VALUES(2,'Men');
INSERT INTO Tags VALUES(3,'Summer');
CREATE TABLE ProductTags (
    product_id INTEGER,
    tag_id INTEGER,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);
INSERT INTO ProductTags VALUES(1,1);
INSERT INTO ProductTags VALUES(2,2);
INSERT INTO ProductTags VALUES(3,3);
CREATE TABLE Wishlist (
    wishlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    product_id INTEGER,
    added_date TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Wishlist VALUES(1,1,1,'2025-06-08');
INSERT INTO Wishlist VALUES(2,2,2,'2025-06-09');
CREATE TABLE Returns (
    return_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER,
    reason TEXT,
    status TEXT,        -- Requested / Approved / Rejected
    request_date TEXT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Returns VALUES(1,2,'Damaged product','Requested','2025-06-10');
CREATE TABLE ActivityLog (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    action TEXT,
    timestamp TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
INSERT INTO ActivityLog VALUES(1,1,'Logged in','2025-06-11 09:00');
INSERT INTO ActivityLog VALUES(2,1,'Placed Order','2025-06-11 09:10');
CREATE TABLE SupportTickets (
    ticket_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    subject TEXT,
    message TEXT,
    status TEXT,  -- Open, Closed, In Progress
    created_at TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
INSERT INTO SupportTickets VALUES(1,2,'Order not received','I haven’t received my order after 5 days.','Open','2025-06-10 10:30');
INSERT INTO sqlite_sequence VALUES('Users',3);
INSERT INTO sqlite_sequence VALUES('Products',4);
INSERT INTO sqlite_sequence VALUES('Orders',3);
INSERT INTO sqlite_sequence VALUES('OrderItems',4);
INSERT INTO sqlite_sequence VALUES('Payments',3);
INSERT INTO sqlite_sequence VALUES('Reviews',3);
INSERT INTO sqlite_sequence VALUES('Roles',3);
INSERT INTO sqlite_sequence VALUES('Coupons',2);
INSERT INTO sqlite_sequence VALUES('Cart',2);
INSERT INTO sqlite_sequence VALUES('InventoryLog',2);
INSERT INTO sqlite_sequence VALUES('Shipments',2);
INSERT INTO sqlite_sequence VALUES('Tags',3);
INSERT INTO sqlite_sequence VALUES('Wishlist',2);
INSERT INTO sqlite_sequence VALUES('Returns',1);
INSERT INTO sqlite_sequence VALUES('ActivityLog',2);
INSERT INTO sqlite_sequence VALUES('SupportTickets',1);
CREATE VIEW MonthlyRevenue AS
SELECT 
    SUBSTR(payment_date, 1, 7) AS month,
    SUM(amount) AS total_revenue
FROM Payments
WHERE status = 'Paid'
GROUP BY month
ORDER BY month;
CREATE VIEW UserOrderCounts AS
SELECT 
    U.name AS customer_name,
    COUNT(O.order_id) AS total_orders
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id
ORDER BY total_orders DESC;
CREATE VIEW RevenueByPaymentMethod AS
SELECT 
    method,
    SUM(amount) AS total_collected
FROM Payments
WHERE status = 'Paid'
GROUP BY method
ORDER BY total_collected DESC;
CREATE VIEW CategoryOrderCounts AS
SELECT 
    P.category,
    COUNT(OI.order_item_id) AS total_orders
FROM OrderItems OI
JOIN Products P ON OI.product_id = P.product_id
GROUP BY P.category
ORDER BY total_orders DESC;
CREATE VIEW UnorderedProducts AS
SELECT 
    P.name
FROM Products P
LEFT JOIN OrderItems OI ON P.product_id = OI.product_id
WHERE OI.product_id IS NULL;
CREATE VIEW TopReviewers AS
SELECT 
    U.name,
    COUNT(R.review_id) AS review_count
FROM Reviews R
JOIN Users U ON R.user_id = U.user_id
GROUP BY R.user_id
ORDER BY review_count DESC;
CREATE VIEW AverageCartSize AS
SELECT 
    ROUND(AVG(item_count), 2) AS avg_cart_size
FROM (
    SELECT order_id, SUM(quantity) AS item_count
    FROM OrderItems
    GROUP BY order_id
);
CREATE VIEW DailySalesTrend AS
SELECT 
    payment_date,
    SUM(amount) AS daily_sales
FROM Payments
WHERE status = 'Paid'
GROUP BY payment_date
ORDER BY payment_date;
COMMIT;
