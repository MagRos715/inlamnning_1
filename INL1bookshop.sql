#Magnus Rosenlund, YH24

#Creates the databese INL1bookshop and activates it

CREATE DATABASE INL1bookshop; 						
USE INL1bookshop;						

#Creats table "Customers", defines attributes and datatypes

CREATE TABLE Customers								
	(Customer_ID INT AUTO_INCREMENT PRIMARY KEY,	
    Name VARCHAR (100),								
    Email VARCHAR (100),							
    Reg_Date DATE,									
    Adress VARCHAR (100),							
    Phone INT)										
;													

#Creats table "Products", defines attributes and datatypes

CREATE TABLE Products									
	(Product_ID INT AUTO_INCREMENT PRIMARY KEY,		
    Title VARCHAR (100),							
    Category VARCHAR (100),							
    Price DECIMAL,									
    Author VARCHAR (100),							
    ISBN INT,										
    Stock INT)									
;												

#Creats table "Orders", defines attributes and datatypes

CREATE TABLE Orders								
	(Order_ID INT AUTO_INCREMENT PRIMARY KEY,		
    Order_Date DATE,								
    Order_Total DECIMAL)							
;													

#Creats table "Order_lines", defines attributes and datatypes

CREATE TABLE Order_lines								
	(Order_line_ID INT AUTO_INCREMENT PRIMARY KEY,	
    Amount DECIMAL,									
    Price DECIMAL)									
;													

#Inserts data into table "Customers" (Customer_ID is PK)

INSERT INTO Customers (Name, Email, Reg_date, Adress, Phone)
		VALUES 
			('Lisa Larsson', 'lisa@larsson.se', '2025-01-01', 'testtown 12', 1234567),
            ('Nisse Nilsson', 'nisse@email.com', '2025-02-02', 'just around the corner', 3216549),
            ('Pelle Persson', 'pelle@email.com', '2024-12-12', 'at home', 7418529)
;

#Inserts data into table "Products" (Product_ID is PK)

INSERT INTO Products (Title, Category, Price, Author, ISBN, Stock)
		VALUES 
			('Lord of the rings: fellowship of the rings', 'Fantasy', 300, 'JRR Tolkien', 123, 10),
            ('Lord of the rings. The two towers', 'Fantasy', 400, 'JRR Tolkien', 963, 15),
            ('Lord of the rings: The return of the King', 'Fantasy', 350, 'JRR Tolkien', 456, 12)
;

#Selects all costomers

SELECT * FROM Customers;

#Selects all products with price over 300 SEK

SELECT * FROM Products 
	WHERE Price > 300
    ;