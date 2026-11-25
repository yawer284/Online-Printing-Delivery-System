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

DESCRIBE Users;
DESCRIBE Configurations;

