#Magnus Rosenlund, YH24

#Inlämning 1

#Uppgift 4

CREATE DATABASE INL2bookshop; 						
USE INL2bookshop;														#Creates the databese INL1bookshop and activates it

CREATE TABLE Customers								
	(Customer_ID INT AUTO_INCREMENT PRIMARY KEY,	
    Name VARCHAR (100) NOT NULL,								
    Email VARCHAR (100) NOT NULL UNIQUE,							
    Reg_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,									
    Adress VARCHAR (100) NOT NULL,							
    Phone INT NOT NULL);												#Creats table "Customers", defines attributes and datatypes			

CREATE TABLE Products									
	(Product_ID INT AUTO_INCREMENT PRIMARY KEY,		
    Title VARCHAR (100) NOT NULL,							
    Category VARCHAR (100),							
    Price DECIMAL NOT NULL CHECK (Price >0),							#CHECK ensures that Price is more than 0		
    Author VARCHAR (100),							
    ISBN INT NOT NULL,										
    Stock INT);															#Creats table "Products", defines attributes and datatypes		

CREATE TABLE Orders								
	(Order_ID INT AUTO_INCREMENT PRIMARY KEY,		
    Order_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,								
    Customer_ID INT);	#FK												#Creats table "Orders", defines attributes and datatypes											

CREATE TABLE Order_lines								
	(Order_line_ID INT AUTO_INCREMENT PRIMARY KEY,	
    Amount DECIMAL,									
    Order_ID INT,	#FK													
    Product_ID INT);	#FK												#Creats table "Order_lines", defines attributes and datatypes					

# INLÄMNING 2

# Uppgift 1 "Skapa och hantera testdata"

INSERT INTO Customers (Name, Email, Adress, Phone)
	VALUES 
		('Lisa Larsson', 'lisa@larsson.se', 'testtown 12', 1234567),
        ('Nisse Nilsson', 'nisse@email.com', 'just around the corner', 3216549),
        ('Pelle Persson', 'pelle@email.com', 'at home', 7418529),
        ('Delete Deletesson', 'delete@delete.se', 'deleted', 000000),
        ('Kalle Karlsson', 'kalle@email.com', 'Kallegatan', 586469);							#Inserts data into table "Customers" (Customer_ID is PK)

INSERT INTO Products (Title, Category, Price, Author, ISBN, Stock)
	VALUES 
		('Lord of the rings: fellowship of the rings', 'Fantasy', 300, 'JRR Tolkien', 123, 10),
        ('Lord of the rings. The two towers', 'Fantasy', 400, 'JRR Tolkien', 963, 15),
		('Lord of the rings: The return of the King', 'Fantasy', 350, 'JRR Tolkien', 456, 12);	#Inserts data into table "Products" (Product_ID is PK)

INSERT INTO Orders (Customer_ID)
	VALUES 
		(1),					
        (2),
        (3),
        (1),
        (2),
		(2);															#Inserts data into table "Orders"

INSERT INTO Order_lines (Amount, Order_ID, Product_ID)
	VALUES 
		(1, 1, 1), 				#Kund köper 1 LOTR Fellowship
		(2, 2, 2),				#Kund köper 2 LOTR Two Towers
		(3, 3, 3), 				#Kund köper 3 LOTR Return
		(1, 2, 1), 				#Kund köper 1 LOTR Fellowship
		(2, 4, 2), 				#Kund köper 2 LOTR Two Towers
		(5, 4, 3), 				#Kund köper 5 LOTR Return
		(2, 1, 1), 				#Kund köper 2 LOTR Fellowship
		(7, 2, 2), 				#Kund köper 7 LOTR Two Towers
		(13, 3, 3), 			#Kund köper 13 LOTR Return
		(1, 5, 1), 				#Kund köper 1 LOTR Fellowship
		(2, 1, 2), 				#Kund köper 2 LOTR Two Towers
		(6, 1, 3); 				#Kund köper 6 LOTR Return				#Inserts data into Order_lines

#Uppgift 2 "Hämta, filtrera och sortera data"

SELECT * 
	FROM Customers;														#Selects alla customers

SELECT * 
	FROM Products 														#Selects all products with price over 300 SEK
		WHERE Price > 300;
    
SELECT * 
	FROM Customers, Orders												#Selects all customers and orders
		WHERE Name = 'Nisse Nilsson';									#Filters by name "Nisse Nilsson"    
    
SELECT * 
	FROM Products														#Selects all products
		ORDER BY Price 
			DESC;														#Order by Price descending

SELECT * 
	FROM Products														#Selects all products
		ORDER BY Price 
			ASC;														#Order by Price Ascending

# Uppgift 3 "Modifiera data (UPDATE, DELETE, TRANSAKTIONER)"

SET SQL_SAFE_UPDATES = 0;												#Turns off Safe update
UPDATE Customers 
	SET Email = 'nisse.new@email.com' 
		WHERE Name = 'Nisse Nilsson'; 									#Updates the Customertable
DELETE 
	FROM Customers 
		WHERE Name = 'Delete Deletesson';								#Deletes the customer Delete Deletesson
SET SQL_SAFE_UPDATES = 1;												#Turns on Safe update
SELECT * 
	FROM Customers;														#Selects all from customers to check update

START TRANSACTION;														#Starts transaction
UPDATE Customers 
	SET Email = 'nisse.new.new@email.com' 
		WHERE Customer_ID = 2;											#Updates the customer table
SELECT * 
	FROM Customers;														#Select all customers to check update

ROLLBACK;																#Rollback the update

UPDATE Customers 
	SET Email = 'nisse.new..new.new@email.com' 
		WHERE Customer_ID = 2;	 										#Updates the customer table
SELECT * 
	FROM Customers;														#Select all customers to check update
COMMIT;																	#Commit the update

# Uppgift 4 "Arbeta med JOINs & GROUP BY"

SELECT Customers.Name, Orders.Order_ID
	FROM Customers
		INNER JOIN Orders 
			ON Customers.Customer_ID = Orders.Customer_ID;				#Join Customers and Orders to show who have placed orders
        
SELECT Customers.Name, Orders.Order_ID
	FROM Customers
		LEFT JOIN Orders 
			ON Customers.Customer_ID = Orders.Customer_ID;				#Join Customers and Orders and show all customers even if no orders
    
SELECT Customer_ID, COUNT(Order_ID) 
	AS Total_Orders
		FROM Orders 
			GROUP BY Customer_ID;										#Groups and counts Orders by Customer_ID
    
SELECT Customer_ID, COUNT(Order_ID) 
	AS More_than_2_Orders
		FROM Orders 
			GROUP BY Customer_ID
				HAVING COUNT(Order_ID) > 2;								#Groups, counts and sorts customers with more than 2 orders
    
# Uppgift 5 "Index, Constraints & Triggers"

SELECT * FROM Customers;												#Selects Customertable
USE inl2bookshop;														#Activaets the database inl2bookshop
CREATE INDEX idx_Email
	ON Customers (Email);												#Creates Index for Email in Customertable
SHOW INDEX FROM Customers;												#Shows Index for Email in Customertable

DELIMITER $$
	CREATE TRIGGER Update_stock
		AFTER INSERT ON Order_lines
			FOR EACH ROW
				BEGIN
					UPDATE Products
					SET Stock = Stock - NEW.Amount
                    WHERE Product_ID = NEW.Product_ID;
				END $$
DELIMITER ;																#Creates trigger to updaet stoch after order has been placed
             
INSERT INTO Order_lines (Amount, Order_ID, Product_ID)
	VALUES 
		(1, 1, 1), 				#Kund köper 1 LOTR Fellowship
		(2, 2, 2);				#Kund köper 2 LOTR Two Towers			#Inserts 2 new orderlines to test trigger for Autostock

CREATE TABLE Customer_log (
	Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
    );																	#Creates Customer_logtable

DELIMITER $$
	CREATE TRIGGER Log_new_customer
		AFTER INSERT ON Customers
			FOR EACH ROW
				BEGIN
					INSERT INTO Customer_log (Customer_ID)
                    VALUES (NEW.Customer_ID);
				END $$
DELIMITER ;																#Creates log for new customers

INSERT INTO Customers (Name, Email, Adress, Phone)
	VALUES 
		('Lasse Persson', 'lasse@email.se', 'testtown 15', 8854685);	#Inserts a new customer into Customerstable
   
SELECT * FROM Customer_log;												#Test for Customer_log

DELIMITER $$
	CREATE PROCEDURE Show_customers()
		BEGIN
			SELECT * FROM Customers;
		END $$
DELIMITER ;																# Creates function to show all customers

CALL Show_customers;													# Tests Show_customers

CREATE USER 'test'@'localhost' IDENTIFIED BY 'password';				# Creates User
	GRANT SELECT ON inl2bookshop. * TO 'test'@'localhost';				# Grants access to database
	GRANT USAGE ON inl2bookshop. * TO 'test'@'localhost';				# Grants permission to manipulate data in database
   
#Added CHECK Constraint >0 to Price (on line 28-ish)
#Added NOT NULL Constraint to selected attributes
#Added UNIQUE Constraint to Email attribute in customer table
#Added PRIMARY_KEY Constraint to selected attributes
#Added DEFAULT Constraint to selected attributes

# Uppgift 6 "Backup & Restore - Säkerhetskopiering 

# Created backup with "mysqldump -u root -p inl2bookshop > inl2bookshop2_backup.sql"
# Restore backup with "mysql -u root -p inl2bookshop < inll2bookshop2_backup.sql"

# Uppgift 7 "Reflektion och analys av databaslösning

/*

*/    
    

    
    
    
    
    
    
    
    
    
    