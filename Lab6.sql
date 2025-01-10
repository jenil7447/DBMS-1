CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
-- Insert data into the Products table
INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000)

select * from Products

--Part - A
--1. Create a cursor Product_Cursor to fetch all the rows from a products table.
declare Product_Cursor cursor
for select * from Products
open Product_Cursor
declare @id int,@pname varchar(100),@price DECIMAL(10, 2)
fetch next from Product_Cursor into
	@id,@pname,@price
while @@FETCH_STATUS = 0
	begin
		print @id;
		print @pname;
		print @price;
		fetch next from Product_Cursor into
		@id,@pname,@price
	end
close Product_Cursor
deallocate Product_Cursor
	

--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. (Example: 1_Smartphone)
declare Product_Cursor_Fetch cursor
for select cast(Product_id as varchar)+'__'+Product_Name from Products
open Product_Cursor_Fetch
declare @product_info varchar(100)
fetch next from Product_Cursor_Fetch into
	@product_info
while @@FETCH_STATUS = 0
	begin
		print @product_info;
		fetch next from Product_Cursor_Fetch into
		@product_info
	end
close Product_Cursor_Fetch
deallocate Product_Cursor_Fetch

--3. Create a Cursor to Find and Display Products Above Price 30,000.
declare Product_Cursor_gt30000 cursor
for select * from Products where Price>30000;
open Product_Cursor_gt30000
declare @id int,@pname varchar(100),@price DECIMAL(10, 2)
fetch next from Product_Cursor_gt30000 into
	@id,@pname,@price
while @@FETCH_STATUS = 0
	begin
		print @id;
		print @pname;
		print @price;
		fetch next from Product_Cursor_gt30000 into
		@id,@pname,@price
	end
close Product_Cursor_gt30000
deallocate Product_Cursor_gt30000

--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
declare Product_CursorDelete cursor
for select Product_id from Products
open Product_CursorDelete
declare @id int
fetch next from Product_CursorDelete into
	@id
while @@FETCH_STATUS = 0
	begin
		delete from Products where Product_id=@id
		fetch next from Product_CursorDelete into
		@id
	end
close Product_CursorDelete
deallocate Product_CursorDelete

--Part – B
--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases the price by 10%.
declare Product_CursorUpdate cursor
for select * from Products
open Product_CursorUpdate
declare @id int,@pname varchar(100),@price DECIMAL(10, 2)
fetch next from Product_CursorUpdate into
	@id,@pname,@price
while @@FETCH_STATUS = 0
	begin
		update Products set Price = @price*1.10
		where Product_id = @id;
		print cast(@id as varchar)+'_'+@pname+'_'+cast(@price*1.10 as varchar)
		fetch next from Product_CursorUpdate into
		@id,@pname,@price
	end
close Product_CursorUpdate
deallocate Product_CursorUpdate
--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
declare Product_Round_Cursor cursor
for select Product_id,Price from Products
open Product_Round_Cursor
declare @id int,@price DECIMAL(10, 2)
fetch next from Product_Round_Cursor into
	@id,@price
while @@FETCH_STATUS = 0
	begin
		update Products set Price = ROUND(@price,0)
		where Product_id = @id;
		fetch next from Product_Round_Cursor into
		@id,@price
	end
select * from Products
close Product_Round_Cursor
deallocate Product_Round_Cursor

--Part – C
--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop”
--(Note: Create NewProducts table first with same fields as Products table)
CREATE TABLE NewProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);
declare Add_NewProduct_Cursor cursor
for select * from Products
open Add_NewProduct_Cursor
declare @id int,@pname varchar(100),@price DECIMAL(10, 2)
fetch next from Add_NewProduct_Cursor into
	@id,@pname,@price
while @@FETCH_STATUS = 0
	begin
		if @pname = 'Laptop'
			insert into NewProducts values(@id,@pname,@price)
		
		fetch next from Add_NewProduct_Cursor into
		@id,@pname,@price
	end
close Add_NewProduct_Cursor
deallocate Add_NewProduct_Cursor
select * from NewProducts

--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products
--with a price above 50000 to an archive table, removing them from the original Products table.