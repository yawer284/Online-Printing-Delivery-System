-- ==========================================================
-- Project: InkDrop - Online Printing & Delivery System
-- ==========================================================

-- Task 1: Database & Core Tables | Abdallah Mohamed Ahmed Fawzy (202507060)
DROP DATABASE IF EXISTS InkDrop_db;
CREATE DATABASE InkDrop_db;
USE InkDrop_db;

CREATE TABLE Users (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Full_Name VARCHAR(150) NOT NULL,
    Password_Hash VARCHAR(255) NOT NULL,
    Phone_Number VARCHAR(20) NOT NULL,
    Role ENUM('Customer', 'Operator', 'Delivery_Agent') NOT NULL,
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE Configurations (
    Config_ID INT PRIMARY KEY AUTO_INCREMENT,
    Paper_Size ENUM('A0', 'A1' , 'A2' ,'A3', 'A4', 'A5') NOT NULL,
    Color_Mode ENUM('Black_White', 'Color') NOT NULL,
    Layout ENUM('Single_Sided', 'Double_Sided') NOT NULL,
    Binding_Type ENUM('None', 'Spiral', 'Thermal', 'Hardcover') NOT NULL,
    Price_Per_Page DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Documents (
    Document_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    File_Name VARCHAR(255) NOT NULL,
    File_Path VARCHAR(500) NOT NULL,
    File_Type VARCHAR(50) NOT NULL,
    Page_Count INT NOT NULL,
    Uploaded_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT fk_doc_customer FOREIGN KEY (Customer_ID) REFERENCES Users(User_ID)
);

-- Task 2: Transaction & Relational Tables | Peter Samir Yacoup (202506406)
CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Operator_ID INT NULL,
    Delivery_Agent_ID INT NULL,
    Order_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    Order_Status ENUM('Pending', 'Processing', 'Printing', 'Out_for_Delivery', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    Delivery_Address VARCHAR(255) NOT NULL,
    Total_Amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_order_customer FOREIGN KEY (Customer_ID) REFERENCES Users(User_ID),
    CONSTRAINT fk_order_operator FOREIGN KEY (Operator_ID) REFERENCES Users(User_ID),
    CONSTRAINT fk_order_delivery FOREIGN KEY (Delivery_Agent_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Order_Item (
    Order_Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL,
    Document_ID INT NOT NULL,
    Config_ID INT NOT NULL,
    Copies INT NOT NULL DEFAULT 1,
    Subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_item_order FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    CONSTRAINT fk_item_document FOREIGN KEY (Document_ID) REFERENCES Documents(Document_ID),
    CONSTRAINT fk_item_config FOREIGN KEY (Config_ID) REFERENCES Configurations(Config_ID)
);

CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Method ENUM('Cash_on_Delivery', 'Credit_Card', 'Vodafone_Cash', 'InstaPay') NOT NULL,
    Payment_Status ENUM('Pending', 'Paid', 'Failed', 'Refunded') NOT NULL DEFAULT 'Pending',
    Amount_Paid DECIMAL(10, 2) NOT NULL,
    Payment_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT fk_payment_order FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);

-- Task 3: Seed Data (Core Tables) | Abdelrahman Hisham Ezzat (202506027)
INSERT INTO Users (Email, Full_Name, Password_Hash, Phone_Number, Role) VALUES
('ahmed.mahmoud@gmail.com', 'Ahmed Mahmoud', 'hash_pass_101', '01012345678', 'Customer'),
('sara.adel@gmail.com', 'Sara Adel', 'hash_pass_102', '01123456789', 'Customer'),
('omar.tarek@outlook.com', 'Omar Tarek', 'hash_pass_103', '01234567890', 'Customer'),
('nourhan.khaled@gmail.com', 'Nourhan Khaled', 'hash_pass_104', '01512345678', 'Customer'),
('kareem.op@inkdrop.com', 'Kareem Hassan', 'hash_pass_201', '01098765432', 'Operator'),
('mona.op@inkdrop.com', 'Mona Samir', 'hash_pass_202', '01198765432', 'Operator'),
('mostafa.delivery@inkdrop.com', 'Mostafa Ali', 'hash_pass_301', '01298765432', 'Delivery_Agent'),
('youssef.delivery@inkdrop.com', 'Youssef Ibrahim', 'hash_pass_302', '01598765432', 'Delivery_Agent');

INSERT INTO Configurations (Paper_Size, Color_Mode, Layout, Binding_Type, Price_Per_Page) VALUES
('A4', 'Black_White', 'Single_Sided', 'None', 1.00),
('A4', 'Black_White', 'Double_Sided', 'Spiral', 1.50),
('A4', 'Color', 'Single_Sided', 'Thermal', 5.00),
('A3', 'Color', 'Single_Sided', 'None', 10.00),
('A4', 'Color', 'Double_Sided', 'Hardcover', 8.00),
('A1', 'Color', 'Single_Sided', 'None', 25.00);

INSERT INTO Documents (Customer_ID, File_Name, File_Path, File_Type, Page_Count) VALUES
(1, 'Graduation_Project_Report.pdf', '/uploads/docs/grad_report.pdf', 'PDF', 50),
(1, 'Architecture_Poster_A1.pdf', '/uploads/docs/arch_poster.pdf', 'PDF', 2),
(2, 'Database_Lecture_Notes.pdf', '/uploads/docs/db_notes.pdf', 'PDF', 40),
(3, 'Marketing_Brochure.docx', '/uploads/docs/brochure.docx', 'DOCX', 10),
(4, 'Business_Plan_2026.pdf', '/uploads/docs/biz_plan.pdf', 'PDF', 25),
(2, 'Presentation_Slides.pptx', '/uploads/docs/slides.pptx', 'PPTX', 20),
(3, 'Draft_Test_File.pdf', '/uploads/docs/draft_test.pdf', 'PDF', 5);

-- Task 4: Seed Data (Orders & Payments) | Doaa Hamed Mohamed (202506711)
INSERT INTO Orders (Customer_ID, Operator_ID, Delivery_Agent_ID, Order_Status, Delivery_Address, Total_Amount) VALUES
(1, 5, 7, 'Delivered', 'Building 12, District 3, Sheikh Zayed, Giza', 125.00),
(2, 5, 8, 'Out_for_Delivery', 'Villa 45, West Somid, 6th of October, Giza', 120.00),
(3, 6, NULL, 'Printing', '18 Tahrir Street, Dokki, Giza', 150.00),
(4, NULL, NULL, 'Pending', '90th Street, Fifth Settlement, New Cairo', 200.00),
(1, 6, NULL, 'Cancelled', 'Building 12, District 3, Sheikh Zayed, Giza', 50.00);

INSERT INTO Order_Item (Order_ID, Document_ID, Config_ID, Copies, Subtotal) VALUES
(1, 1, 2, 1, 75.00),   
(1, 2, 6, 1, 50.00),   
(2, 3, 1, 2, 80.00),   
(2, 6, 1, 2, 40.00),  
(3, 4, 3, 3, 150.00),
(4, 5, 5, 1, 200.00),  
(5, 1, 1, 1, 50.00);   

INSERT INTO Payment (Order_ID, Payment_Method, Payment_Status, Amount_Paid) VALUES
(1, 'InstaPay', 'Paid', 125.00),
(2, 'Cash_on_Delivery', 'Pending', 120.00),
(3, 'Vodafone_Cash', 'Paid', 150.00),
(4, 'Credit_Card', 'Pending', 200.00),
(5, 'InstaPay', 'Refunded', 50.00);

-- Task 5: Data Updates, Deletion & Verification | Omnia Khaled Sayed (202506327)
UPDATE Orders 
SET Operator_ID = 5, Order_Status = 'Processing' 
WHERE Order_ID = 4;

UPDATE Orders 
SET Delivery_Agent_ID = 7, Order_Status = 'Out_for_Delivery' 
WHERE Order_ID = 3;

UPDATE Payment 
SET Payment_Status = 'Paid' 
WHERE Order_ID = 2;

DELETE FROM Documents 
WHERE Document_ID = 7;

SELECT * FROM Users;
SELECT * FROM Configurations;
SELECT * FROM Documents;
SELECT * FROM Orders;
SELECT * FROM Order_Item;
SELECT * FROM Payment;

-- Task 6: Customer & Order Details Queries (INNER & LEFT JOIN) | Kevin Montaser (202506161)
-- 1. Orders with customer and payment details
SELECT 
    Orders.Order_ID,
    Users.Full_Name,
    Orders.Order_Status,
    Orders.Total_Amount,
    Payment.Payment_Method,
    Payment.Payment_Status
FROM Orders
INNER JOIN Users ON Orders.Customer_ID = Users.User_ID
INNER JOIN Payment ON Orders.Order_ID = Payment.Order_ID
ORDER BY Orders.Order_ID;

-- 2. Order items with document and configuration details
SELECT 
    Orders.Order_ID,
    Documents.File_Name,
    Documents.Page_Count,
    Configurations.Paper_Size,
    Configurations.Color_Mode,
    Configurations.Binding_Type,
    Order_Item.Copies,
    Order_Item.Subtotal
FROM Orders
INNER JOIN Order_Item ON Orders.Order_ID = Order_Item.Order_ID
INNER JOIN Documents ON Order_Item.Document_ID = Documents.Document_ID
INNER JOIN Configurations ON Order_Item.Config_ID = Configurations.Config_ID
ORDER BY Orders.Order_ID;

-- 3. All customers and their orders
SELECT 
    Users.User_ID,
    Users.Full_Name,
    Users.Phone_Number,
    Orders.Order_ID,
    Orders.Order_Status
FROM Users
LEFT JOIN Orders ON Users.User_ID = Orders.Customer_ID
WHERE Users.Role = 'Customer';

-- Task 7: Operator & Delivery Dashboard Queries (Filtering) | Khaled Aref Gado (202507100)
-- 1. Pending and processing orders for operators
SELECT 
    Orders.Order_ID,
    Users.Full_Name,
    Orders.Order_Status,
    Orders.Order_Date,
    Orders.Total_Amount
FROM Orders
INNER JOIN Users ON Orders.Customer_ID = Users.User_ID
WHERE Orders.Order_Status IN ('Pending', 'Processing');

-- 2. Active orders without a delivery agent
SELECT 
    Order_ID,
    Customer_ID,
    Order_Status,
    Delivery_Address
FROM Orders
WHERE Delivery_Agent_ID IS NULL 
  AND Order_Status != 'Cancelled';

-- 3. Assigned deliveries for agent ID 7
SELECT 
    Orders.Order_ID,
    Users.Full_Name,
    Users.Phone_Number,
    Orders.Delivery_Address,
    Orders.Order_Status,
    Orders.Total_Amount
FROM Orders
INNER JOIN Users ON Orders.Customer_ID = Users.User_ID
WHERE Orders.Delivery_Agent_ID = 7;

-- Task 8: Analytics & Reporting Queries (Aggregate Functions) | John Rafat (202506053)
-- 1. Paid orders count, total revenue, and average value
SELECT 
    COUNT(Payment_ID),
    SUM(Amount_Paid),
    AVG(Amount_Paid)
FROM Payment
WHERE Payment_Status = 'Paid';

-- 2. Most ordered configurations and total revenue
SELECT 
    Configurations.Paper_Size,
    Configurations.Color_Mode,
    Configurations.Binding_Type,
    COUNT(Order_Item.Order_Item_ID),
    SUM(Order_Item.Subtotal)
FROM Configurations
INNER JOIN Order_Item ON Configurations.Config_ID = Order_Item.Config_ID
GROUP BY Configurations.Config_ID, Configurations.Paper_Size, Configurations.Color_Mode, Configurations.Binding_Type
ORDER BY COUNT(Order_Item.Order_Item_ID) DESC;

-- 3. Assigned orders count per delivery agent
SELECT 
    Users.Full_Name,
    COUNT(Orders.Order_ID)
FROM Users
LEFT JOIN Orders ON Users.User_ID = Orders.Delivery_Agent_ID
WHERE Users.Role = 'Delivery_Agent'
GROUP BY Users.User_ID, Users.Full_Name;


