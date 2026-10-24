-- Create Database
Create Database Store_Record;

-- Switch to the database
Use Store_Record;

--Create Tables
Drop Table Books;

Create Table Books (
	Book_ID Int Primary Key,
	Title Varchar(100),
	Author Varchar(100),
	Genre varchar(50),
	Published_Year INT,
	Price Numeric(10,2),
	Stock Int
);

Drop Table Customers;

Create Table Customers (
	Customer_ID Int Primary Key,
	Name Varchar(100),
	Email Varchar(100),
	Phone Varchar(15),
	City Varchar(50),
	Country Varchar(150)
);

Drop Table Orders;

Create Table Orders (
	Order_ID Int Primary Key,
	Customer_ID Int References Customers(Customer_ID),
	Book_ID Int References Books(Book_ID),
	Order_date Date,
	Quantity Int,
	Total_Amount Numeric(10,2)
);

Select * From Books;
Select * From Customers;
Select * From Orders;

--Import Data into Books Table
BULK INSERT dbo.Books
FROM "C:\Users\HP\Desktop\A Project\SQL & MySQL\Books.csv"
WITH(FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');

--Import Data into Customers Table
BULK INSERT dbo.Customers
FROM "C:\Users\HP\Desktop\A Project\SQL & MySQL\Customers.csv"
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');

--Import Data into Orders Table
BULK INSERT dbo.Orders
FROM "C:\Users\HP\Desktop\A Project\SQL & MySQL\Orders.csv"
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');

-- 1) Retrieve all books in the "Fiction" genre:
Select * From Books Where Genre = 'Fiction';

-- 2) Find books published after the year 1950:
Select * From Books Where Published_Year > 1950;

-- 3) List all Customers from the Canada:
Select * From Customers Where Country='Canada';

-- 4) Show Orders placed in November 2023:
Select * From Orders Where Order_date Between '2023-11-01' And '2023-11-30';

-- 5) Retrieve the total stock of books available:
Select Sum(Stock) As Total_Stock From Books;

-- 6) Find the details of the most expensive book:
Select Top 1 * From Books Order By Price Desc;

-- 7) Show all Customers who Ordered more than 1 Quantity of a book:
Select * From Orders Where Quantity>1;

-- 8) Retrieve all Orders Where the Total Amount Exceeds $20:
Select * From Orders Where Total_Amount>20;

-- 9) List all Genres available in the Books table:
Select Distinct Genre From Books;

-- 10) Find the Book with the lowest Stock:
Select Top 1 * From Books Order By Stock;

-- 11) Calculate the Total revenue generated from all orders:
Select Sum(Total_Amount) As Revenue From Orders;

-- Advance Questions:
-- 1) Retrieve the Total number of Books sold for each genre:
Select * From Orders;
Select b.Genre, Sum(o.Quantity) As Total_Books_Sold From Orders o Join Books b On o.Book_ID = b.Book_ID Group By b.Genre;

-- 2) Find the average Price of Books in the "Fantasy" Genre:
Select Avg(Price) As Average_Price From Books Where Genre = 'Fantasy';

-- 3) List Customers who have placed at least 2 orders:
Select o.Customer_ID, c.Name, COUNT(o.Order_ID) As Order_Count From Orders o 
Join Customers c On o.Customer_ID = c.Customer_ID Group By o.Customer_ID, c.Name Having Count(Order_ID) >= 2;

-- 4) Find the most Frequently Ordered Book:
Select Top 1 o.Book_ID, b.Title, Count(o.Order_ID) As Order_Count From Orders o 
Join Books b On o.Book_ID = b.Book_Id Group By o.Book_ID, b.Title Order By Order_Count Desc;

-- 5) Show the Top 3 most expensive Books of 'Fantasy' Genre:
Select Top 3 * From Books Where Genre = 'Fantasy' Order By Price Desc;

-- 6) Retrieve the Total Quantity of Books sold by each author:
Select b.author, Sum(o.Quantity) As Total_Books_Sold From Orders o Join Books b On o.Book_ID = b.Book_ID Group By b.Author;

-- 7) List the Cities where Customers who spent over $30 are located:
Select Distinct c.City, Total_Amount From Orders o Join Customers c On o.Customer_ID = c.Customer_ID Where o.Total_Amount > 30;

-- 8) Find the Customer who spent the most on orders:
Select Top 1 c.Customer_ID, c.Name, Sum(o.Total_Amount) As Total_Spent From Orders o 
Join Customers c On o.Customer_ID = c.Customer_ID Group By c.Customer_ID, c.Name Order By Total_Spent Desc;

-- 9) Calculate the Stock remaining after fulfilling all orders:
Select b.Book_ID, b.Title, b.Stock, Coalesce(Sum(o.Quantity),0) As Order_Quantity, b.Stock - Coalesce(Sum(o.Quantity),0) As Order_Quantity From Books b 
Left Join Orders o On b.Book_ID = O.Book_ID Group By b.Book_ID, b.Title, b.Stock Order By b.Book_ID;